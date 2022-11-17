package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.*
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.DexAuthor
import moe.curstantine.riba.api.mangadex.models.DexAuthorCollection
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.toRibaAuthor
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.models.RibaAuthor
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import kotlin.coroutines.CoroutineContext

class AuthorService(override val service: APIService, override val database: Database) : RibaHttpService() {
	suspend fun get(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		id: String,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): RibaAuthor = withContext(dispatcher) {
		if (tryDatabase) {
			val localAuthor = database.get(id)
			if (localAuthor != null) return@withContext localAuthor
		}

		val response = service.get(id).data.toRibaAuthor()
		launch { database.insert(response, forceInsert) }

		return@withContext response
	}

	suspend fun getCollection(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		ids: List<String>? = null,
		limit: Int = 10,
		offset: Int? = null,
		includes: List<DexEntityType>? = null,
		forceInsert: Boolean = false,
	): List<RibaAuthor> = withContext(dispatcher) {
		val response = service
			.getCollection(ids, limit, offset, includes?.map { it.toDexEnum() })
			.data.map { it.toRibaAuthor() }
		launch { database.insertCollection(coroutineContext, response, forceInsert) }

		return@withContext response
	}

	suspend fun getStrictCollection(
		dispatcher: CoroutineDispatcher = Dispatchers.Default,
		ids: List<String>,
		forceInsert: Boolean = false,
		tryDatabase: Boolean = true,
	): List<RibaAuthor> = withContext(dispatcher) {
		val idMap: MutableMap<String, RibaAuthor?> = ids
			.associateBy({ it }, { null })
			.toMutableMap()

		if (tryDatabase) {
			val localArtist = database.getCollection(ids)
			idMap.putAll(localArtist.map { Pair(it.id, it) })
		}

		val missingIds = idMap.filterValues { it == null }.keys.toList()
		if (missingIds.isNotEmpty()) {
			getCollection(ids = missingIds, limit = missingIds.size, forceInsert = forceInsert)
				.forEach { artist -> idMap[artist.id] = artist }
		}

		return@withContext idMap.values.mapNotNull { it }
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

		class Database(private val database: DexDatabase) : RibaHttpService.Companion.Database(database) {
			suspend fun get(id: String) = database.author().get(id)

			suspend fun getCollection(ids: List<String>) = database.author().get(ids)

			suspend fun insert(author: RibaAuthor, force: Boolean = false) {
				val oldAuthor = database.author().get(author.id)

				if (!(force.not() && oldAuthor != null && author.isOlderThan(oldAuthor))) {
					database.author().insert(author)
				}
			}

			suspend fun insertCollection(
				context: CoroutineContext,
				authors: List<RibaAuthor>,
				force: Boolean = false
			) = withContext(context) {
				val authorJob = async { authors.associateBy { it.id } }
				val oldAuthorJob = async { getCollection(authors.map { it.id }).associateBy { it.id } }

				val oldAuthorMap = oldAuthorJob.await()
				val authorMap = authorJob.await()

				for ((id, newThis) in authorMap) {
					val oldThis = oldAuthorMap[id]

					if (force.not() && oldThis != null && newThis.isOlderThan(oldThis)) continue
					else launch { database.author().insert(newThis) }
				}
			}
		}
	}
}