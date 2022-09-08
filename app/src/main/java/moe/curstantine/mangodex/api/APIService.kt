package moe.curstantine.mangodex.api

import moe.curstantine.mangodex.api.mangadex.MangaDexService
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

object APIService {
    val mangadex: MangaDexService

    init {
        val retrofitDex = Retrofit.Builder()
            .baseUrl("https://api.mangadex.org/")
            .addConverterFactory(MoshiConverterFactory.create())
            .build()

        mangadex = retrofitDex.create(MangaDexService::class.java)
    }
}