package moe.curstantine.mangodex.api.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import moe.curstantine.mangodex.api.database.dao.*
import moe.curstantine.mangodex.api.mangodex.models.*

@Database(
    version = 1,
    entities = [
        MangoAuthor::class,
        MangoManga::class,
        MangoCover::class,
        MangoList::class,
        MangoMangaLink::class,
    ],
)
@TypeConverters(Converters::class)
abstract class MangoDatabase : RoomDatabase() {
    abstract fun author(): AuthorDao
    abstract fun cover(): CoverDao
    abstract fun list(): ListDao
    abstract fun manga(): MangaDao
    abstract fun mangaLink(): MangaLinkDao
}