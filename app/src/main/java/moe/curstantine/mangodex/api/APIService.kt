package moe.curstantine.mangodex.api

import com.squareup.moshi.Moshi
import com.squareup.moshi.adapters.PolymorphicJsonAdapterFactory
import moe.curstantine.mangodex.api.mangadex.DexConstants
import moe.curstantine.mangodex.api.mangadex.MangaDexHandler
import moe.curstantine.mangodex.api.mangadex.MangaDexService
import moe.curstantine.mangodex.api.mangadex.models.*
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

object APIService {
    val mangadex: MangaDexHandler

    init {
        val retrofitDex = Retrofit.Builder()
            .baseUrl(DexConstants.BASE_API)
            .addConverterFactory(EnumConverter())
            .addConverterFactory(MoshiConverterFactory.create(createDexMoshi()))
            .build()

        mangadex = MangaDexHandler(retrofitDex.create(MangaDexService::class.java))
    }

    private fun createDexMoshi(): Moshi {
        val dexMoshi = Moshi.Builder()
        for (mismatch in NormalizeMismatchType.mismatches) {
            dexMoshi.add(mismatch)
        }

        val poly = PolymorphicJsonAdapterFactory.of(DexRelationship::class.java, "type")
            .withSubtype(DexRelatedManga::class.java, DexEntityType.Manga.toString())
            .withSubtype(DexRelatedCover::class.java, DexEntityType.CoverArt.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Author.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Artist.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Chapter.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.User.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Tag.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.CustomList.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.ScanlationGroup.toString())

        dexMoshi.add(poly)
        return dexMoshi.build()
    }
}

