package moe.curstantine.riba.api.mangadex.services

import android.content.Context
import android.content.SharedPreferences
import android.content.SharedPreferences.Editor
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.DexBaseResponse
import moe.curstantine.riba.api.mangadex.models.DexUser
import moe.curstantine.riba.api.mangadex.models.DexUserAuthBody
import moe.curstantine.riba.api.mangadex.models.DexUserAuthRefreshBody
import moe.curstantine.riba.api.mangadex.models.DexUserAuthResponse
import moe.curstantine.riba.api.mangadex.models.DexUserAuthTokens
import moe.curstantine.riba.api.mangadex.models.toRibaUser
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaUser
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.POST

class UserService(
    context: Context,
    private val service: APIService,
    private val database: Database,
) : MangaDexService.Companion.Service(service, database) {
    override val coroutineScope = CoroutineScope(Dispatchers.IO)

    private val preferences: SharedPreferences = context.getSharedPreferences(
        DexConstants.USER_PREFERENCE,
        Context.MODE_PRIVATE
    )

    private val editor: Editor = preferences.edit()

    /**
     * The current logged in user.
     *
     * This is null by default, but will be populated after a successful [initialize] or a [login].
     */
    var current: RibaResult<RibaUser>? = null
        private set

    init {
        coroutineScope.launch {
            val sessionToken = getSessionToken()
            val refreshToken = getRefreshToken()
            val authTime = getAuthTime()

            if (sessionToken is RibaResult.Error ||
                refreshToken is RibaResult.Error ||
                authTime is RibaResult.Error
            ) {
                Log.e(DexLogTag.RESTRICTED.tag, "Failed to authenticate from older sessions.")
                return@launch
            }

            handleTokenExpiry(true)
        }
    }


    suspend fun login(
        username: String,
        password: String
    ): RibaResult<DexUserAuthResponse> = contextualInvoke {
        val response = service.login(DexUserAuthBody(username, password))
        it.launch {
            setPreferences(response.token)
            current = getCurrentUserDetails()
        }

        return@contextualInvoke response
    }

    private suspend fun refresh(refreshToken: String): RibaResult<DexUserAuthResponse> =
        contextualInvoke {
            val response = service.refresh(DexUserAuthRefreshBody(refreshToken))
            it.launch { setPreferences(response.token) }

            return@contextualInvoke response
        }

    suspend fun logout(): RibaResult<Unit> = contextualInvoke {
        handleTokenExpiry(true)
        service.logout(getRefreshToken().bubble())
        editor.remove("token").remove("refreshToken").remove("tokenExpiry").apply()
    }

    private suspend fun getCurrentUserDetails(): RibaResult<RibaUser> = contextualInvoke {
        val sessionToken = getSessionToken().bubble()
        val response = service.getCurrentUserDetails(sessionToken)
        val riba = response.data.toRibaUser()

        it.launch { database.insert(riba) }

        return@contextualInvoke riba
    }

    private fun getSessionToken(): RibaResult<String> {
        val session = preferences.getString("session", null)

        if (session == null) {
            val error = DexError.Companion.NotAuthenticated
            Log.e(
                DexLogTag.RESTRICTED.tag,
                "Tried to get the session token, but it was null.",
                error
            )

            return RibaResult.Error(error)
        }

        return RibaResult.Success(session)
    }

    private fun getRefreshToken(): RibaResult<String> {
        val refresh = preferences.getString("refresh", null)

        if (refresh == null) {
            val error = DexError.Companion.NotAuthenticated
            Log.e(
                DexLogTag.RESTRICTED.tag,
                "Tried to get the refresh token, but it was null.",
                error
            )

            return RibaResult.Error(error)
        }

        return RibaResult.Success(refresh)
    }

    /**
     * Last time the token was refreshed in seconds.
     */
    private fun getAuthTime(): RibaResult<Long> {
        val authTime = preferences.getLong("authTime", -1L)

        if (authTime == -1L) {
            val error = DexError.Companion.NotAuthenticated
            Log.e(
                DexLogTag.RESTRICTED.tag,
                "Tried to get the auth time, but it was null.",
                error
            )

            return RibaResult.Error(error)
        }

        return RibaResult.Success(authTime)
    }

    /**
     * @throws DexError.NotAuthenticated if the user is not logged in.
     */
    private suspend fun handleTokenExpiry(trySession: Boolean = true) {
        val timeElapsed = currentTimeSeconds() - getAuthTime().bubble()

        if (timeElapsed >= DexConstants.REFRESH_EXPIRY) {
            throw DexError.Companion.ReAuthenticationRequired
        } else if (trySession && timeElapsed >= DexConstants.SESSION_EXPIRY) {
            refresh(getRefreshToken().bubble())
        }
    }

    private fun setPreferences(tokens: DexUserAuthTokens) = editor
        .putString("refresh", tokens.refresh)
        .putString("session", tokens.session)
        .putLong("authTime", currentTimeSeconds())
        .apply()

    companion object {
        fun currentTimeSeconds(): Long = System.currentTimeMillis() / 1000L

        interface APIService : RibaHttpService.Companion.APIService {
            @POST("/auth/login")
            @Headers("Content-Type: application/json")
            suspend fun login(@Body body: DexUserAuthBody): DexUserAuthResponse

            @POST("/auth/refresh")
            @Headers("Content-Type: application/json")
            suspend fun refresh(@Body body: DexUserAuthRefreshBody): DexUserAuthResponse

            @POST("/auth/logout")
            suspend fun logout(@Header("Authorization") token: String): DexBaseResponse

            @GET("/user/me")
            suspend fun getCurrentUserDetails(@Header("Authorization") token: String): DexUser

        }

        class Database(private val database: DexDatabase) :
            RibaHttpService.Companion.Database(database) {
            suspend fun get(id: String): RibaUser? = database.user().get(id)

            suspend fun insert(user: RibaUser, force: Boolean = false) {
                val oldUser = get(user.id)

                if (force.not() && oldUser != null && oldUser.version >= user.version) {
                    return
                }

                database.user().insert(user)
            }
        }
    }
}