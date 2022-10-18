package moe.curstantine.riba.api.mangadex

import android.content.Context
import androidx.room.Room
import com.squareup.moshi.Moshi
import com.squareup.moshi.adapters.PolymorphicJsonAdapterFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.EnumConverter
import moe.curstantine.riba.api.NormalizeMismatchType
import moe.curstantine.riba.api.mangadex.database.DexDatabase
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
import moe.curstantine.riba.api.riba.RibaHttpService
import moe.curstantine.riba.api.riba.RibaResult
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

class MangaDexService(context: Context) {
    private val database = Room
        .databaseBuilder(context, DexDatabase::class.java, DexConstants.DATABASE_NAME)
        .build()

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
            context,
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

    companion object {
        /**
         * Abstract class for MangaDex to inherit from.
         *
         * Implements [contextualInvoke] of [RibaHttpService] to handle [DexError]s
         */
        abstract class Service : RibaHttpService() {
            override suspend fun <T> contextualInvoke(
                call: suspend (it: CoroutineScope) -> T
            ): RibaResult<T> = withContext(coroutineScope.coroutineContext) {
                try {
                    RibaResult.Success(call.invoke(this))
                } catch (e: Throwable) {
                    RibaResult.Error(DexError.tryHandle(e))
                }
            }
        }
    }
}