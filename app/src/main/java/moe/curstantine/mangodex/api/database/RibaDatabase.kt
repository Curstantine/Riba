package moe.curstantine.mangodex.api.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import moe.curstantine.mangodex.api.database.dao.*
import moe.curstantine.mangodex.api.riba.models.*

@Database(
    version = 1,
    entities = [
        RibaAuthor::class,
        RibaManga::class,
        RibaCover::class,
        RibaMangaList::class,
        RibaMangaLink::class,
    ],
)
@TypeConverters(Converters::class)
abstract class RibaDatabase : RoomDatabase() {
    abstract fun author(): AuthorDao
    abstract fun cover(): CoverDao
    abstract fun list(): ListDao
    abstract fun manga(): MangaDao
    abstract fun mangaLink(): MangaLinkDao
}