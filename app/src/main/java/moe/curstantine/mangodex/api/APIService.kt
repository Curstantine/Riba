package moe.curstantine.mangodex.api

import moe.curstantine.mangodex.api.mangadex.DexConstants
import moe.curstantine.mangodex.api.mangadex.MangaDexHandler
import moe.curstantine.mangodex.api.mangadex.MangaDexService
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

object APIService {
    val mangadex: MangaDexHandler

    init {
        val retrofitDex = Retrofit.Builder()
            .baseUrl(DexConstants.baseApi)
            .addConverterFactory(EnumConverter())
            .addConverterFactory(MoshiConverterFactory.create())
            .build()

        mangadex = MangaDexHandler(retrofitDex.create(MangaDexService::class.java))
    }
}

