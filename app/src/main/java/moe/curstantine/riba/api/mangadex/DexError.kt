package moe.curstantine.riba.api.mangadex

import android.util.Log
import com.squareup.moshi.JsonDataException
import kotlinx.coroutines.CancellationException
import moe.curstantine.riba.api.mangadex.DexError.Companion.tryHandle
import moe.curstantine.riba.api.mangadex.models.DexErrorAttributes
import moe.curstantine.riba.api.mangadex.models.DexErrorResponse
import moe.curstantine.riba.api.mangadex.models.DexResult
import moe.curstantine.riba.api.riba.RibaError
import retrofit2.HttpException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import java.sql.SQLException
import java.util.*

/**
 * [Throwable] implementation for [MangaDexService] errors.
 *
 * Try to use [tryHandle] as much as possible, it does all the required background work for you
 * (logging, human-readable errors and etc).
 *
 * @param message Human-readable error message.
 * @param _additional Additional information about the error.
 * @param cause Original error.
 */
open class DexError(
	override val message: String,
	override var _additional: String? = null,
	override var cause: Throwable? = null,
) : RibaError(message, _additional, cause) {
	// @formatter:off
	object Unknown : DexError("Unknown error occurred while reaching MangaDex!")
	object InvalidJSON : DexError("MangaDex returned an invalid JSON response!")
	object DatabaseError : DexError("Came across an error while trying to access the database!")
	object HTTP503 : DexError("MangaDex servers are down for maintenance!", "Status Code: 503")
	object NotAuthenticated : DexError("User not authenticated!", "This action requires the user to be authenticated.")
	object ReAuthenticationRequired : DexError("Re-authentication required!", "Both the session and refresh tokens are invalid.")
	object MissingChapterData : DexError("Failed to retrieve chapter data!", "Expected groups and uploader to be an exact match with chapter, but failed.")
	object NoInternet : DexError("Cannot reach MangaDex!", "You need a stable internet connection to fetch data from MangaDex.")
	object MissingTags: DexError("Failure while resolving tags!")

	fun log(tag: DexLogTag = DexLogTag.DEBUG, priority: Int = Log.DEBUG) = super.log(tag, priority)

	companion object {
		fun tryHandle(e: Throwable): RibaError = when (e) {
			is DexError -> e
			is RibaError -> e
			is SocketTimeoutException,
			is UnknownHostException -> NoInternet
			is HttpException -> fromHttpException(e)
			is JsonDataException -> InvalidJSON.setCause(e, true) as DexError
			is SQLException -> DatabaseError.setCause(e, true) as DexError
			is CancellationException -> {
				Log.e("Wtf", "CancellationException is not supposed to be here!")
				throw e
			}
			else -> Unknown.setCause(e, true) as DexError
		}

		private fun fromHttpException(e: HttpException): DexError {
			val errorBody = e.response()?.errorBody()?.source()?.let {
				try {
					MangaDexService.Serde.errorResponseAdapter.fromJson(it)
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

				DexError(title, err.detail, e)
			} else when (val code = e.code()) {
				503 -> HTTP503
				else -> Unknown.setCause(e, false).setAdditional("Status Code: $code") as DexError
			}
		}
	}
}