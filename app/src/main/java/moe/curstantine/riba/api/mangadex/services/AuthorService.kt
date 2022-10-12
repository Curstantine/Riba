package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.launch
import moe.curstantine.riba.api.database.RibaDatabase
import moe.curstantine.riba.api.mangadex.models.DexAuthor
import moe.curstantine.riba.api.mangadex.models.DexAuthorCollection
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.toRibaAuthor
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaAuthor
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query

class AuthorService(
    private val service: APIService,
    val database: Database
) : RibaHttpService(service, database) {
    suspend fun get(
        id: String,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<RibaAuthor> =
        contextualInvoke { scope ->
            if (tryDatabase) {
                val localAuthor = database.get(id)
                if (localAuthor != null) return@contextualInvoke localAuthor
            }

            val response = service.get(id).data.toRibaAuthor()
            scope.launch { database.insert(response, forceInsert) }

            return@contextualInvoke response
        }

    suspend fun getCollection(
        ids: List<String>? = null,
        limit: Int = 10,
        offset: Int? = null,
        includes: List<DexEntityType>? = null,
        forceInsert: Boolean = false,
    ): RibaResult<List<RibaAuthor>> = contextualInvoke { scope ->
        val response = service.getCollection(ids, limit, offset, includes)
        val riba = response.data.map { it.toRibaAuthor() }

        scope.launch { database.insertCollection(riba, forceInsert) }

        return@contextualInvoke riba
    }

    suspend fun getStrictCollection(
        ids: List<String>,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<List<RibaAuthor>> {
        val idMap: MutableMap<String, RibaAuthor?> =
            ids.associateBy({ it }, { null }).toMutableMap()
        if (tryDatabase) {
            val localArtist = database.getCollection(ids)
            idMap.putAll(localArtist.map { Pair(it.id, it) })
        }

        val missingIds = idMap.filterValues { it == null }.keys.toList()
        if (missingIds.isNotEmpty()) {
            val response = getCollection(ids = missingIds, forceInsert = forceInsert)

            if (response is RibaResult.Error) return response
            else response.map { it.forEach { artist -> idMap[artist.id] = artist } }
        }

        return RibaResult.Success(idMap.values.mapNotNull { it })
    }

    companion object {
        @JvmSuppressWildcards
        interface APIService : RibaHttpService.Companion.APIService {
            @GET("/author/{id}")
            suspend fun get(@Path("id") id: String): DexAuthor

            @GET("/author")
            suspend fun getCollection(
                @Query("ids[]") ids: List<String>?,
                @Query("limit") limit: Int?,
                @Query("offset") offset: Int?,
                @Query("includes[]") includes: List<DexEntityType>?,
            ): DexAuthorCollection
        }

        class Database(private val database: RibaDatabase) :
            RibaHttpService.Companion.Database(database) {
            suspend fun get(id: String) = database.author().get(id)
            suspend fun getCollection(ids: List<String>) = database.author().get(ids)

            suspend fun insert(author: RibaAuthor, force: Boolean = false) = coroutineScope {
                val oldAuthor = database.author().get(author.id)

                // We don't want to insert authors with the same version.
                if (force.not() && oldAuthor != null && oldAuthor.version >= author.version) {
                    return@coroutineScope
                }

                launch { database.author().insert(author) }
            }

            suspend fun insertCollection(authors: List<RibaAuthor>, force: Boolean = false) =
                coroutineScope {
                    val authorJob = this.async { authors.associateBy { it.id } }
                    val oldAuthorJob = this.async {
                        getCollection(authors.map { it.id }).associateBy { it.id }
                    }

                    val oldAuthorMap = oldAuthorJob.await()
                    val authorMap = authorJob.await()

                    for ((id, newThis) in authorMap) {
                        val oldThis = oldAuthorMap[id]

                        if (force.not() && oldThis != null && oldThis.version >= newThis.version) {
                            continue
                        } else {
                            launch { database.author().insert(newThis) }
                            continue
                        }
                    }
                }
        }
    }
}