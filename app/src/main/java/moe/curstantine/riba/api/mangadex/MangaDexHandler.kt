package moe.curstantine.riba.api.mangadex

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.mangadex.models.DexAuthor
import moe.curstantine.riba.api.mangadex.models.DexAuthorCollection
import moe.curstantine.riba.api.mangadex.models.DexCover
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexMDList
import moe.curstantine.riba.api.mangadex.models.DexManga
import moe.curstantine.riba.api.mangadex.models.DexMangaCollection
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.riba.RibaResult

class MangaDexHandler(
    private var service: MangaDexService,
    private var database: DexDatabaseHandler
) {
    suspend fun getAuthor(id: String, forceInsert: Boolean = false): RibaResult<DexAuthor> {
        return contextualInvoke {
            val response = service.getAuthor(id)
            it.launch { database.insertAuthor(response.data, forceInsert) }

            return@contextualInvoke response
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
            val response = service.getAuthor(ids, limit, offset, includes)
            scope.launch { response.data.forEach { database.insertAuthor(it, forceInsert) } }

            return@contextualInvoke response
        }
    }

    suspend fun getCover(id: String, forceInsert: Boolean = false): RibaResult<DexCover> {
        return contextualInvoke {
            val response = service.getCover(id)
            it.launch { database.insertCover(response.data, forceInsert) }

            return@contextualInvoke response
        }
    }

    suspend fun getManga(
        id: String,
        includes: List<DexEntityType>? = null,
        forceInsert: Boolean = false
    ): RibaResult<DexManga> {
        return contextualInvoke { scope ->
            val response = service.getManga(id, includes)
            scope.launch { database.insertManga(response.data, forceInsert) }

            return@contextualInvoke response
        }
    }

    suspend fun getManga(
        ids: List<String>? = null,
        limit: Int = 10,
        offset: Int? = null,
        sort: Pair<DexQueryOrderProperty, DexQueryOrderValue>? = null,
        includes: List<DexEntityType>? = null,
        forceInsert: Boolean = false
    ): RibaResult<DexMangaCollection> {
        return contextualInvoke { scope ->
            val response = service.getManga(
                ids = ids,
                limit = limit,
                offset = offset,
                includes = includes,
                sort = sort?.let { mapOf(Pair(it.first.propStr, it.second)) } ?: mapOf()
            )
            scope.launch { response.data.forEach { database.insertManga(it, forceInsert) } }

            return@contextualInvoke response
        }
    }

    suspend fun getMDList(
        id: String,
        forceInsert: Boolean = false,
        includes: List<DexEntityType>? = null
    ): RibaResult<DexMDList> {
        return contextualInvoke {
            val response = service.getMDList(id, includes)
            it.launch { database.insertMDList(response.data, forceInsert) }

            return@contextualInvoke response
        }
    }

    private suspend fun <T> contextualInvoke(call: suspend (it: CoroutineScope) -> T): RibaResult<T> {
        return withContext(Dispatchers.IO) {
            try {
                RibaResult.Success(call.invoke(this))
            } catch (e: Throwable) {
                RibaResult.Error(DexError.tryHandle(e))
            }
        }
    }
}