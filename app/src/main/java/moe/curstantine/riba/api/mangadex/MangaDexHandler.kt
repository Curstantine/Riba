package moe.curstantine.riba.api.mangadex

import com.squareup.moshi.Moshi
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.mangadex.models.DexAuthor
import moe.curstantine.riba.api.mangadex.models.DexAuthorCollection
import moe.curstantine.riba.api.mangadex.models.DexCover
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexErrorResponse
import moe.curstantine.riba.api.mangadex.models.DexMDList
import moe.curstantine.riba.api.mangadex.models.DexManga
import moe.curstantine.riba.api.mangadex.models.DexMangaCollection
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.riba.RibaError
import moe.curstantine.riba.api.riba.RibaResult
import retrofit2.HttpException
import java.util.Locale

class MangaDexHandler(
    private var service: MangaDexService,
    private var database: DexDatabaseHandler
) {
    private val adapter = Moshi.Builder().build().adapter(DexErrorResponse::class.java)

    suspend fun getAuthor(id: String, forceInsert: Boolean = false): RibaResult<DexAuthor> {
        return contextualInvoke {
            try {
                val response = service.getAuthor(id)
                it.launch { database.insertAuthor(response.data, forceInsert) }

                RibaResult.Success(response)
            } catch (e: Throwable) {
                RibaResult.Error(handleException(e))
            }
        }
    }

    suspend fun getAuthor(
        ids: List<String>? = null,
        limit: Int = 10,
        offset: Int? = null,
        includes: List<DexEntityType>? = null,
        forceInsert: Boolean = false
    ): RibaResult<DexAuthorCollection> {
        return contextualInvoke { scope ->
            try {
                val response = service.getAuthor(ids, limit, offset, includes)
                scope.launch { response.data.forEach { database.insertAuthor(it, forceInsert) } }

                RibaResult.Success(response)
            } catch (e: Throwable) {
                RibaResult.Error(handleException(e))
            }
        }
    }

    suspend fun getCover(id: String, forceInsert: Boolean = false): RibaResult<DexCover> {
        return contextualInvoke {
            try {
                val response = service.getCover(id)
                it.launch { database.insertCover(response.data, forceInsert) }

                RibaResult.Success(response)
            } catch (e: Throwable) {
                RibaResult.Error(handleException(e))
            }
        }
    }

    suspend fun getManga(
        id: String,
        includes: List<DexEntityType>? = null,
        forceInsert: Boolean = false
    ): RibaResult<DexManga> {
        return contextualInvoke { scope ->
            try {
                val response = service.getManga(id, includes)
                scope.launch { database.insertManga(response.data, forceInsert) }

                RibaResult.Success(response)
            } catch (e: Throwable) {
                RibaResult.Error(handleException(e))
            }
        }
    }

    suspend fun getManga(
        ids: List<String>? = null,
        limit: Int = 10,
        offset: Int? = null,
        sort: Pair<DexQueryOrderProperty, DexQueryOrderValue>? = null,
        includes: List<DexEntityType>? = null, forceInsert: Boolean = false
    ): RibaResult<DexMangaCollection> {
        return contextualInvoke { scope ->
            try {
                val response = service.getManga(
                    ids = ids,
                    limit = limit,
                    offset = offset,
                    includes = includes,
                    sort = sort?.let { mapOf(Pair(it.first.propStr, it.second)) } ?: mapOf()
                )

                scope.launch { response.data.forEach { database.insertManga(it, forceInsert) } }

                RibaResult.Success(response)
            } catch (e: Throwable) {
                RibaResult.Error(handleException(e))
            }
        }
    }

    suspend fun getMDList(id: String, forceInsert: Boolean = false): RibaResult<DexMDList> {
        return contextualInvoke {
            try {
                val response = service.getMDList(id)
                it.launch { database.insertMDList(response.data, forceInsert) }

                RibaResult.Success(response)
            } catch (e: Throwable) {
                RibaResult.Error(handleException(e))
            }
        }
    }

    private suspend fun <T> contextualInvoke(call: suspend (it: CoroutineScope) -> T): T {
        return withContext(Dispatchers.IO) {
            call.invoke(this)
        }
    }

    private fun handleException(e: Throwable): RibaError {
        return when (e) {
            is HttpException -> parseHttpException(e)
            else -> RibaError.tryHandle(e)
        }
    }

    private fun parseHttpException(e: HttpException): RibaError {
        val errorBody = e.response()?.errorBody()?.source()?.let { adapter.fromJson(it) }

        return if (errorBody != null) {
            val dexError = errorBody.errors.elementAt(0)

            val humanTitle = dexError.title.split("_").map { str ->
                str.replaceFirstChar {
                    it.titlecase(Locale.getDefault())
                }
            }

            RibaError(humanTitle.joinToString(" "), dexError.detail)
        } else {
            RibaError("", "")
        }
    }
}