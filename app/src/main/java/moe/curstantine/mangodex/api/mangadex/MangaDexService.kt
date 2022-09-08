package moe.curstantine.mangodex.api.mangadex

import moe.curstantine.mangodex.api.mangadex.models.DexMDList
import moe.curstantine.mangodex.api.mangadex.models.DexManga
import moe.curstantine.mangodex.api.mangadex.models.DexMangaCollection
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query

interface MangaDexService {
    @GET("/manga/{id}")
    suspend fun getManga(@Path("id") id: String): DexManga

    @GET("/manga")
    suspend fun getMangaList(@Query("ids[]") ids: List<String>): DexMangaCollection

    @GET("/list/{id}")
    suspend fun getMDList(@Path("id") id: String): DexMDList
}