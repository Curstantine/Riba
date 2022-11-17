package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.*
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.*
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.models.RibaMangaList
import retrofit2.http.GET
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
		launch { insertMeta(dispatcher, response.data) }

		return@withContext riba
	}

	private suspend fun insertMeta(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		list: DexMDListData,
	) = withContext(dispatcher) {
		launch {
			val uploader = list.relationships
				.first { it.type == DexEntityType.User }
				.let { it as DexRelatedUser }

			userService.database.insert(uploader.toRibaUser())
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
		}

		class Database(private val database: DexDatabase) : RibaHttpService.Companion.Database(database) {
			suspend fun get(id: String) = database.list().get(id)

			suspend fun insert(list: RibaMangaList, force: Boolean = false) {
				val oldList = database.list().get(list.id)

				if (!(force.not() && oldList != null && list.isOlderThan(oldList))) {
					database.list().insert(list)
				}
			}
		}
	}
}