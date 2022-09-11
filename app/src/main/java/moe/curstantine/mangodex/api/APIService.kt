package moe.curstantine.mangodex.api

import android.content.Context
import androidx.room.Room
import com.squareup.moshi.Moshi
import com.squareup.moshi.adapters.PolymorphicJsonAdapterFactory
import moe.curstantine.mangodex.api.database.MangoDatabase
import moe.curstantine.mangodex.api.mangadex.DexConstants
import moe.curstantine.mangodex.api.mangadex.MangaDexHandler
import moe.curstantine.mangodex.api.mangadex.MangaDexService
import moe.curstantine.mangodex.api.mangadex.models.*
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

object APIService {
    val mangadex: MangaDexHandler = createDexHandler()
    lateinit var database: MangoDatabase

    fun createMangoDatabase(context: Context) {
        val roomDatabase = Room.databaseBuilder(
            context, MangoDatabase::class.java, "MangoDatabase"
        )

        this.database = roomDatabase.build()
    }

    private fun createDexHandler(): MangaDexHandler {
        val dexMoshi = Moshi.Builder()
        for (mismatch in NormalizeMismatchType.mismatches) {
            dexMoshi.add(mismatch)
        }


        val poly = PolymorphicJsonAdapterFactory.of(DexRelationship::class.java, "type")
            .withSubtype(DexRelatedManga::class.java, DexEntityType.Manga.toString())
            .withSubtype(DexRelatedCover::class.java, DexEntityType.CoverArt.toString())
            .withSubtype(DexRelatedAuthorArtist::class.java, DexEntityType.Author.toString())
            .withSubtype(DexRelatedAuthorArtist::class.java, DexEntityType.Artist.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Chapter.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.User.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Tag.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.CustomList.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.ScanlationGroup.toString())
        dexMoshi.add(poly)

        val retrofitDex = Retrofit.Builder()
            .baseUrl(DexConstants.BASE_API)
            .addConverterFactory(EnumConverter())
            .addConverterFactory(MoshiConverterFactory.create(dexMoshi.build()))
            .build()

        return MangaDexHandler(retrofitDex.create(MangaDexService::class.java))
    }
}

