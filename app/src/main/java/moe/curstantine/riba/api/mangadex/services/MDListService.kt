package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.*
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaMangaList
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import kotlin.coroutines.CoroutineContext

class MDListService(
	override val service: APIService,
	override val database: Database,
	private val userService: UserService,
) : MangaDexService.Companion.Service() {
	override val coroutineScope = CoroutineScope(Dispatchers.IO)

	private val defaultMDListIncludes = listOf(DexEntityType.User)

	suspend fun get(
		id: String,
		includes: List<DexEntityType> = defaultMDListIncludes,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): RibaResult<RibaMangaList> = contextualInvoke { scope ->
		if (tryDatabase) {
			val localList = database.get(id)
			if (localList != null) return@contextualInvoke localList
		}

		val response = service.get(id, includes.map { it.toDexEnum() })
		val riba = response.data.toRibaMangaList()

		scope.launch { database.insert(riba, forceInsert) }
		scope.launch { insertMeta(coroutineContext, response.data) }

		return@contextualInvoke riba
	}

	private suspend fun insertMeta(context: CoroutineContext, list: DexMDListData) = withContext(context) {
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

		class Database(private val database: DexDatabase) :
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