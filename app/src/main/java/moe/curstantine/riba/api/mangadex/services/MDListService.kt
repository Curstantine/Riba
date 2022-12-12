package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.*
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.*
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.models.RibaCollection
import moe.curstantine.riba.api.riba.models.RibaMangaList
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.Path
import retrofit2.http.Query

class MDListService(
	override val service: APIService,
	override val database: Database,
	private val userService: UserService,
) : RibaHttpService() {
	private val defaultMDListIncludes = listOf(DexEntityType.User)

	suspend fun get(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		id: String,
		includes: List<DexEntityType> = defaultMDListIncludes,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): RibaMangaList = withContext(dispatcher) {
		if (tryDatabase) {
			val localList = database.get(id)
			if (localList != null) return@withContext localList
		}

		val response = service.get(id, includes.map { it.toDexEnum() })
		val riba = response.data.toRibaMangaList()

		launch { database.insert(riba, forceInsert) }
		launch { insertMeta(dispatcher, response.data, forceInsert) }

		return@withContext riba
	}

	/**
	 * Returns the logged in user's MDLists.
	 *
	 * NOTE: This method needs authentication.
	 */
	suspend fun getUserLists(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		limit: Int? = null,
		offset: Int? = null,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): RibaCollection<List<RibaMangaList>> = withContext(dispatcher) {
		if (tryDatabase) {
			val localList = database.getCollectionForUser(userService.getUserId())
			if (localList.isNotEmpty()) return@withContext RibaCollection(
				data = localList,
				total = localList.size,
				offset = 0,
				limit = localList.size,
				cached = true,
			)
		}

		val response = service.getUserLists(
			token = userService.getSessionToken(),
			limit = limit,
			offset = offset,
		)
		val riba = response.data.map { it.toRibaMangaList() }
		launch { database.insertCollection(dispatcher, riba, forceInsert) }

		return@withContext RibaCollection(
			total = response.total,
			limit = response.limit,
			offset = response.offset,
			data = riba
		)
	}

	/**
	 * Returns the logged in user's followed MDLists.
	 *
	 * NOTE: This method needs authentication.
	 */
	suspend fun getUserFollowedLists(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		limit: Int? = null,
		offset: Int? = null,
		includes: List<DexEntityType> = defaultMDListIncludes,
		forceInsert: Boolean = false,
	): RibaCollection<List<RibaMangaList>> = withContext(dispatcher) {
		val response = service.getUserFollowedLists(
			token = userService.getSessionToken(),
			limit = limit,
			offset = offset,
			includes = includes.map { it.toDexEnum() },
		)
		val riba = response.data.map { it.toRibaMangaList() }

		launch { database.insertCollection(dispatcher, riba, forceInsert) }
		launch { response.data.forEach { insertMeta(dispatcher, it, forceInsert) } }

		return@withContext RibaCollection(
			total = response.total,
			limit = response.limit,
			offset = response.offset,
			data = riba
		)
	}

	private suspend fun insertMeta(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		list: DexMDListData,
		forceInsert: Boolean,
	) = withContext(dispatcher) {
		launch {
			val user = list.relationships
				.first { it.type == DexEntityType.User }
				.let { it as DexRelatedUser }

			userService.database.insert(user.toRibaUser(), forceInsert)
		}
	}

	companion object {
		@JvmSuppressWildcards
		interface APIService : RibaHttpService.Companion.APIService {
			@GET("/list/{id}")
			suspend fun get(
				@Path("id") id: String,
				@Query("includes[]") includes: List<String>?
			): DexMDList

			@GET("/user/list")
			suspend fun getUserLists(
				@Header("Authorization") token: String,
				@Query("limit") limit: Int?,
				@Query("offset") offset: Int?,
			): DexMDListCollection

			@GET("/user/follows/list")
			suspend fun getUserFollowedLists(
				@Header("Authorization") token: String,
				@Query("limit") limit: Int?,
				@Query("offset") offset: Int?,
				@Query("includes[]") includes: List<String>?
			): DexMDListCollection
		}

		class Database(private val database: DexDatabase) : RibaHttpService.Companion.Database(database) {
			suspend fun get(id: String) = database.list().get(id)
			suspend fun getCollection(ids: List<String>) = database.list().get(ids)
			suspend fun getCollectionForUser(id: String) = database.list().getForUserID(id)

			suspend fun insert(list: RibaMangaList, force: Boolean = false) {
				val oldList = database.list().get(list.id)

				if (!(force.not() && oldList != null && list.isOlderThan(oldList))) {
					database.list().insert(list)
				}
			}

			suspend fun insertCollection(
				dispatcher: CoroutineDispatcher = Dispatchers.Default,
				mdLists: List<RibaMangaList>,
				force: Boolean = false
			) = withContext(dispatcher) {
				val mdListJob = this.async { mdLists.associateBy { it.id } }
				val oldMDListJob = this.async { getCollection(mdLists.map { it.id }).associateBy { it.id } }

				val mdListMap = mdListJob.await()
				val oldMDListMap = oldMDListJob.await()

				for ((id, newThis) in mdListMap) {
					val oldThis = oldMDListMap[id]

					if (force.not() && oldThis != null && newThis.isOlderThan(oldThis)) continue
					else launch { database.list().insert(newThis) }
				}
			}
		}
	}
}