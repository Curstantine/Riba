package moe.curstantine.riba.api.mangadex.services

import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.adapters.retrofit.getEnumValue
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.DexLogTag
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
import moe.curstantine.riba.api.riba.models.RibaCollection
import moe.curstantine.riba.api.riba.models.RibaFulfilledChapter
import moe.curstantine.riba.api.riba.models.RibaGroup
import moe.curstantine.riba.api.riba.models.RibaUser
import retrofit2.http.GET
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

	/**
	 * @return A Map with Manga ID as its key and a value with [RibaFulfilledChapter]
	 */
	suspend fun getCollection(
		mangaId: String? = null,
		ids: List<String>? = null,
		limit: Int = 10,
		offset: Int? = null,
		includes: List<DexEntityType> = defaultChapterIncludes,
		originalLanguage: List<DexLocale>? = null,
		translatedLanguage: List<DexLocale>? = null,
		sort: Pair<DexChapterQueryOrderProperty, DexQueryOrderValue>? = null,
		forceInsert: Boolean = false,
	): RibaResult<RibaCollection<Map<String, List<RibaFulfilledChapter>>>> =
		contextualInvoke { scope ->
			val response = service.getCollection(
				mangaId = mangaId,
				ids = ids,
				limit = limit,
				offset = offset,
				includes = includes.map { it.toDexEnum() },
				originalLanguage = originalLanguage,
				translatedLanguage = translatedLanguage,
				sort = sort?.let { mapOf(Pair(it.first.getEnumValue(), it.second)) } ?: emptyMap(),
			)

			val map = mutableMapOf<String, MutableList<RibaFulfilledChapter>>()

			for (chapter in response.data) {
				val riba = chapter.toRibaChapter()
				val meta = insertChapterMeta(scope.coroutineContext, chapter)
				val manga = chapter.relationships.first { it.type == DexEntityType.Manga }

				if (map[manga.id] == null) map[manga.id] = mutableListOf()

				map[manga.id]?.add(
					RibaFulfilledChapter(
						riba,
						uploader = meta.first,
						groups = meta.second
					)
				)
			}

			scope.launch {
				map.values.forEach { mangaChapters ->
					database.insertCollection(
						context = coroutineContext,
						chapters = mangaChapters.map { it.chapter },
						force = forceInsert
					)
				}
			}

			return@contextualInvoke RibaCollection(
				data = map,
				limit = response.limit,
				offset = response.offset,
				total = response.total,
			)
		}

	/**
	 * Enables you to fetch from the database at the cost of sorting and such.
	 *
	 * @return A [Map] with Chapter ID as its key and a value with [RibaFulfilledChapter]
	 */
	suspend fun getStrictCollection(
		ids: List<String>,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): RibaResult<Map<String, RibaFulfilledChapter>> = contextualInvoke {
		val map = ids.associateBy({ it }, { null }).toMutableMap<String, RibaFulfilledChapter?>()

		if (tryDatabase) for (chapter in database.getCollection(ids)) {
			val groups = groupService.database.getCollection(chapter.groups)
			val uploader = userService.database.get(chapter.uploader)

			if (groups.size == chapter.groups.size || uploader == null) {
				Log.i(
					DexLogTag.MISSING.tag,
					"Groups were $groups, where expected value was ${chapter.groups}; uploader was $uploader, where expected value was ${chapter.uploader}",
					DexError.Companion.MissingChapterData
				)
				continue
			}

			map[chapter.id] = RibaFulfilledChapter(
				chapter,
				groups,
				uploader,
			)
		}

		val missingIds = map.filterValues { it == null }.keys.toList()
		if (missingIds.isNotEmpty()) {
			val response = getCollection(ids = missingIds, forceInsert = forceInsert)
				.unwrap()

			for (chapter in response.data.values.flatten()) {
				map[chapter.chapter.id] = chapter
			}
		}

		return@contextualInvoke map.filterValues { it != null }.mapValues { it.value!! }
	}

	/**
	 * Due to the high cardinality of chapters,
	 * this method **will** not fetch from the server,
	 * but return data already available in the database.
	 *
	 * @see getCollection
	 */
	suspend fun getStrictCollectionForManga(mangaId: String): RibaResult<List<RibaFulfilledChapter>> =
		contextualInvoke {
			val list = mutableListOf<RibaFulfilledChapter>()

			for (chapter in database.getCollectionForManga(mangaId)) {
				val groups = groupService.database.getCollection(chapter.groups)
				val uploader = userService.database.get(chapter.uploader)

				if (groups.size == chapter.groups.size || uploader == null) {
					val error = DexError.Companion.MissingChapterData
					Log.i(
						DexLogTag.MISSING.tag,
						"Groups were $groups, where expected value was ${chapter.groups}; uploader was $uploader, where expected value was ${chapter.uploader}",
						error
					)
					throw error
				}

				list.add(
					RibaFulfilledChapter(
						chapter,
						groups,
						uploader,
					)
				)
			}

			return@contextualInvoke list
		}

	private suspend fun insertChapterMeta(
		context: CoroutineContext,
		chapter: DexChapterData
	): Pair<RibaUser, List<RibaGroup>> = withContext(context) {
		val uploader = async {
			val user = chapter.relationships
				.first { it.type == DexEntityType.User }
				.let { (it as DexRelatedUser).toRibaUser() }

			launch { userService.database.insert(user) }

			return@async user
		}

		val groups = async {
			val groups = chapter.relationships
				.filter { it.type == DexEntityType.ScanlationGroup }
				.map { (it as DexRelatedGroup).toRibaGroup() }

			launch { groupService.database.insertCollection(coroutineContext, groups) }

			return@async groups
		}

		return@withContext Pair(uploader.await(), groups.await())
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