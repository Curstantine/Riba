package moe.curstantine.riba.api.mangadex.services

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.DexBaseResponseImpl
import moe.curstantine.riba.api.mangadex.models.DexUser
import moe.curstantine.riba.api.mangadex.models.DexUserAuthBody
import moe.curstantine.riba.api.mangadex.models.DexUserAuthRefreshBody
import moe.curstantine.riba.api.mangadex.models.DexUserAuthResponse
import moe.curstantine.riba.api.mangadex.models.DexUserAuthTokens
import moe.curstantine.riba.api.mangadex.models.DexUserCollection
import moe.curstantine.riba.api.mangadex.models.toRibaUser
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaUser
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.POST
import retrofit2.http.Query
import kotlin.coroutines.CoroutineContext

// TODO: Implement Guest/Anon
class UserService(
    context: Context,
    override val service: APIService,
    override val database: Database,
) : MangaDexService.Companion.Service() {
    override val coroutineScope = CoroutineScope(Dispatchers.IO)

    private val preferences: SharedPreferences = context.getSharedPreferences(
        DexConstants.USER_PREFERENCE,
        Context.MODE_PRIVATE
    )

    private val current: MutableLiveData<RibaResult<RibaUser>> = MutableLiveData()

    /**
     * Getter for the current user.
     *
     * @return Will contain
     * - [RibaResult.Error] with [DexError.NotAuthenticated] if the user is not signed in.
     * - [RibaResult.Error] with [DexError.ReAuthenticationRequired]
     *   if the user is signed in, but will need a re-authentication due to expired tokens.
     */
    fun getCurrent(): LiveData<RibaResult<RibaUser>> = current

    init {
        coroutineScope.launch {
            try {
                handleTokenExpiry()
                current.postValue(getCurrentUserDetails())
            } catch (e: DexError) {
                current.postValue(RibaResult.Error(e))
                Log.w(DexLogTag.DEBUG.tag, "Failed to handle token expiry", e)
            }
        }
    }

    suspend fun login(
        username: String,
        password: String
    ): RibaResult<DexUserAuthResponse> = contextualInvoke {
        val response = service.login(DexUserAuthBody(username, password))
        Log.d(DexLogTag.DEBUG.tag, "Login response: ${response.result}")

        it.launch {
            val details = getCurrentUserDetails(sessionOverride = response.token.session)
            setPreferences(details.unwrap().id, response.token)
            current.postValue(details)
        }

        return@contextualInvoke response
    }

    suspend fun logout(): RibaResult<DexBaseResponseImpl> = contextualInvoke {
        handleTokenExpiry()
        val response = service.logout(getSessionToken())
        Log.d(DexLogTag.DEBUG.tag, "Logout response: ${response.result}")

        it.launch {
            removePreferences()
            current.postValue(RibaResult.Error(DexError.Companion.NotAuthenticated))
        }

        return@contextualInvoke response
    }

    private suspend fun refresh(refreshToken: String): RibaResult<DexUserAuthResponse> =
        contextualInvoke {
            val response = service.refresh(DexUserAuthRefreshBody(refreshToken))
            Log.d(DexLogTag.DEBUG.tag, "Refresh response: ${response.result}")

            it.launch {
                setPreferences(getUserId(), response.token)
                current.postValue(getCurrentUserDetails(tryDatabase = true))
            }

            return@contextualInvoke response
        }

    /**
     * @param sessionOverride overrides the [getSessionToken] with the given token.
     */
    private suspend fun getCurrentUserDetails(
        sessionOverride: String? = null,
        tryDatabase: Boolean = false
    ): RibaResult<RibaUser> = contextualInvoke {
        if (tryDatabase) {
            try {
                return@contextualInvoke database.get(getUserId())!!
            } catch (e: Throwable) {
                Log.w(
                    DexLogTag.DEBUG.tag,
                    "tryDatabase was true, but user was not in the database, continuing to fetch.",
                    e
                )
            }
        }

        val response = service
            .getCurrentUserDetails(sessionOverride ?: getSessionToken())
            .data.toRibaUser()

        it.launch { database.insert(response) }

        return@contextualInvoke response
    }

    /**
     * @throws DexError.NotAuthenticated if the user is not signed in.
     */
    private fun getUserId(): String {
        return preferences.getString("user", null) ?: throw DexError.Companion.NotAuthenticated
    }

    /**
     * @throws DexError.NotAuthenticated if the user is not signed in.
     */
    private fun getSessionToken(prefixed: Boolean = true): String {
        return preferences.getString("session", null)?.apply {
            if (prefixed) return "Bearer $this"
        } ?: throw  DexError.Companion.NotAuthenticated
    }

    /**
     * @throws DexError.NotAuthenticated if the user is not signed in.
     */
    private fun getRefreshToken(): String {
        return preferences.getString("refresh", null) ?: throw DexError.Companion.NotAuthenticated
    }

    /**
     * Last time the token was refreshed in seconds.
     *
     * @throws DexError.NotAuthenticated if the user is not signed in.
     */
    private fun getAuthTime(): Long {
        val authTime = preferences.getLong("authTime", -1L)
        if (authTime == -1L) throw DexError.Companion.NotAuthenticated

        return authTime
    }

    /**
     * Handles expired tokens intelligently.
     *
     * @throws DexError.NotAuthenticated if the user is not logged in.
     * @throws DexError.ReAuthenticationRequired if the user is logged in, but will need a re-authentication due to expired tokens.
     */
    private suspend fun handleTokenExpiry() {
        val timeElapsed = currentTimeSeconds() - getAuthTime()

        if (timeElapsed >= DexConstants.REFRESH_EXPIRY) {
            Log.d(DexLogTag.DEBUG.tag, "Refresh token expired, need to re-authenticate.")
            throw DexError.Companion.ReAuthenticationRequired
        } else if (timeElapsed >= DexConstants.SESSION_EXPIRY) {
            Log.d(DexLogTag.DEBUG.tag, "Session token expired, refreshing.")
            refresh(getRefreshToken())
        }
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
        ids: List<String>? = null,
        username: String? = null,
        limit: Int? = 10,
        offset: Int? = null,
    ): RibaResult<List<RibaUser>> = contextualInvoke { scope ->
        handleTokenExpiry()
        val response = service.getCollection(
            token = getSessionToken(),
            ids = ids,
            username = username,
            limit = limit,
            offset = offset
        )

        val riba = response.data.map { it.toRibaUser() }
        scope.launch { database.insertCollection(coroutineContext, riba) }

        return@contextualInvoke riba
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

                if (force.not() && oldUser != null && oldUser.version >= user.version) {
                    return
                }

                database.user().insert(user)
            }

            suspend fun insertCollection(
                context: CoroutineContext,
                users: List<RibaUser>,
                force: Boolean = false
            ) = withContext(context) {
                val userJob = this.async { users.associateBy { it.id } }
                val oldUserJob = this.async {
                    getCollection(users.map { it.id }).associateBy { it.id }
                }

                val oldUserMap = oldUserJob.await()
                val userMap = userJob.await()

                for ((id, newThis) in userMap) {
                    val oldThis = oldUserMap[id]

                    if (force.not() && oldThis != null && oldThis.version >= newThis.version) {
                        continue
                    } else {
                        launch { database.user().insert(newThis) }
                    }
                }
            }
        }
    }
}