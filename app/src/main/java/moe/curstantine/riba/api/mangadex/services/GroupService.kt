package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.*
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.*
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.models.RibaGroup
import retrofit2.http.GET
import retrofit2.http.Query

class GroupService(
	override val service: APIService,
	override val database: Database,
	private val userService: UserService
) : RibaHttpService() {
	private val defaultGroupIncludes = listOf(DexEntityType.Leader, DexEntityType.Member)

	suspend fun getCollection(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		ids: List<String>? = null,
		name: String? = null,
		limit: Int? = 10,
		offset: Int? = null,
		includes: List<DexEntityType>? = defaultGroupIncludes,
		forceInsert: Boolean = false,
	): List<RibaGroup> = withContext(dispatcher) {
		val response = service.getCollection(
			ids = ids,
			name = name,
			limit = limit,
			offset = offset,
			includes = includes?.map { it.toDexEnum() }
		)

		val riba = response.data.map { it.toRibaGroup() }

		launch { database.insertCollection(dispatcher, riba, forceInsert) }
		launch { response.data.forEach { insertGroupMeta(dispatcher, it, forceInsert) } }

		return@withContext riba
	}

	suspend fun getStrictCollection(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		ids: List<String>,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): List<RibaGroup> = withContext(dispatcher) {
		val idMap: MutableMap<String, RibaGroup?> = ids
			.associateBy({ it }, { null })
			.toMutableMap()

		if (tryDatabase) {
			val localGroups = database.getCollection(ids)
			idMap.putAll(localGroups.map { Pair(it.id, it) })
		}

		val missingIds = idMap.filterValues { it == null }.keys.toList()
		if (missingIds.isNotEmpty()) {
			getCollection(ids = missingIds, forceInsert = forceInsert)
				.forEach { group -> idMap[group.id] = group }
		}

		return@withContext idMap.values.mapNotNull { it }
	}

	private suspend fun insertGroupMeta(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		group: DexGroupData,
		forceInsert: Boolean
	) = withContext(dispatcher) {
		// We will be skipping leader since leader is included in both member and itself.
		val members = group.relationships
			.filter { it.type == DexEntityType.Member }
			.map { (it as DexRelatedUser).toRibaUser() }

		userService.database.insertCollection(dispatcher, members, forceInsert)
	}

	companion object {
		@JvmSuppressWildcards
		interface APIService : RibaHttpService.Companion.APIService {
			@GET("/group")
			fun getCollection(
				@Query("ids[]") ids: List<String>?,
				@Query("name") name: String?,
				@Query("limit") limit: Int?,
				@Query("offset") offset: Int?,
				@Query("includes[]") includes: List<String>?,
			): DexGroupCollection
		}

		class Database(
			private val database: DexDatabase
		) : RibaHttpService.Companion.Database(database) {
			suspend fun get(id: String) = database.group().get(id)

			suspend fun getCollection(ids: List<String>) = database.group().get(ids)

			suspend fun insert(group: RibaGroup, force: Boolean = false) {
				val oldGroup = database.chapter().get(group.id)

				if (force.not() && oldGroup != null && oldGroup.version >= group.version) {
					return
				}

				database.group().insert(group)
			}

			suspend fun insertCollection(
				dispatcher: CoroutineDispatcher = Dispatchers.Default,
				groups: Collection<RibaGroup>,
				force: Boolean = false
			) = withContext(dispatcher) {
				val groupJob = this.async { groups.associateBy { it.id } }
				val oldGroupJob = this.async {
					getCollection(groups.map { it.id }).associateBy { it.id }
				}

				val groupMap = groupJob.await()
				val oldGroupMap = oldGroupJob.await()

				for ((id, newThis) in groupMap) {
					val oldThis = oldGroupMap[id]

					if (force.not() && oldThis != null && newThis.isOlderThan(oldThis)) continue
					else launch { database.group().insert(newThis) }
				}
			}
		}
	}
}