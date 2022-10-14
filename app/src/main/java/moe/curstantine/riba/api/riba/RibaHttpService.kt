package moe.curstantine.riba.api.riba

import kotlinx.coroutines.CoroutineScope
import moe.curstantine.riba.api.database.RibaDatabase

/**
 * Abstract class for all services to inherit from.
 */
abstract class RibaHttpService(service: APIService, database: Database) {
    abstract val coroutineScope: CoroutineScope

    abstract suspend fun <T> contextualInvoke(call: suspend (it: CoroutineScope) -> T): RibaResult<T>

    companion object {
        /**
         * Should contain the annotated API service interface for retrofit.
         */
        interface APIService

        /**
         * Should contain methods to handle inserting, getting, and deleting data from the database.
         */
        open class Database(database: RibaDatabase)
    }
}