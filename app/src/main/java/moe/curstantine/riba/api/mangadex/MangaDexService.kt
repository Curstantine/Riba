package moe.curstantine.riba.api.mangadex

import moe.curstantine.riba.api.mangadex.models.*
import retrofit2.http.GET
import retrofit2.http.Path
import retrofit2.http.Query
import retrofit2.http.QueryMap

@JvmSuppressWildcards
interface MangaDexService {
    @GET("/author/{id}")
    suspend fun getAuthor(@Path("id") id: String): DexAuthor

    @GET("/author")
    suspend fun getAuthor(@Path("ids[]") id: List<String>): DexAuthorCollection

    @GET("/list/{id}")
    suspend fun getMDList(@Path("id") id: String): DexMDList

    @GET("/cover/{id}")
    suspend fun getCover(@Path("id") id: String): DexCover

    @GET("/manga/{id}")
    suspend fun getManga(
        @Path("id") id: String,
        @Query("includes[]") includes: List<DexEntityType>?
    ): DexManga

    @GET("/manga")
    suspend fun getManga(
        @Query("ids[]") ids: List<String>?,
        @Query("limit") limit: Int?,
        @Query("offset") offset: Int?,
        @Query("includes[]") includes: List<DexEntityType>?,
        @QueryMap sort: Map<String, DexQueryOrderValue>?,
    ): DexMangaCollection
}