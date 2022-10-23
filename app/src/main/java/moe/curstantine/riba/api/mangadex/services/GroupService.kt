package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.models.RibaGroup
import kotlin.coroutines.CoroutineContext

class GroupService(
    override val service: APIService,
    override val database: Database,
) : MangaDexService.Companion.Service() {
    override val coroutineScope = CoroutineScope(Dispatchers.IO)

    companion object {
        interface APIService : RibaHttpService.Companion.APIService

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
                context: CoroutineContext,
                groups: Collection<RibaGroup>,
                force: Boolean = false
            ) = withContext(context) {
                val groupJob = this.async { groups.associateBy { it.id } }
                val oldGroupJob = this.async {
                    getCollection(groups.map { it.id }).associateBy { it.id }
                }

                val groupMap = groupJob.await()
                val oldGroupMap = oldGroupJob.await()

                for ((id, newThis) in groupMap) {
                    val oldThis = oldGroupMap[id]

                    if (force.not() && oldThis != null && oldThis.version >= newThis.version) {
                        continue
                    } else {
                        launch { database.group().insert(newThis) }
                    }
                }
            }
        }
    }
}