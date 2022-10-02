package moe.curstantine.riba.api.mangadex

import android.util.Log
import com.squareup.moshi.JsonDataException
import com.squareup.moshi.Moshi
import moe.curstantine.riba.api.mangadex.DexError.Companion.tryHandle
import moe.curstantine.riba.api.mangadex.models.DexErrorResponse
import moe.curstantine.riba.api.riba.RibaIntlError
import retrofit2.HttpException
import java.sql.SQLException
import java.util.Locale

/**
 * [RibaIntlError] implementation for [MangaDexService] errors.
 *
 * Try to use [tryHandle] as much as possible, it'll does all the required background work for you
 * (logging, human-readable errors and etc).
 *
 * @param human Human-readable error message.
 * @param additional Additional information about the error.
 */
open class DexError(override val human: String, override var additional: String?) : RibaIntlError {
    fun setAdditional(additional: String?): DexError {
        this.additional = additional
        return this
    }

    companion object {
        private val moshiAdapter = Moshi.Builder().build().adapter(DexErrorResponse::class.java)

        object HTTP503 : DexError(
            "MangaDex servers are down for maintenance!", "Status Code: 503"
        )

        object Unknown : DexError(
            "Oof, came across an unknown error while trying to reach MangaDex!", null
        )

        object InvalidJSON : DexError(
            "MangaDex returned an invalid JSON response!", null
        )

        object DatabaseError : DexError(
            "Came across an error while trying to access the database!", null
        )

        fun tryHandle(e: Throwable): DexError {
            Log.e("DexError", e.stackTraceToString())

            return when (e) {
                is HttpException -> fromHttpException(e)
                is JsonDataException -> InvalidJSON.setAdditional(e.message)
                is SQLException -> DatabaseError.setAdditional(e.message)
                else -> Unknown.setAdditional(e.message)
            }
        }

        private fun fromHttpException(e: HttpException): DexError {
            val errorBody = e.response()?.errorBody()?.source()?.let { moshiAdapter.fromJson(it) }

            return if (errorBody?.errors?.isNotEmpty() == true) {
                val err = errorBody.errors.elementAt(0)
                val title = err.title.split("_").joinToString(" ") { str ->
                    str.replaceFirstChar { it.titlecase(Locale.getDefault()) }
                }

                DexError(title, err.detail)
            } else {
                when (val code = e.code()) {
                    503 -> HTTP503
                    else -> Unknown.setAdditional(code.toString())
                }
            }
        }
    }
}