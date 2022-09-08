package moe.curstantine.mangodex.api.mangadex

import moe.curstantine.mangodex.api.mangadex.models.DexMDList
import moe.curstantine.mangodex.api.mangadex.models.DexManga
import retrofit2.http.GET
import retrofit2.http.Path

interface MangaDexService {

    @GET("/manga/{id}")
    suspend fun getManga(@Path("id") id: String): DexManga

    @GET("/list/{id}")
    suspend fun getMDList(@Path("id") id: String): DexMDList
}