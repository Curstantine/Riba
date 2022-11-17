package moe.curstantine.riba.api.mangadex

import android.content.Context
import androidx.room.Room
import kotlinx.coroutines.CoroutineScope
import moe.curstantine.riba.api.adapters.retrofit.EnumConverter
import moe.curstantine.riba.api.adapters.retrofit.HeaderInterceptor
import moe.curstantine.riba.api.mangadex.database.DexDatabase
import moe.curstantine.riba.api.mangadex.services.*
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

class MangaDexService(context: Context, applicationCoroutineScope: CoroutineScope) {
	private val database = Room
		.databaseBuilder(context, DexDatabase::class.java, DexConstants.DATABASE_NAME)
		.build()

	private val okhttp = OkHttpClient.Builder()
		.addInterceptor(HeaderInterceptor(DexLogTag.REQUEST))
		.build()

	private val retrofit = Retrofit.Builder()
		.client(okhttp)
		.baseUrl(DexConstants.BASE_API)
		.addConverterFactory(EnumConverter())
		.addConverterFactory(MoshiConverterFactory.create(Serde.moshi))
		.build()

	val user: UserService = UserService(
		context,
		applicationCoroutineScope,
		retrofit.create(UserService.Companion.APIService::class.java),
		UserService.Companion.Database(database)
	)

	val author: AuthorService = AuthorService(
		retrofit.create(AuthorService.Companion.APIService::class.java),
		AuthorService.Companion.Database(database)
	)

	val group: GroupService = GroupService(
		retrofit.create(GroupService.Companion.APIService::class.java),
		GroupService.Companion.Database(database),
		user,
	)

	val chapter: ChapterService = ChapterService(
		retrofit.create(ChapterService.Companion.APIService::class.java),
		ChapterService.Companion.Database(database),
		user,
		group
	)

	val manga: MangaService = MangaService(
		retrofit.create(MangaService.Companion.APIService::class.java),
		MangaService.Companion.Database(database),
		author,
		user,
	)

	val mdList: MDListService = MDListService(
		retrofit.create(MDListService.Companion.APIService::class.java),
		MDListService.Companion.Database(database),
		user,
	)

	companion object {
		val Serde = DexSerde()
	}
}