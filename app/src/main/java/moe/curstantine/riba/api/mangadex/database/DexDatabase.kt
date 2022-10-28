package moe.curstantine.riba.api.mangadex.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import moe.curstantine.riba.api.mangadex.database.dao.AuthorDao
import moe.curstantine.riba.api.mangadex.database.dao.ChapterDao
import moe.curstantine.riba.api.mangadex.database.dao.CoverDao
import moe.curstantine.riba.api.mangadex.database.dao.GroupDao
import moe.curstantine.riba.api.mangadex.database.dao.ListDao
import moe.curstantine.riba.api.mangadex.database.dao.MangaDao
import moe.curstantine.riba.api.mangadex.database.dao.MangaLinkDao
import moe.curstantine.riba.api.mangadex.database.dao.StatisticDao
import moe.curstantine.riba.api.mangadex.database.dao.TagDao
import moe.curstantine.riba.api.mangadex.database.dao.UserDao
import moe.curstantine.riba.api.mangadex.database.dao.UserFollowDao
import moe.curstantine.riba.api.riba.models.RibaAuthor
import moe.curstantine.riba.api.riba.models.RibaChapter
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaGroup
import moe.curstantine.riba.api.riba.models.RibaManga
import moe.curstantine.riba.api.riba.models.RibaMangaLink
import moe.curstantine.riba.api.riba.models.RibaMangaList
import moe.curstantine.riba.api.riba.models.RibaStatistic
import moe.curstantine.riba.api.riba.models.RibaTag
import moe.curstantine.riba.api.riba.models.RibaUser
import moe.curstantine.riba.api.riba.models.RibaUserFollow

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