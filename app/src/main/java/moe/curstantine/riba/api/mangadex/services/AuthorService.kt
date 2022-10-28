package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.DexAuthor
import moe.curstantine.riba.api.mangadex.models.DexAuthorCollection
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.toRibaAuthor
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaAuthor
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import kotlin.coroutines.CoroutineContext

class AuthorService(
	override val service: APIService,
	override val database: Database
) : MangaDexService.Companion.Service() {
	override val coroutineScope = CoroutineScope(Dispatchers.IO)

	suspend fun get(
		id: String,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): RibaResult<RibaAuthor> = contextualInvoke { scope ->
		if (tryDatabase) {
			val localAuthor = database.get(id)
			if (localAuthor != null) return@contextualInvoke localAuthor
		}

		val response = service.get(id).data.toRibaAuthor()
		scope.launch { database.insert(response, forceInsert) }

		return@contextualInvoke response
	}

	suspend fun getCollection(
		ids: List<String>? = null,
		limit: Int = 10,
		offset: Int? = null,
		includes: List<DexEntityType>? = null,
		forceInsert: Boolean = false,
	): RibaResult<List<RibaAuthor>> = contextualInvoke { scope ->
		val response = service.getCollection(ids, limit, offset, includes?.map { it.toDexEnum() })
		val riba = response.data.map { it.toRibaAuthor() }

		scope.launch { database.insertCollection(scope.coroutineContext, riba, forceInsert) }

		return@contextualInvoke riba
	}

	suspend fun getStrictCollection(
		ids: List<String>,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): RibaResult<List<RibaAuthor>> = contextualInvoke {
		val idMap: MutableMap<String, RibaAuthor?> = ids
			.associateBy({ it }, { null })
			.toMutableMap()

		if (tryDatabase) {
			val localArtist = database.getCollection(ids)
			idMap.putAll(localArtist.map { Pair(it.id, it) })
		}

		val missingIds = idMap.filterValues { it == null }.keys.toList()
		if (missingIds.isNotEmpty()) {
			val response = getCollection(ids = missingIds, forceInsert = forceInsert).unwrap()
			response.forEach { artist -> idMap[artist.id] = artist }
		}

		return@contextualInvoke idMap.values.mapNotNull { it }
	}

	companion object {
		@JvmSuppressWildcards
		interface APIService : RibaHttpService.Companion.APIService {
			@GET("/author/{id}")
			suspend fun get(@Path("id") id: String): DexAuthor

			@GET("/author")
			suspend fun getCollection(
				@Query("ids[]") ids: List<String>?,
				@Query("limit") limit: Int?,
				@Query("offset") offset: Int?,
				@Query("includes[]") includes: List<String>?,
			): DexAuthorCollection
		}

		class Database(private val database: DexDatabase) :
			RibaHttpService.Companion.Database(database) {
			suspend fun get(id: String) = database.author().get(id)

			suspend fun getCollection(ids: List<String>) = database.author().get(ids)

			suspend fun insert(author: RibaAuthor, force: Boolean = false) {
				val oldAuthor = database.author().get(author.id)

				if (force.not() && oldAuthor != null && oldAuthor.version >= author.version) {
					return
				}

				database.author().insert(author)
			}

			suspend fun insertCollection(
				context: CoroutineContext,
				authors: List<RibaAuthor>,
				force: Boolean = false
			) = withContext(context) {
				val authorJob = this.async { authors.associateBy { it.id } }
				val oldAuthorJob = this.async {
					getCollection(authors.map { it.id }).associateBy { it.id }
				}

				val oldAuthorMap = oldAuthorJob.await()
				val authorMap = authorJob.await()

				for ((id, newThis) in authorMap) {
					val oldThis = oldAuthorMap[id]

					if (force.not() && oldThis != null && oldThis.version >= newThis.version) {
						continue
					} else {
						launch { database.author().insert(newThis) }
					}
				}
			}
		}
	}
}