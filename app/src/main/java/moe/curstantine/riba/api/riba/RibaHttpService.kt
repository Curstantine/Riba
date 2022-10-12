package moe.curstantine.riba.api.riba

import moe.curstantine.riba.api.database.RibaDatabase

/**
 * Abstract class for all services to inherit from.
 */
abstract class RibaHttpService(
    private var service: APIService,
    private var database: Database
) {
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