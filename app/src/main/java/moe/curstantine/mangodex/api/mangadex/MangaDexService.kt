package moe.curstantine.mangodex.api.mangadex

import moe.curstantine.mangodex.api.mangadex.models.*
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import retrofit2.http.QueryMap

@JvmSuppressWildcards
interface MangaDexService {
    @GET("/manga/{id}")
    suspend fun getManga(@Path("id") id: String): DexManga

    @GET("/manga")
    suspend fun getMangaList(
        @Query("ids[]") ids: List<String>?,
        @Query("limit") limit: Int?,
        @Query("offset") offset: Int?,
        @Query("includes[]") includes: List<DexEntityType>?,
        @QueryMap sort: Map<String, DexQueryOrderValue>?,
    ): DexMangaCollection

    @GET("/list/{id}")
    suspend fun getMDList(@Path("id") id: String): DexMDList
}