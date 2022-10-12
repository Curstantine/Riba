package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.launch
import moe.curstantine.riba.api.database.RibaDatabase
import moe.curstantine.riba.api.mangadex.models.DexCover
import moe.curstantine.riba.api.mangadex.models.DexCoverCollection
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexManga
import moe.curstantine.riba.api.mangadex.models.DexMangaCollection
import moe.curstantine.riba.api.mangadex.models.DexMangaData
import moe.curstantine.riba.api.mangadex.models.DexMangaStatistics
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.mangadex.models.DexRelatedAuthor
import moe.curstantine.riba.api.mangadex.models.DexRelatedCover
import moe.curstantine.riba.api.mangadex.models.toRibaCover
import moe.curstantine.riba.api.mangadex.models.toRibaManga
import moe.curstantine.riba.api.mangadex.models.toRibaTag
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaManga
import moe.curstantine.riba.api.riba.models.RibaStatistic
import moe.curstantine.riba.api.riba.models.RibaTag
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import retrofit2.http.QueryMap

class MangaService(
    private val service: APIService,
    val database: Database,
    private val authorService: AuthorService,
) : RibaHttpService(service, database) {
    private val DEFAULT_MANGA_INCLUDES = listOf(
        DexEntityType.Author,
        DexEntityType.Artist,
        DexEntityType.CoverArt,
    )

    suspend fun get(
        id: String,
        includes: List<DexEntityType> = DEFAULT_MANGA_INCLUDES,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<RibaManga> = contextualInvoke { scope ->
        if (tryDatabase) {
            val localManga = database.get(id)
            if (localManga != null) return@contextualInvoke localManga
        }

        val response = service.get(id, includes)
        val ribaManga = response.data.toRibaManga()

        scope.launch { database.insert(ribaManga, forceInsert) }
        scope.launch { insertMangaMeta(response.data) }

        return@contextualInvoke ribaManga
    }


    suspend fun getCollection(
        ids: List<String>? = null,
        limit: Int = 10,
        offset: Int? = null,
        sort: Pair<DexQueryOrderProperty, DexQueryOrderValue>? = null,
        includes: List<DexEntityType> = DEFAULT_MANGA_INCLUDES,
        forceInsert: Boolean = false,
    ): RibaResult<List<RibaManga>> = contextualInvoke { scope ->
        val response = service.getCollection(
            ids = ids,
            limit = limit,
            offset = offset,
            includes = includes,
            sort = sort?.let { mapOf(Pair(it.first.propStr, it.second)) } ?: mapOf()
        )

        val riba = response.data.map { it.toRibaManga() }
        scope.launch { database.insertCollection(riba, forceInsert) }
        scope.launch { response.data.map { insertMangaMeta(it) } }

        return@contextualInvoke riba
    }

    suspend fun getStrictCollection(
        ids: List<String>,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<List<RibaManga>> {
        val idMap: MutableMap<String, RibaManga?> = ids.associateBy({ it }, { null }).toMutableMap()
        if (tryDatabase) {
            val localManga = database.getCollection(ids)
            idMap.putAll(localManga.map { Pair(it.id, it) })
        }

        val missingIds = idMap.filterValues { it == null }.keys.toList()
        if (missingIds.isNotEmpty()) {
            val response = getCollection(ids = missingIds, forceInsert = forceInsert)

            if (response is RibaResult.Error) return response
            else response.map { it.forEach { manga -> idMap[manga.id] = manga } }
        }

        return RibaResult.Success(idMap.values.mapNotNull { it })
    }

    private suspend fun insertMangaMeta(manga: DexMangaData) =
        contextualInvoke(Dispatchers.Default) { scope ->
            val ribaTags = manga.attributes.tags.map { it.toRibaTag() }
            if (ribaTags.isNotEmpty()) scope.launch { database.insertTagCollection(ribaTags) }

            val ribaAuthors = manga.relationships
                .filter { it.type == DexEntityType.Artist || it.type == DexEntityType.Author }
                .map { (it as DexRelatedAuthor).toRibaAuthor() }
            if (ribaAuthors.isNotEmpty()) {
                scope.launch { authorService.database.insertCollection(ribaAuthors) }
            }

            val ribaCover = manga.relationships
                .firstOrNull { it.type == DexEntityType.CoverArt }
                ?.let { (it as DexRelatedCover).toRibaCover(manga.id) }
            if (ribaCover != null) scope.launch { database.insertCover(ribaCover) }
        }

    /**
     * @param id UUID of the title
     */
    suspend fun getStatistic(id: String): RibaResult<RibaStatistic> = contextualInvoke {
        val response = service.getStatistic(id)
        val riba = response.statistics[id]!!.toRibaStatistic(id)
        it.launch { database.insertStatistic(riba) }

        return@contextualInvoke riba
    }


    /**
     * @param ids List of UUIDs of the titles
     */
    suspend fun getStatisticCollection(ids: List<String>): RibaResult<Map<String, RibaStatistic>> =
        contextualInvoke {
            val response = service.getStatisticCollection(ids)
            val riba = response.toRibaStatisticCollection()

            it.launch { database.insertStatisticCollection(riba.values.toList()) }

            return@contextualInvoke riba
        }

    suspend fun getCover(
        id: String,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<RibaCover> =
        contextualInvoke {
            if (tryDatabase) {
                val localCover = database.getCover(id)
                if (localCover != null) return@contextualInvoke localCover
            }

            val response = service.getCover(id)
            val riba = response.data.toRibaCover()
            it.launch { database.insertCover(riba, forceInsert) }

            return@contextualInvoke riba
        }

    suspend fun getCoverCollection(
        ids: List<String>? = null,
        manga: List<String>? = null,
        limit: Int? = null,
        forceInsert: Boolean = false,
    ): RibaResult<List<RibaCover>> =
        contextualInvoke { scope ->
            val response = service.getCoverCollection(ids, manga, limit)
            val riba = response.data.map { it.toRibaCover() }

            scope.launch { database.insertCoverCollection(riba, forceInsert) }

            return@contextualInvoke riba
        }

    companion object {
        @JvmSuppressWildcards
        interface APIService : RibaHttpService.Companion.APIService {
            @GET("/manga/{id}")
            suspend fun get(
                @Path("id") id: String,
                @Query("includes[]") includes: List<DexEntityType>?
            ): DexManga

            @GET("/manga")
            suspend fun getCollection(
                @Query("ids[]") ids: List<String>?,
                @Query("limit") limit: Int?,
                @Query("offset") offset: Int?,
                @Query("includes[]") includes: List<DexEntityType>?,
                @QueryMap sort: Map<String, DexQueryOrderValue>?,
            ): DexMangaCollection

            @GET("/statistics/manga/{id}")
            suspend fun getStatistic(
                @Path("id") id: String,
            ): DexMangaStatistics

            @GET("/statistics/manga")
            suspend fun getStatisticCollection(
                @Query("manga[]") ids: List<String>,
            ): DexMangaStatistics

            @GET("/cover/{id}")
            suspend fun getCover(@Path("id") id: String): DexCover

            @GET("/cover")
            suspend fun getCoverCollection(
                @Query("ids[]") ids: List<String>?,
                @Query("manga[]") manga: List<String>?,
                @Query("limit") limit: Int?,
            ): DexCoverCollection
        }

        class Database(private val database: RibaDatabase) :
            RibaHttpService.Companion.Database(database) {
            suspend fun get(id: String) = database.manga().get(id)
            suspend fun getCollection(ids: List<String>) = database.manga().get(ids)

            suspend fun getCover(id: String) = database.cover().get(id)
            suspend fun getCoverCollection(ids: List<String>) = database.cover().get(ids)

            suspend fun getTag(id: String) = database.tag().get(id)
            suspend fun getTagCollection(ids: List<String>) = database.tag().get(ids)

            suspend fun getStatistic(id: String) = database.statistic().get(id)
            suspend fun getStatisticCollection(ids: List<String>) = database.statistic().get(ids)

            suspend fun insert(manga: RibaManga, force: Boolean = false) = coroutineScope {
                val oldManga = database.manga().get(manga.id)

                if (force.not() && oldManga != null && oldManga.version >= manga.version) {
                    return@coroutineScope
                }

                launch { database.manga().insert(manga) }
            }

            suspend fun insertCollection(manga: List<RibaManga>, force: Boolean = false) =
                coroutineScope {
                    val mangaJob = this.async { manga.associateBy { it.id } }
                    val oldMangaJob = this.async {
                        getCollection(manga.map { it.id }).associateBy { it.id }
                    }

                    val oldMangaMap = oldMangaJob.await()
                    val mangaMap = mangaJob.await()

                    for ((id, newThis) in mangaMap) {
                        val oldThis = oldMangaMap[id]

                        if (force.not() && oldThis != null && oldThis.version >= newThis.version) {
                            continue
                        } else {
                            launch { database.manga().insert(newThis) }
                            continue
                        }
                    }
                }

            suspend fun insertCover(cover: RibaCover, force: Boolean = false) = coroutineScope {
                val oldCover = getCover(cover.id)

                if (force.not() && oldCover != null && oldCover.version >= cover.version) {
                    return@coroutineScope
                }

                launch { database.cover().insert(cover) }
            }

            suspend fun insertCoverCollection(covers: List<RibaCover>, force: Boolean = false) =
                coroutineScope {
                    val coverJob = this.async { covers.associateBy { it.id } }
                    val oldCoverJob = this.async {
                        getCoverCollection(covers.map { it.id }).associateBy { it.id }
                    }

                    val oldCoverMap = oldCoverJob.await()
                    val coverMap = coverJob.await()

                    for ((id, newThis) in coverMap) {
                        val oldThis = oldCoverMap[id]

                        if (force.not() && oldThis != null && oldThis.version >= newThis.version) {
                            continue
                        } else {
                            launch { database.cover().insert(newThis) }
                            continue
                        }
                    }
                }

            suspend fun insertTag(tag: RibaTag, force: Boolean = false) = coroutineScope {
                val oldTag = getTag(tag.id)

                // We don't want to insert tags with the same version.
                if (force.not() && oldTag != null && oldTag.version >= tag.version) {
                    return@coroutineScope
                }

                launch { database.tag().insert(tag) }
            }


            suspend fun insertTagCollection(tags: List<RibaTag>, force: Boolean = false) =
                coroutineScope {
                    val tagJob = this.async { tags.associateBy { it.id } }
                    val oldTagJob = this.async {
                        getTagCollection(tags.map { it.id }).associateBy { it.id }
                    }

                    val oldTagMap = oldTagJob.await()
                    val tagMap = tagJob.await()

                    for ((id, newThis) in tagMap) {
                        val oldThis = oldTagMap[id]

                        if (force.not() && oldThis != null && oldThis.version >= newThis.version) {
                            continue
                        } else {
                            launch { database.tag().insert(newThis) }
                            continue
                        }
                    }
                }

            suspend fun insertStatistic(statistic: RibaStatistic) = coroutineScope {
                launch { database.statistic().insert(statistic) }
            }

            suspend fun insertStatisticCollection(statistics: List<RibaStatistic>) =
                coroutineScope {
                    launch { database.statistic().insert(statistics) }
                }
        }
    }
}