package moe.curstantine.mangodex.api.mangadex

import com.squareup.moshi.Moshi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import moe.curstantine.mangodex.api.mangadex.models.*
import moe.curstantine.mangodex.api.mangodex.Result
import retrofit2.HttpException

class MangaDexHandler(private var service: MangaDexService) {
    private val adapter = Moshi.Builder().build().adapter(DexErrorResponse::class.java)

    suspend fun getManga(id: String): Result<DexManga> {
        return contextualInvoke {
            try {
                Result.Success(service.getManga(id))
            } catch (e: HttpException) {
                Result.Error(parseException(e))
            }
        }
    }

    suspend fun getMangaList(
        ids: List<String>? = null,
        sort: Pair<DexQueryOrderProperty, DexQueryOrderValue>? = null
    ): Result<DexMangaCollection> {
        return contextualInvoke {
            try {
                Result.Success(
                    service.getMangaList(
                        ids = ids,
                        sort = sort?.let { mapOf(Pair(it.first.propertyStr, it.second)) }
                            ?: mapOf(),
                    )
                )
            } catch (e: HttpException) {
                Result.Error(parseException(e))
            }
        }
    }

    suspend fun getMDList(id: String): Result<DexMDList> {
        return contextualInvoke {
            try {
                Result.Success(service.getMDList(id))
            } catch (e: HttpException) {
                Result.Error(parseException(e))
            }
        }
    }

    private suspend fun <T> contextualInvoke(call: suspend () -> T): T {
        return withContext(Dispatchers.IO) {
            call.invoke()
        }
    }

    private fun parseException(e: HttpException): DexInternalError {
        val errorBody = e.response()?.errorBody()?.source()?.let { adapter.fromJson(it) }

        return if (errorBody != null) {
            val dexError = errorBody.errors.elementAt(0)
            DexInternalError(dexError.title, dexError.detail)
        } else {
            DexErrorFactory.fromStatusCode(e.code())
        }
    }
}