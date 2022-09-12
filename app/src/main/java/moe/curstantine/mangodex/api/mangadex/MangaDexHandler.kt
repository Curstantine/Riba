package moe.curstantine.mangodex.api.mangadex

import com.squareup.moshi.JsonDataException
import com.squareup.moshi.Moshi
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.mangodex.api.mangadex.models.*
import moe.curstantine.mangodex.api.mangodex.Result
import retrofit2.HttpException
import java.sql.SQLException
import java.util.*

// TODO: Remove database and move to database handler as param
class MangaDexHandler(
    private var service: MangaDexService,
    private var databaseHandler: MangaDexDatabaseHandler
) {
    private val adapter = Moshi.Builder().build().adapter(DexErrorResponse::class.java)

    suspend fun getAuthor(id: String): Result<DexAuthor> {
        return contextualInvoke {
            try {
                val response = service.getAuthor(id)
                it.launch { databaseHandler.insertAuthor(response.data) }

                Result.Success(response)
            } catch (e: Throwable) {
                Result.Error(handleException(e))
            }
        }
    }

    suspend fun getCover(id: String): Result<DexCover> {
        return contextualInvoke {
            try {
                val response = service.getCover(id)
                it.launch { databaseHandler.insertCover(response.data) }

                Result.Success(response)
            } catch (e: Throwable) {
                Result.Error(handleException(e))
            }
        }
    }

    suspend fun getManga(id: String, includes: List<DexEntityType>? = null): Result<DexManga> {
        return contextualInvoke { scope ->
            try {
                val response = service.getManga(id, includes)
                scope.launch { databaseHandler.insertManga(response.data) }

                Result.Success(response)
            } catch (e: Throwable) {
                Result.Error(handleException(e))
            }
        }
    }

    suspend fun getManga(
        ids: List<String>? = null,
        limit: Int = 10,
        offset: Int? = null,
        sort: Pair<DexQueryOrderProperty, DexQueryOrderValue>? = null,
        includes: List<DexEntityType>? = null,
    ): Result<DexMangaCollection> {
        return contextualInvoke { scope ->
            try {
                val response = service.getManga(
                    ids = ids,
                    limit = limit,
                    offset = offset,
                    includes = includes,
                    sort = sort?.let { mapOf(Pair(it.first.propStr, it.second)) } ?: mapOf()
                )

                scope.launch { response.data.map { databaseHandler.insertManga(it) } }

                Result.Success(response)
            } catch (e: Throwable) {
                Result.Error(handleException(e))
            }
        }
    }

    suspend fun getMDList(id: String): Result<DexMDList> {
        return contextualInvoke {
            try {
                val response = service.getMDList(id)
                it.launch { databaseHandler.insertMDList(response.data) }

                Result.Success(response)
            } catch (e: Throwable) {
                Result.Error(handleException(e))
            }
        }
    }

    private suspend fun <T> contextualInvoke(call: suspend (it: CoroutineScope) -> T): T {
        return withContext(Dispatchers.IO) {
            call.invoke(this)
        }
    }

    private fun handleException(e: Throwable): DexInternalError {
        return when (e) {
            is HttpException -> parseHttpException(e)
            is JsonDataException -> DexInternalError("Invalid JSON response", e.message)
            is SQLException -> DexInternalError("Database error", e.message)
            else -> DexInternalError("Unknown error", e.message)
        }
    }

    private fun parseHttpException(e: HttpException): DexInternalError {
        val errorBody = e.response()?.errorBody()?.source()?.let { adapter.fromJson(it) }

        return if (errorBody != null) {
            val dexError = errorBody.errors.elementAt(0)

            val humanTitle = dexError.title.split("_").map { str ->
                str.replaceFirstChar {
                    it.titlecase(Locale.getDefault())
                }
            }

            DexInternalError(humanTitle.joinToString(" "), dexError.detail)
        } else {
            DexErrorFactory.fromStatusCode(e.code())
        }
    }
}