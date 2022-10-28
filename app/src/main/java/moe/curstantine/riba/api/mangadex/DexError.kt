package moe.curstantine.riba.api.mangadex

import com.squareup.moshi.JsonDataException
import com.squareup.moshi.adapter
import moe.curstantine.riba.api.mangadex.DexError.Companion.tryHandle
import moe.curstantine.riba.api.mangadex.models.DexErrorAttributes
import moe.curstantine.riba.api.mangadex.models.DexErrorResponse
import moe.curstantine.riba.api.mangadex.models.DexResult
import moe.curstantine.riba.api.riba.RibaError
import retrofit2.HttpException
import java.sql.SQLException
import java.util.Locale

/**
 * [RibaError] implementation for [MangaDexService] errors.
 *
 * Try to use [tryHandle] as much as possible, it'll does all the required background work for you
 * (logging, human-readable errors and etc).
 *
 * @param human Human-readable error message.
 * @param additional Additional information about the error.
 */
open class DexError(
    override val human: String,
    override val additional: String? = null
) : RibaError, Throwable(
    "$human:${additional.orEmpty().let { if (it.isNotEmpty()) "\n$it" else it }}"
) {
    @Suppress("MemberVisibilityCanBePrivate", "FunctionName")
    companion object {
        fun Unknown(additional: String?) =
            DexError("Unknown error occurred while reaching MangaDex!", additional)

        fun InvalidJSON(additional: String?) =
            DexError("MangaDex returned an invalid JSON response!", additional)

        fun DatabaseError(additional: String?) =
            DexError("Came across an error while trying to access the database!", additional)

        object HTTP503 : DexError(
            "MangaDex servers are down for maintenance!",
            "Status Code: 503"
        )

        object NotAuthenticated : DexError(
            "User not authenticated!",
            "This action requires the user to be authenticated."
        )

        object ReAuthenticationRequired : DexError(
            "Re-authentication required!",
            "Both the session and refresh tokens are invalid."
        )

        object MissingChapterData : DexError(
            "Failed to retrieve chapter data!",
            "Expected groups and uploader to be an exact match with chapter, but failed."
        )

        fun tryHandle(e: Throwable): DexError {
            return when (e) {
                is DexError -> e
                is HttpException -> fromHttpException(e)
                is JsonDataException -> InvalidJSON(e.message)
                is SQLException -> DatabaseError(e.message)
                else -> Unknown(e.stackTraceToString())
            }
        }

        fun fromHttpException(e: HttpException): DexError {
            val errorBody = e.response()?.errorBody()?.source()?.let {
                try {
                    MangaDexService.dexMoshi.adapter<DexErrorResponse>().fromJson(it)
                } catch (e: Throwable) {
                    val error = DexErrorAttributes(
                        id = "",
                        status = 418,
                        title = it.readUtf8(),
                        detail = e.message,
                    )

                    DexErrorResponse(DexResult.Error, listOf(error))
                }
            }

            return if (errorBody?.errors?.isNotEmpty() == true) {
                val err = errorBody.errors.elementAt(0)
                val title = err.title.split("_").joinToString(" ") { str ->
                    str.replaceFirstChar { it.titlecase(Locale.getDefault()) }
                }

                DexError(title, err.detail)
            } else {
                when (val code = e.code()) {
                    503 -> HTTP503
                    else -> Unknown("HTTP Code: $code")
                }
            }
        }
    }
}