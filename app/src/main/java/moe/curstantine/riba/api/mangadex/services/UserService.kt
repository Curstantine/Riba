package moe.curstantine.riba.api.mangadex.services

import moe.curstantine.riba.api.database.RibaDatabase
import moe.curstantine.riba.api.mangadex.models.DexUserAuthBody
import moe.curstantine.riba.api.mangadex.models.DexUserAuthResponse
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import retrofit2.http.Body
import retrofit2.http.POST

class UserService(
    private var service: APIService,
    private var database: Database,
) : RibaHttpService(service, database) {
    suspend fun login(username: String, password: String): RibaResult<DexUserAuthResponse> =
        contextualInvoke {
            return@contextualInvoke service.login(DexUserAuthBody(username, password))
        }

    companion object {
        interface APIService : RibaHttpService.Companion.APIService {
            @POST("/auth/login")
            suspend fun login(@Body body: DexUserAuthBody): DexUserAuthResponse
        }

        class Database(private val database: RibaDatabase) : RibaHttpService.Companion.Database(database)
    }
}