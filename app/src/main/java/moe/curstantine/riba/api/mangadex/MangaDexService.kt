package moe.curstantine.riba.api.mangadex

import android.content.Context
import androidx.room.Room
import com.squareup.moshi.Moshi
import com.squareup.moshi.adapters.PolymorphicJsonAdapterFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.adapters.moshi.LocalDateTimeConverter
import moe.curstantine.riba.api.adapters.moshi.MapMismatchArrayAdapter
import moe.curstantine.riba.api.adapters.moshi.NormalizeMismatchType
import moe.curstantine.riba.api.adapters.retrofit.EnumConverter
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.mangadex.models.DexRelatedAuthor
import moe.curstantine.riba.api.mangadex.models.DexRelatedCover
import moe.curstantine.riba.api.mangadex.models.DexRelatedGroup
import moe.curstantine.riba.api.mangadex.models.DexRelatedManga
import moe.curstantine.riba.api.mangadex.models.DexRelatedUser
import moe.curstantine.riba.api.mangadex.models.DexRelationship
import moe.curstantine.riba.api.mangadex.models.DexRelationshipImpl
import moe.curstantine.riba.api.mangadex.services.AuthorService
import moe.curstantine.riba.api.mangadex.services.ChapterService
import moe.curstantine.riba.api.mangadex.services.GroupService
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
    val chapter: ChapterService
    val group: GroupService
    val manga: MangaService
    val mdlist: MDListService
    val user: UserService

    init {
        val retrofit = Retrofit.Builder()
            .baseUrl(DexConstants.BASE_API)
            .addConverterFactory(EnumConverter())
            .addConverterFactory(MoshiConverterFactory.create(dexMoshi))
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

        group = GroupService(
            retrofit.create(GroupService.Companion.APIService::class.java),
            GroupService.Companion.Database(database)
        )

        chapter = ChapterService(
            retrofit.create(ChapterService.Companion.APIService::class.java),
            ChapterService.Companion.Database(database),
            user,
            group
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
        val dexMoshi: Moshi = Moshi.Builder()
            .add(LocalDateTimeConverter())
            .add(MapMismatchArrayAdapter())
            .add(NormalizeMismatchType.new(DexLocale::class.java, DexLocale.NotImplemented))
            .add(
                PolymorphicJsonAdapterFactory.of(DexRelationship::class.java, "type")
                    .withSubtype(DexRelatedManga::class.java, DexEntityType.Manga.toDexEnum())
                    .withSubtype(DexRelatedCover::class.java, DexEntityType.CoverArt.toDexEnum())
                    .withSubtype(DexRelatedAuthor::class.java, DexEntityType.Author.toDexEnum())
                    .withSubtype(DexRelatedAuthor::class.java, DexEntityType.Artist.toDexEnum())
                    .withSubtype(DexRelatedUser::class.java, DexEntityType.User.toDexEnum())
                    .withSubtype(DexRelatedUser::class.java, DexEntityType.Leader.toDexEnum())
                    .withSubtype(DexRelatedUser::class.java, DexEntityType.Member.toDexEnum())
                    .withSubtype(
                        DexRelatedGroup::class.java,
                        DexEntityType.ScanlationGroup.toString()
                    )
                    .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Chapter.toDexEnum())
                    .withSubtype(DexRelationshipImpl::class.java, DexEntityType.Tag.toDexEnum())
                    .withSubtype(
                        DexRelationshipImpl::class.java,
                        DexEntityType.CustomList.toString()
                    )
            )
            .build()

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