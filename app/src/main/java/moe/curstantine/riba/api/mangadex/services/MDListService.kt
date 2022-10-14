package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import moe.curstantine.riba.api.database.RibaDatabase
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexMDList
import moe.curstantine.riba.api.mangadex.models.toRibaMangaList
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaMangaList
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query

class MDListService(
    private val service: APIService,
    val database: Database
) : MangaDexService.Companion.Service(service, database) {
    override val coroutineScope = CoroutineScope(Dispatchers.IO)

    private val defaultMDListIncludes = listOf(
        DexEntityType.Manga,
        DexEntityType.User
    )

    suspend fun get(
        id: String,
        includes: List<DexEntityType> = defaultMDListIncludes,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<RibaMangaList> = contextualInvoke {
        if (tryDatabase) {
            val localList = database.get(id)
            if (localList != null) return@contextualInvoke localList
        }

        val riba = service.get(id, includes).data.toRibaMangaList()
        it.launch { database.insert(riba, forceInsert) }

        return@contextualInvoke riba
    }

    companion object {
        @JvmSuppressWildcards
        interface APIService : RibaHttpService.Companion.APIService {
            @GET("/list/{id}")
            suspend fun get(
                @Path("id") id: String,
                @Query("includes[]") includes: List<DexEntityType>?
            ): DexMDList
        }

        class Database(private val database: RibaDatabase) :
            RibaHttpService.Companion.Database(database) {
            suspend fun get(id: String) = database.list().get(id)

            suspend fun insert(list: RibaMangaList, force: Boolean = false) {
                val oldList = database.list().get(list.id)

                if (force.not() && oldList != null && oldList.version >= list.version) {
                    return
                }

                database.list().insert(list)
            }
        }
    }
}