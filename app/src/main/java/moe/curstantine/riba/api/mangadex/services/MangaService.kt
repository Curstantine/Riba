package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.*
import moe.curstantine.riba.api.adapters.retrofit.getEnumValue
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.*
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.models.*
import retrofit2.HttpException
import retrofit2.http.*

class MangaService(
	override val service: APIService,
	override val database: Database,
	private val authorService: AuthorService,
	private val userService: UserService,
) : RibaHttpService() {
	private val defaultMangaIncludes = listOf(
		DexEntityType.Author,
		DexEntityType.Artist,
		DexEntityType.CoverArt,
	)

	suspend fun get(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		id: String,
		includes: List<DexEntityType> = defaultMangaIncludes,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): RibaManga = withContext(dispatcher) {
		if (tryDatabase) {
			val localManga = database.get(id)
			if (localManga != null) return@withContext localManga
		}

		val response = service.get(id, includes.map { it.toDexEnum() })
		val ribaManga = response.data.toRibaManga()

		launch { database.insert(ribaManga, forceInsert) }
		launch { insertMangaMeta(dispatcher, response.data) }

		return@withContext ribaManga
	}

	suspend fun getCollection(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		ids: List<String>? = null,
		limit: Int = 10,
		offset: Int? = null,
		sort: Pair<DexQueryOrderProperty, DexQueryOrderValue>? = null,
		includes: List<DexEntityType> = defaultMangaIncludes,
		forceInsert: Boolean = false,
	): List<RibaManga> = withContext(dispatcher) {
		val response = service.getCollection(
			ids = ids,
			limit = limit,
			offset = offset,
			includes = includes.map { it.toDexEnum() },
			sort = sort?.let { mapOf(Pair(it.first.getEnumValue(), it.second)) } ?: emptyMap(),
		)

		val riba = response.data.map { it.toRibaManga() }
		launch { database.insertCollection(dispatcher, riba, forceInsert) }
		launch { response.data.forEach { insertMangaMeta(dispatcher, it) } }

		return@withContext riba
	}

	suspend fun getStrictCollection(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		ids: List<String>,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): List<RibaManga> = withContext(dispatcher) {
		val idMap = ids.associateBy({ it }, { null }).toMutableMap<String, RibaManga?>()

		if (tryDatabase) {
			val localManga = database.getCollection(ids)
			idMap.putAll(localManga.map { Pair(it.id, it) })
		}

		val missingIds = idMap.filterValues { it == null }.keys.toList()
		if (missingIds.isNotEmpty()) {
			getCollection(ids = missingIds, limit = missingIds.size, forceInsert = forceInsert)
				.forEach { manga -> idMap[manga.id] = manga }
		}

		return@withContext idMap.values.mapNotNull { it }
	}

	private suspend fun insertMangaMeta(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		manga: DexMangaData
	) = withContext(dispatcher) {
		launch {
			val ribaTags = manga.attributes.tags.map { it.toRibaTag() }
			database.insertTagCollection(dispatcher, ribaTags)
		}

		launch {
			val ribaAuthors = manga.relationships
				.filter { it.type == DexEntityType.Artist || it.type == DexEntityType.Author }
				.map { (it as DexRelatedAuthor).toRibaAuthor() }
			authorService.database.insertCollection(dispatcher, ribaAuthors)
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
	suspend fun getStatistic(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		id: String
	): RibaStatistic = withContext(dispatcher) {
		val response = service.getStatistic(id).statistics[id]!!.toRibaStatistic(id)
		launch { database.insertStatistic(response) }

		return@withContext response
	}

	suspend fun getCover(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		id: String,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): RibaCover = withContext(dispatcher) {
		if (tryDatabase) {
			val localCover = database.getCover(id)
			if (localCover != null) return@withContext localCover
		}

		val response = service.getCover(id)
		val riba = response.data.toRibaCover()
		launch { database.insertCover(riba, forceInsert) }

		return@withContext riba
	}

	suspend fun getCoverCollection(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		ids: List<String>? = null,
		manga: List<String>? = null,
		limit: Int? = null,
		forceInsert: Boolean = false,
	): List<RibaCover> = withContext(dispatcher) {
		val response = service.getCoverCollection(ids, manga, limit).data.map { it.toRibaCover() }
		launch { database.insertCoverCollection(dispatcher, response, forceInsert) }

		return@withContext response
	}

	/**
	 * **Requires Authentication**
	 *
	 * MangaDex returns "ko" for errors that are not technically errors lol.
	 *
	 * Like in this case,
	 * when you try to find the follow status of a title that a user has not followed,
	 * it'll return 404 with [DexResult.Ko]
	 */
	suspend fun checkFollowStatus(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		mangaId: String,
		tryDatabase: Boolean = true
	): Boolean = withContext(dispatcher) {
		if (tryDatabase) {
			val localFollow = database.getFollow(mangaId)
			if (localFollow != null) {
				return@withContext localFollow.followedUsers.contains(userService.getUserId())
			}
		}

		userService.handleTokenExpiry()

		return@withContext try {
			service.isFollowing(userService.getSessionToken(true), mangaId).result == DexResult.Ok
		} catch (e: HttpException) {
			val bodyHasError = e.response()?.errorBody()?.string()?.let {
				it.contains(DexResult.Ko.toDexEnum()) || it.contains(DexResult.Error.toDexEnum())
			}

			if (e.code() == 404 && bodyHasError == true) return@withContext false
			else throw e
		}
	}

	/**
	 * **Requires Authentication**
	 */
	suspend fun follow(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		mangaId: String
	): Unit = withContext(dispatcher) {
		userService.handleTokenExpiry()

		service.follow(userService.getSessionToken(true), mangaId)
		launch { database.insertFollow(mangaId, userService.getUserId(), true) }
	}

	/**
	 * **Requires Authentication**
	 */
	suspend fun unfollow(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		mangaId: String
	): Unit = withContext(dispatcher) {
		userService.handleTokenExpiry()

		service.unfollow(userService.getSessionToken(true), mangaId)
		launch { database.insertFollow(mangaId, userService.getUserId(), false) }
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

			@GET("/cover/{id}")
			suspend fun getCover(@Path("id") id: String): DexCover

			@GET("/cover")
			suspend fun getCoverCollection(
				@Query("ids[]") ids: List<String>?,
				@Query("manga[]") manga: List<String>?,
				@Query("limit") limit: Int?,
			): DexCoverCollection

			@GET("/user/follows/manga/{id}")
			suspend fun isFollowing(
				@Header("Authorization") token: String,
				@Path("id") id: String,
			): DexBaseResponseImpl

			@POST("/manga/{id}/follow")
			suspend fun follow(
				@Header("Authorization") token: String,
				@Path("id") id: String
			): DexBaseResponseImpl

			@DELETE("/manga/{id}/follow")
			suspend fun unfollow(
				@Header("Authorization") token: String,
				@Path("id") id: String
			): DexBaseResponseImpl
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
			suspend fun insertStatistic(statistic: RibaStatistic) = database.statistic().insert(statistic)

			suspend fun getFollow(id: String) = database.follows().get(id)
			suspend fun insertFollow(mangaId: String, userId: String, isFollowing: Boolean) {
				val old = getFollow(mangaId)
				val follow = RibaUserFollow(
					mangaId = mangaId,
					followedUsers = if (isFollowing) {
						old?.followedUsers.orEmpty().let { if (userId in it) it else it + userId }
					} else {
						old?.followedUsers.orEmpty().let { if (userId !in it) it else it - userId }
					}
				)

				database.follows().insert(follow)
			}


			suspend fun insert(manga: RibaManga, force: Boolean = false) {
				val oldManga = database.manga().get(manga.id)

				if (force.not() && oldManga != null && oldManga.version >= manga.version) {
					return
				}

				database.manga().insert(manga)
			}

			suspend fun insertCollection(
				dispatcher: CoroutineDispatcher = Dispatchers.Default,
				manga: List<RibaManga>,
				force: Boolean = false
			) = withContext(dispatcher) {
				val mangaJob = this.async { manga.associateBy { it.id } }
				val oldMangaJob = this.async { getCollection(manga.map { it.id }).associateBy { it.id } }

				val oldMangaMap = oldMangaJob.await()
				val mangaMap = mangaJob.await()

				for ((id, newThis) in mangaMap) {
					val oldThis = oldMangaMap[id]

					if (force.not() && oldThis != null && newThis.isOlderThan(oldThis)) continue
					else launch { database.manga().insert(newThis) }
				}
			}

			suspend fun insertCover(cover: RibaCover, force: Boolean = false) {
				val oldCover = getCover(cover.id)

				if (!(force.not() && oldCover != null && cover.isOlderThan(oldCover))) {
					database.cover().insert(cover)
				}
			}

			suspend fun insertCoverCollection(
				dispatcher: CoroutineDispatcher = Dispatchers.Default,
				covers: List<RibaCover>,
				force: Boolean = false
			) = withContext(dispatcher) {
				val coverJob = this.async { covers.associateBy { it.id } }
				val oldCoverJob = this.async { getCoverCollection(covers.map { it.id }).associateBy { it.id } }

				val oldCoverMap = oldCoverJob.await()
				val coverMap = coverJob.await()

				for ((id, newThis) in coverMap) {
					val oldThis = oldCoverMap[id]

					if (force.not() && oldThis != null && newThis.isOlderThan(oldThis)) continue
					else launch { database.cover().insert(newThis) }
				}
			}

			suspend fun insertTagCollection(
				dispatcher: CoroutineDispatcher = Dispatchers.Default,
				tags: List<RibaTag>,
				force: Boolean = false
			) = withContext(dispatcher) {
				val tagJob = this.async { tags.associateBy { it.id } }
				val oldTagJob = this.async { getTagCollection(tags.map { it.id }).associateBy { it.id } }

				val oldTagMap = oldTagJob.await()
				val tagMap = tagJob.await()

				for ((id, newThis) in tagMap) {
					val oldThis = oldTagMap[id]

					if (force.not() && oldThis != null && newThis.isOlderThan(oldThis)) continue
					else launch { database.tag().insert(newThis) }
				}
			}
		}
	}
}