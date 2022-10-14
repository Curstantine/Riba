package moe.curstantine.riba.api.mangadex.services

import android.content.Context
import android.content.SharedPreferences
import android.content.SharedPreferences.Editor
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import moe.curstantine.riba.api.database.RibaDatabase
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.models.DexBaseResponse
import moe.curstantine.riba.api.mangadex.models.DexUserAuthBody
import moe.curstantine.riba.api.mangadex.models.DexUserAuthRefreshBody
import moe.curstantine.riba.api.mangadex.models.DexUserAuthResponse
import moe.curstantine.riba.api.mangadex.models.DexUserAuthTokens
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import retrofit2.http.Body
import retrofit2.http.Header
import retrofit2.http.Headers
import retrofit2.http.POST

class UserService(
    private val service: APIService,
    private val database: Database,
) : MangaDexService.Companion.Service(service, database) {
    override val coroutineScope = CoroutineScope(Dispatchers.IO)

    suspend fun login(
        editor: Editor,
        username: String,
        password: String
    ): RibaResult<DexUserAuthResponse> =
        contextualInvoke {
            val response = service.login(DexUserAuthBody(username, password))
            it.launch { setPreferences(editor, response.token) }

            return@contextualInvoke response
        }

    suspend fun refresh(editor: Editor, refreshToken: String): RibaResult<DexUserAuthResponse> =
        contextualInvoke {
            val response = service.refresh(DexUserAuthRefreshBody(refreshToken))
            it.launch { setPreferences(editor, response.token) }

            return@contextualInvoke response
        }

    suspend fun logout(editor: Editor, preferences: SharedPreferences): RibaResult<Unit> =
        contextualInvoke {
            handleTokenExpiry(editor, preferences, false)
            editor.remove("token").remove("refreshToken").remove("tokenExpiry").apply()
        }

    fun getSessionToken(preferences: SharedPreferences): RibaResult<String> {
        val session = preferences.getString("session", null)

        if (session == null) {
            val error = DexError.Companion.NotAuthenticated
            Log.e(
                DexError.Companion.LogTag.RESTRICTED.tag,
                "Tried to get the session token, but it was null.",
                error
            )

            return RibaResult.Error(error)
        }

        return RibaResult.Success(session)
    }

    fun getRefreshToken(preferences: SharedPreferences): RibaResult<String> {
        val refresh = preferences.getString("refresh", null)

        if (refresh == null) {
            val error = DexError.Companion.NotAuthenticated
            Log.e(
                DexError.Companion.LogTag.RESTRICTED.tag,
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
    private fun getAuthTime(preferences: SharedPreferences): RibaResult<Long> {
        val authTime = preferences.getLong("authTime", -1L)

        if (authTime == -1L) {
            val error = DexError.Companion.NotAuthenticated
            Log.e(
                DexError.Companion.LogTag.RESTRICTED.tag,
                "Tried to get the auth time, but it was null.",
                error
            )

            return RibaResult.Error(error)
        }

        return RibaResult.Success(authTime)
    }

    private suspend fun handleTokenExpiry(
        editor: Editor,
        preferences: SharedPreferences,
        trySession: Boolean = true
    ) {
        val timeElapsed = currentTimeSeconds() - getAuthTime(preferences).bubble()

        if (timeElapsed >= DexConstants.REFRESH_EXPIRY) {
            throw DexError.Companion.ReAuthenticationRequired
        } else if (trySession && timeElapsed >= DexConstants.SESSION_EXPIRY) {
            refresh(editor, getRefreshToken(preferences).bubble())
        }
    }

    private fun setPreferences(editor: Editor, tokens: DexUserAuthTokens) = editor
        .putString("refresh", tokens.refresh)
        .putString("session", tokens.session)
        .putLong("authTime", currentTimeSeconds())
        .apply()

    companion object {
        @Composable
        fun getSharedPreferences(): SharedPreferences {
            return LocalContext.current.getSharedPreferences("MangaDex-User", Context.MODE_PRIVATE)
        }

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
        }

        class Database(database: RibaDatabase) :
            RibaHttpService.Companion.Database(database)
    }
}