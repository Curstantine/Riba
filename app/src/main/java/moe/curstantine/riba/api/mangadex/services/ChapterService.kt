package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.DexChapterCollection
import moe.curstantine.riba.api.mangadex.models.DexChapterData
import moe.curstantine.riba.api.mangadex.models.DexChapterQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.mangadex.models.DexRelatedGroup
import moe.curstantine.riba.api.mangadex.models.DexRelatedUser
import moe.curstantine.riba.api.mangadex.models.toRibaChapter
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaChapter
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import retrofit2.http.QueryMap
import kotlin.coroutines.CoroutineContext

class ChapterService(
    override val service: APIService,
    override val database: Database,
    private val userService: UserService,
    private val groupService: GroupService,
) : MangaDexService.Companion.Service() {
    override val coroutineScope = CoroutineScope(Dispatchers.IO)

    private val defaultChapterIncludes = listOf(
        DexEntityType.User,
        DexEntityType.ScanlationGroup,
    )

    suspend fun getCollection(
        mangaId: String? = null,
        ids: List<String>? = null,
        limit: Int = 50,
        offset: Int? = null,
        includes: List<DexEntityType> = defaultChapterIncludes,
        originalLanguage: List<DexLocale>? = null,
        translatedLanguage: List<DexLocale>? = null,
        sort: Pair<DexChapterQueryOrderProperty, DexQueryOrderValue>? = null,
        forceInsert: Boolean = false,
    ) = contextualInvoke { scope ->
        val response = service.getCollection(
            mangaId = mangaId,
            ids = ids,
            limit = limit,
            offset = offset,
            includes = includes.map { it.toDexEnum() },
            originalLanguage = originalLanguage,
            translatedLanguage = translatedLanguage,
            sort = sort?.let { mapOf(Pair(it.first.propStr, it.second)) } ?: emptyMap(),
        )

        val riba = response.data.map { it.toRibaChapter() }
        scope.launch { database.insertCollection(coroutineContext, riba, forceInsert) }
        scope.launch { response.data.map { insertChapterMeta(coroutineContext, it) } }

        return@contextualInvoke riba
    }

    suspend fun getStrictCollection(
        ids: List<String>,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<List<RibaChapter>> = contextualInvoke {
        val idMap = ids.associateBy({ it }, { null }).toMutableMap<String, RibaChapter?>()

        if (tryDatabase) {
            val localChapter = database.getCollection(ids)
            idMap.putAll(localChapter.map { Pair(it.id, it) })
        }

        val missingIds = idMap.filterValues { it == null }.keys.toList()
        if (missingIds.isNotEmpty()) {
            val response = getCollection(ids = missingIds, forceInsert = forceInsert).unwrap()
            response.forEach { manga -> idMap[manga.id] = manga }
        }

        return@contextualInvoke idMap.values.mapNotNull { it }
    }

    suspend fun getStrictCollectionForManga(
        mangaId: String,
        forceInsert: Boolean = false,
        tryDatabase: Boolean = true,
    ): RibaResult<List<RibaChapter>> = contextualInvoke {
        if (tryDatabase) {
            val localChapter = database.getCollectionForManga(mangaId)
            if (localChapter.isNotEmpty()) {
                return@contextualInvoke localChapter
            }
        }

        return@contextualInvoke getCollection(mangaId = mangaId, forceInsert = forceInsert).unwrap()
    }

    private suspend fun insertChapterMeta(context: CoroutineContext, chapter: DexChapterData) =
        withContext(context) {
            launch {
                val user = chapter.relationships
                    .first { it.type == DexEntityType.User }
                    .let { (it as DexRelatedUser).toRibaUser() }

                userService.database.insert(user)
            }

            launch {
                val groups = chapter.relationships
                    .filter { it.type == DexEntityType.ScanlationGroup }
                    .map { (it as DexRelatedGroup).toRibaGroup() }

                groupService.database.insertCollection(coroutineContext, groups)
            }
        }

    companion object {
        @JvmSuppressWildcards
        interface APIService : RibaHttpService.Companion.APIService {
            @GET("/chapter")
            suspend fun getCollection(
                @Query("manga") mangaId: String?,
                @Query("ids[]") ids: List<String>?,
                @Query("limit") limit: Int?,
                @Query("offset") offset: Int?,
                @Query("originalLanguage[]") originalLanguage: List<DexLocale>?,
                @Query("translatedLanguage[]") translatedLanguage: List<DexLocale>?,
                @Query("includes[]") includes: List<String>?,
                @QueryMap sort: Map<String, DexQueryOrderValue>,
            ): DexChapterCollection
        }

        class Database(
            private val database: DexDatabase
        ) : RibaHttpService.Companion.Database(database) {
            suspend fun get(id: String) = database.chapter().get(id)

            suspend fun getCollection(ids: List<String>) = database.chapter().get(ids)

            suspend fun getCollectionForManga(mangaId: String) = database
                .chapter()
                .getForManga(mangaId)

            suspend fun insert(chapter: RibaChapter, force: Boolean = false) {
                val oldChapter = database.chapter().get(chapter.id)

                if (force.not() && oldChapter != null && oldChapter.version >= chapter.version) {
                    return
                }

                database.chapter().insert(chapter)
            }

            suspend fun insertCollection(
                context: CoroutineContext,
                chapters: List<RibaChapter>,
                force: Boolean = false
            ) = withContext(context) {
                val chapterJob = this.async { chapters.associateBy { it.id } }
                val oldChapterJob = this.async {
                    getCollection(chapters.map { it.id }).associateBy { it.id }
                }

                val chapterMap = chapterJob.await()
                val oldChapterMap = oldChapterJob.await()

                for ((id, newThis) in chapterMap) {
                    val oldThis = oldChapterMap[id]

                    if (force.not() && oldThis != null && oldThis.version >= newThis.version) {
                        continue
                    } else {
                        launch { database.chapter().insert(newThis) }
                    }
                }
            }
        }
    }
}