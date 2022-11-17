package moe.curstantine.riba.api.riba

import moe.curstantine.riba.api.mangadex.database.DexDatabase

/**
 * Abstract class for all services to inherit from.
 */
abstract class RibaHttpService {
	abstract val database: Database
	protected abstract val service: APIService

	companion object {
		/**
		 * Should contain the annotated API service interface for retrofit.
		 */
		interface APIService

		/**
		 * Should contain methods to handle inserting, getting, and deleting data from the database.
		 */
		open class Database(private val database: DexDatabase)
	}
}