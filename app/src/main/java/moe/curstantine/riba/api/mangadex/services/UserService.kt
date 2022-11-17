package moe.curstantine.riba.api.mangadex.services

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.*
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.models.RibaUser
import retrofit2.http.*

// TODO: Implement Guest/Anon
class UserService(
	context: Context,
	globalCoroutineScope: CoroutineScope,
	override val service: APIService,
	override val database: Database,
) : RibaHttpService() {
	private val preferences: SharedPreferences = context.getSharedPreferences(
		DexConstants.USER_PREFERENCE,
		Context.MODE_PRIVATE
	)

	private val _currentUser = MutableStateFlow<RibaUser?>(null)
	val currentUser: StateFlow<RibaUser?> = _currentUser.asStateFlow()

	init {
		globalCoroutineScope.launch {
			try {
				handleTokenExpiry()
				_currentUser.emit(getCurrentUserDetails(tryDatabase = true))
			} catch (e: DexError) {
				Log.w(DexLogTag.DEBUG.tagName, "Failed to handle token expiry", e)
			}
		}
	}

	suspend fun login(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		username: String,
		password: String
	): DexUserAuthResponse = withContext(dispatcher) {
		val response = service.login(DexUserAuthBody(username, password))

		launch {
			val details = getCurrentUserDetails(sessionOverride = response.token.session)
			setPreferences(details.id, response.token)
			_currentUser.emit(details)
		}

		return@withContext response
	}

	suspend fun logout(
		dispatcher: CoroutineDispatcher = Dispatchers.Default
	): DexBaseResponseImpl = withContext(dispatcher) {
		handleTokenExpiry()
		val response = service.logout(getSessionToken())
		Log.d(DexLogTag.DEBUG.tagName, "Logout response: ${response.result}")

		launch {
			removePreferences()
			_currentUser.emit(null)
		}

		return@withContext response
	}

	private suspend fun refresh(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		refreshToken: String
	): DexUserAuthResponse = withContext(dispatcher) {
		val response = service.refresh(DexUserAuthRefreshBody(refreshToken))
		launch {
			setPreferences(getUserId(), response.token)
			_currentUser.emit(getCurrentUserDetails(tryDatabase = true))
		}

		return@withContext response
	}

	/**
	 * @param sessionOverride overrides the [getSessionToken] with the given token.
	 */
	private suspend fun getCurrentUserDetails(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		sessionOverride: String? = null,
		tryDatabase: Boolean = false
	): RibaUser = withContext(dispatcher) {
		if (tryDatabase) {
			val local = database.get(getUserId())

			if (local != null) return@withContext local else {
				Log.w(
					DexLogTag.DEBUG.tagName,
					"tryDatabase was true, but user was not in the database," +
						" continuing to fetch.",
				)
			}
		}

		val response = service
			.getCurrentUserDetails(sessionOverride ?: getSessionToken())
			.data.toRibaUser()

		launch { database.insert(response) }
		return@withContext response
	}

	/**
	 * Handles expired tokens intelligently.
	 *
	 * @throws DexError.NotAuthenticated if the user is not logged in.
	 * @throws DexError.ReAuthenticationRequired if the user is logged in, but will need a re-authentication due to expired tokens.
	 */
	suspend fun handleTokenExpiry(
		dispatcher: CoroutineDispatcher = Dispatchers.Default
	) = withContext(dispatcher) {
		val timeElapsed = currentTimeSeconds() - getAuthTime()

		if (timeElapsed >= DexConstants.REFRESH_EXPIRY) {
			Log.d(DexLogTag.DEBUG.tagName, "Refresh token expired, need to re-authenticate.")
			throw DexError.ReAuthenticationRequired
		} else if (timeElapsed >= DexConstants.SESSION_EXPIRY) {
			Log.d(DexLogTag.DEBUG.tagName, "Session token expired, refreshing.")
			refresh(dispatcher, getRefreshToken())
		}
	}

	/**
	 * @throws DexError.NotAuthenticated if the user is not signed in.
	 */
	fun getUserId(): String {
		return preferences.getString("user", null) ?: throw DexError.NotAuthenticated
	}

	/**
	 * @throws DexError.NotAuthenticated if the user is not signed in.
	 */
	fun getSessionToken(prefixed: Boolean = true): String {
		return preferences.getString("session", null)
			?.apply { if (prefixed) return "Bearer $this" }
			?: throw DexError.NotAuthenticated
	}

	/**
	 * @throws DexError.NotAuthenticated if the user is not signed in.
	 */
	private fun getRefreshToken(): String {
		return preferences.getString("refresh", null) ?: throw DexError.NotAuthenticated
	}

	/**
	 * Last time the token was refreshed in seconds.
	 *
	 * @throws DexError.NotAuthenticated if the user is not signed in.
	 */
	private fun getAuthTime(): Long {
		val authTime = preferences.getLong("authTime", -1L)
		if (authTime == -1L) throw DexError.NotAuthenticated

		return authTime
	}

	private fun setPreferences(userId: String, tokens: DexUserAuthTokens) = preferences.edit()
		.putString("user", userId)
		.putString("refresh", tokens.refresh)
		.putString("session", tokens.session)
		.putLong("authTime", currentTimeSeconds())
		.apply()

	private fun removePreferences() = preferences.edit()
		.remove("user")
		.remove("refresh")
		.remove("session")
		.remove("authTime")
		.apply()

	/**
	 * NOTE: This method needs authentication.
	 */
	suspend fun getCollection(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		ids: List<String>? = null,
		username: String? = null,
		limit: Int? = 10,
		offset: Int? = null,
	): List<RibaUser> = withContext(dispatcher) {
		handleTokenExpiry()
		val response = service.getCollection(
			token = getSessionToken(),
			ids = ids,
			username = username,
			limit = limit,
			offset = offset
		)

		val riba = response.data.map { it.toRibaUser() }
		launch { database.insertCollection(dispatcher, riba) }

		return@withContext riba
	}

	companion object {
		private fun currentTimeSeconds(): Long = System.currentTimeMillis() / 1000L

		interface APIService : RibaHttpService.Companion.APIService {
			@POST("/auth/login")
			@Headers("Content-Type: application/json")
			suspend fun login(@Body body: DexUserAuthBody): DexUserAuthResponse

			@POST("/auth/refresh")
			@Headers("Content-Type: application/json")
			suspend fun refresh(@Body body: DexUserAuthRefreshBody): DexUserAuthResponse

			@POST("/auth/logout")
			suspend fun logout(@Header("Authorization") token: String): DexBaseResponseImpl

			@GET("/user/me")
			suspend fun getCurrentUserDetails(@Header("Authorization") token: String): DexUser

			@GET("/user")
			suspend fun getCollection(
				@Header("Authorization") token: String,
				@Query("ids[]") ids: List<String>?,
				@Query("username") username: String?,
				@Query("limit") limit: Int?,
				@Query("offset") offset: Int?,
			): DexUserCollection
		}

		class Database(private val database: DexDatabase) :
			RibaHttpService.Companion.Database(database) {
			suspend fun get(id: String): RibaUser? = database.user().get(id)
			suspend fun getCollection(ids: List<String>): List<RibaUser> = database.user().get(ids)

			suspend fun insert(user: RibaUser, force: Boolean = false) {
				val oldUser = get(user.id)

				if (!(force.not() && oldUser != null && user.isOlderThan(oldUser))) {
					database.user().insert(user)
				}
			}

			suspend fun insertCollection(
				dispatcher: CoroutineDispatcher = Dispatchers.Default,
				users: List<RibaUser>,
				force: Boolean = false
			) = withContext(dispatcher) {
				val userJob = this.async { users.associateBy { it.id } }
				val oldUserJob = this.async { getCollection(users.map { it.id }).associateBy { it.id } }

				val oldUserMap = oldUserJob.await()
				val userMap = userJob.await()

				for ((id, newThis) in userMap) {
					val oldThis = oldUserMap[id]

					if (force.not() && oldThis != null && newThis.isOlderThan(oldThis)) continue
					else launch { database.user().insert(newThis) }
				}
			}
		}
	}
}