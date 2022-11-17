package moe.curstantine.riba.api.mangadex.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import moe.curstantine.riba.api.mangadex.database.dao.*
import moe.curstantine.riba.api.riba.models.*

@Database(
	version = 1,
	entities = [
		RibaAuthor::class,
		RibaManga::class,
		RibaCover::class,
		RibaMangaList::class,
		RibaMangaLink::class,
		RibaTag::class,
		RibaStatistic::class,
		RibaUser::class,
		RibaChapter::class,
		RibaGroup::class,
		RibaUserFollow::class,
	],
)
@TypeConverters(Converters::class)
abstract class DexDatabase : RoomDatabase() {
	abstract fun author(): AuthorDao
	abstract fun cover(): CoverDao
	abstract fun list(): ListDao
	abstract fun manga(): MangaDao
	abstract fun mangaLink(): MangaLinkDao
	abstract fun tag(): TagDao
	abstract fun statistic(): StatisticDao
	abstract fun user(): UserDao
	abstract fun chapter(): ChapterDao
	abstract fun group(): GroupDao
	abstract fun follows(): UserFollowDao
}