package moe.curstantine.riba.api.mangadex.services

import android.util.Log
import kotlinx.coroutines.*
import moe.curstantine.riba.api.adapters.retrofit.getEnumValue
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.*
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.models.*
import retrofit2.http.GET
import retrofit2.http.Query
import retrofit2.http.QueryMap
import kotlin.coroutines.CoroutineContext

class ChapterService(
	override val service: APIService,
	override val database: Database,
	private val userService: UserService,
	private val groupService: GroupService,
) : RibaHttpService() {
	private val defaultChapterIncludes = listOf(
		DexEntityType.User,
		DexEntityType.ScanlationGroup,
	)

	/**
	 * @return A Map with Manga ID as its key and a value with [RibaFulfilledChapter]
	 */
	suspend fun getCollection(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		mangaId: String? = null,
		ids: List<String>? = null,
		limit: Int = 10,
		offset: Int? = null,
		includes: List<DexEntityType> = defaultChapterIncludes,
		originalLanguage: List<DexLocale>? = null,
		translatedLanguage: List<DexLocale>? = null,
		sort: Pair<DexChapterQueryOrderProperty, DexQueryOrderValue>? = null,
		forceInsert: Boolean = false,
	): RibaCollection<Map<String, List<RibaFulfilledChapter>>> =
		withContext(dispatcher) {
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
				val meta = insertChapterMeta(dispatcher, chapter)
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

			launch {
				map.values.forEach { mangaChapters ->
					database.insertCollection(
						context = coroutineContext,
						chapters = mangaChapters.map { it.chapter },
						force = forceInsert
					)
				}
			}

			return@withContext RibaCollection(
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
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		ids: List<String>,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): Map<String, RibaFulfilledChapter> = withContext(dispatcher) {
		val map = ids.associateBy({ it }, { null }).toMutableMap<String, RibaFulfilledChapter?>()

		if (tryDatabase) for (chapter in database.getCollection(ids)) {
			val groups = groupService.database.getCollection(chapter.groups)
			val uploader = userService.database.get(chapter.uploader)

			if (groups.size != chapter.groups.size || uploader == null) {
				val error = DexError.MissingChapterData.setAdditional(
					"Groups were ${groups.map { it.id }}," +
						" where expected value was ${chapter.groups};" +
						" uploader was $uploader, where expected value was ${chapter.uploader}",
				)

				error.log(DexLogTag.MISSING, Log.ERROR)
				throw error
			}

			map[chapter.id] = RibaFulfilledChapter(chapter, groups, uploader)
		}

		val missingIds = map.filterValues { it == null }.keys.toList()
		if (missingIds.isNotEmpty()) {
			getCollection(ids = missingIds, forceInsert = forceInsert)
				.data.values.flatten()
				.forEach { map[it.chapter.id] = it }
		}

		@Suppress("UNCHECKED_CAST")
		return@withContext map.filterValues { it != null } as Map<String, RibaFulfilledChapter>
	}

	/**
	 * Due to the high cardinality of chapters,
	 * this method **will** not fetch from the server,
	 * but return data already available in the database.
	 *
	 * @see getCollection
	 */
	suspend fun getStrictCollectionForManga(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		mangaId: String
	): List<RibaFulfilledChapter> = withContext(dispatcher) {
		val list = mutableListOf<RibaFulfilledChapter>()

		for (chapter in database.getCollectionForManga(mangaId)) {
			val groups = groupService.database.getCollection(chapter.groups)
			val uploader = userService.database.get(chapter.uploader)

			if (groups.size != chapter.groups.size || uploader == null) {
				val error = DexError.MissingChapterData.setAdditional(
					"Groups were ${groups.map { it.id }}," +
						" where expected value was ${chapter.groups};" +
						" uploader was $uploader, where expected value was ${chapter.uploader}",
				)

				error.log(DexLogTag.MISSING, Log.ERROR)
				throw error
			}

			list.add(RibaFulfilledChapter(chapter, groups, uploader))
		}

		return@withContext list
	}

	private suspend fun insertChapterMeta(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		chapter: DexChapterData
	): Pair<RibaUser, List<RibaGroup>> = withContext(dispatcher) {
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

			launch { groupService.database.insertCollection(dispatcher, groups) }
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

		class Database(private val database: DexDatabase) : RibaHttpService.Companion.Database(database) {
			suspend fun get(id: String) = database.chapter().get(id)
			suspend fun getCollection(ids: List<String>) = database.chapter().get(ids)
			suspend fun getCollectionForManga(mangaId: String) = database.chapter().getForManga(mangaId)

			suspend fun insert(chapter: RibaChapter, force: Boolean = false) {
				val oldChapter = database.chapter().get(chapter.id)

				if (!(force.not() && oldChapter != null && chapter.isOlderThan(oldChapter))) {
					database.chapter().insert(chapter)
				}
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

					if (force.not() && oldThis != null && newThis.isOlderThan(oldThis)) continue
					else launch { database.chapter().insert(newThis) }
				}
			}
		}
	}
}