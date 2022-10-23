package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.database.DexDatabase
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
import kotlin.coroutines.CoroutineContext

class MangaService(
    override val service: APIService,
    override val database: Database,
    private val authorService: AuthorService,
) : MangaDexService.Companion.Service() {
    override val coroutineScope = CoroutineScope(Dispatchers.IO)

    private val defaultMangaIncludes = listOf(
        DexEntityType.Author,
        DexEntityType.Artist,
        DexEntityType.CoverArt,
    )

    suspend fun get(
        id: String,
        includes: List<DexEntityType> = defaultMangaIncludes,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<RibaManga> = contextualInvoke { scope ->
        if (tryDatabase) {
            val localManga = database.get(id)
            if (localManga != null) return@contextualInvoke localManga
        }

        val response = service.get(id, includes.map { it.toDexEnum() })
        val ribaManga = response.data.toRibaManga()

        scope.launch { database.insert(ribaManga, forceInsert) }
        scope.launch { insertMangaMeta(coroutineContext, response.data) }

        return@contextualInvoke ribaManga
    }

    suspend fun getCollection(
        ids: List<String>? = null,
        limit: Int = 10,
        offset: Int? = null,
        sort: Pair<DexQueryOrderProperty, DexQueryOrderValue>? = null,
        includes: List<DexEntityType> = defaultMangaIncludes,
        forceInsert: Boolean = false,
    ): RibaResult<List<RibaManga>> = contextualInvoke { scope ->
        val response = service.getCollection(
            ids = ids,
            limit = limit,
            offset = offset,
            includes = includes.map { it.toDexEnum() },
            sort = sort?.let { mapOf(Pair(it.first.propStr, it.second)) } ?: emptyMap(),
        )

        val riba = response.data.map { it.toRibaManga() }
        scope.launch { database.insertCollection(coroutineContext, riba, forceInsert) }
        scope.launch { response.data.map { insertMangaMeta(coroutineContext, it) } }

        return@contextualInvoke riba
    }

    suspend fun getStrictCollection(
        ids: List<String>,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<List<RibaManga>> = contextualInvoke {
        val idMap = ids.associateBy({ it }, { null }).toMutableMap<String, RibaManga?>()

        if (tryDatabase) {
            val localManga = database.getCollection(ids)
            idMap.putAll(localManga.map { Pair(it.id, it) })
        }

        val missingIds = idMap.filterValues { it == null }.keys.toList()
        if (missingIds.isNotEmpty()) {
            val response = getCollection(ids = missingIds, forceInsert = forceInsert).unwrap()
            response.forEach { manga -> idMap[manga.id] = manga }
        }

        return@contextualInvoke idMap.values.mapNotNull { it }
    }

    private suspend fun insertMangaMeta(context: CoroutineContext, manga: DexMangaData) =
        withContext(context) {
            launch {
                val ribaTags = manga.attributes.tags.map { it.toRibaTag() }
                database.insertTagCollection(coroutineContext, ribaTags)
            }

            launch {
                val ribaAuthors = manga.relationships
                    .filter { it.type == DexEntityType.Artist || it.type == DexEntityType.Author }
                    .map { (it as DexRelatedAuthor).toRibaAuthor() }
                authorService.database.insertCollection(coroutineContext, ribaAuthors)
            }

            launch {
                val ribaCover = manga.relationships
                    .firstOrNull { it.type == DexEntityType.CoverArt }
                    ?.let { (it as DexRelatedCover).toRibaCover(manga.id) }

                if (ribaCover != null) database.insertCover(ribaCover)
            }
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
            it.launch {
                database.insertCover(riba, forceInsert)
            }

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

            scope.launch {
                database.insertCoverCollection(scope.coroutineContext, riba, forceInsert)
            }

            return@contextualInvoke riba
        }

    companion object {
        @JvmSuppressWildcards
        interface APIService : RibaHttpService.Companion.APIService {
            @GET("/manga/{id}")
            suspend fun get(
                @Path("id") id: String,
                @Query("includes[]") includes: List<String>?
            ): DexManga

            @GET("/manga")
            suspend fun getCollection(
                @Query("ids[]") ids: List<String>?,
                @Query("limit") limit: Int?,
                @Query("offset") offset: Int?,
                @Query("includes[]") includes: List<String>?,
                @QueryMap sort: Map<String, DexQueryOrderValue>,
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

        class Database(private val database: DexDatabase) :
            RibaHttpService.Companion.Database(database) {
            suspend fun get(id: String) = database.manga().get(id)
            suspend fun getCollection(ids: List<String>) = database.manga().get(ids)

            suspend fun getCover(id: String) = database.cover().get(id)
            suspend fun getCoverCollection(ids: List<String>) = database.cover().get(ids)

            suspend fun getTag(id: String) = database.tag().get(id)
            suspend fun getTagCollection(ids: List<String>) = database.tag().get(ids)

            suspend fun getStatistic(id: String) = database.statistic().get(id)
            suspend fun getStatisticCollection(ids: List<String>) = database.statistic().get(ids)

            suspend fun insert(manga: RibaManga, force: Boolean = false) {
                val oldManga = database.manga().get(manga.id)

                if (force.not() && oldManga != null && oldManga.version >= manga.version) {
                    return
                }

                database.manga().insert(manga)
            }

            suspend fun insertCollection(
                context: CoroutineContext,
                manga: List<RibaManga>,
                force: Boolean = false
            ) = withContext(context) {
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
                    }
                }
            }

            suspend fun insertCover(cover: RibaCover, force: Boolean = false) {
                val oldCover = getCover(cover.id)

                if (force.not() && oldCover != null && oldCover.version >= cover.version) {
                    return
                }

                database.cover().insert(cover)
            }

            suspend fun insertCoverCollection(
                context: CoroutineContext,
                covers: List<RibaCover>,
                force: Boolean = false
            ) = withContext(context) {
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

            suspend fun insertTag(tag: RibaTag, force: Boolean = false) {
                val oldTag = getTag(tag.id)

                // We don't want to insert tags with the same version.
                if (force.not() && oldTag != null && oldTag.version >= tag.version) {
                    return
                }

                database.tag().insert(tag)
            }


            suspend fun insertTagCollection(
                context: CoroutineContext,
                tags: List<RibaTag>,
                force: Boolean = false
            ) = withContext(context) {
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
                    }
                }
            }

            suspend fun insertStatistic(statistic: RibaStatistic) =
                database.statistic().insert(statistic)


            suspend fun insertStatisticCollection(statistics: List<RibaStatistic>) =
                database.statistic().insert(statistics)

        }
    }
}