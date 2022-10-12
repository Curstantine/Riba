package moe.curstantine.riba.api.mangadex

import com.squareup.moshi.Moshi
import com.squareup.moshi.adapters.PolymorphicJsonAdapterFactory
import moe.curstantine.riba.api.EnumConverter
import moe.curstantine.riba.api.NormalizeMismatchType
import moe.curstantine.riba.api.database.RibaDatabase
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexRelatedAuthor
import moe.curstantine.riba.api.mangadex.models.DexRelatedCover
import moe.curstantine.riba.api.mangadex.models.DexRelatedManga
import moe.curstantine.riba.api.mangadex.models.DexRelationship
import moe.curstantine.riba.api.mangadex.models.DexRelationshipImpl
import moe.curstantine.riba.api.mangadex.services.AuthorService
import moe.curstantine.riba.api.mangadex.services.MDListService
import moe.curstantine.riba.api.mangadex.services.MangaService
import moe.curstantine.riba.api.mangadex.services.UserService
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

class MangaDexService(database: RibaDatabase) {
    val author: AuthorService
    val manga: MangaService
    val mdlist: MDListService
    val user: UserService

    init {
        val dexMoshi = Moshi.Builder()
        for (mismatch in NormalizeMismatchType.mismatches) {
            dexMoshi.add(mismatch)
        }
        val poly = PolymorphicJsonAdapterFactory.of(DexRelationship::class.java, "type")
            .withSubtype(DexRelatedManga::class.java, DexEntityType.Manga.toString())
            .withSubtype(DexRelatedCover::class.java, DexEntityType.CoverArt.toString())
            .withSubtype(DexRelatedAuthor::class.java, DexEntityType.Author.toString())
            .withSubtype(DexRelatedAuthor::class.java, DexEntityType.Artist.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Chapter.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.User.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Tag.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.CustomList.toString())
            .withSubtype(DexRelationshipImpl::class.java, DexEntityType.ScanlationGroup.toString())
        dexMoshi.add(poly)

        val retrofit = Retrofit.Builder()
            .baseUrl(DexConstants.BASE_API)
            .addConverterFactory(EnumConverter())
            .addConverterFactory(MoshiConverterFactory.create(dexMoshi.build()))
            .build()

        user = UserService(
            retrofit.create(UserService.Companion.APIService::class.java),
            UserService.Companion.Database(database)
        )
        author = AuthorService(
            retrofit.create(AuthorService.Companion.APIService::class.java),
            AuthorService.Companion.Database(database)
        )
        manga = MangaService(
            retrofit.create(MangaService.Companion.APIService::class.java),
            MangaService.Companion.Database(database),
            author
        )
        mdlist = MDListService(
            retrofit.create(MDListService.Companion.APIService::class.java),
            MDListService.Companion.Database(database)
        )
    }
}