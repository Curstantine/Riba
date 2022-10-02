package moe.curstantine.riba.api.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import moe.curstantine.riba.api.database.dao.AuthorDao
import moe.curstantine.riba.api.database.dao.CoverDao
import moe.curstantine.riba.api.database.dao.ListDao
import moe.curstantine.riba.api.database.dao.MangaDao
import moe.curstantine.riba.api.database.dao.MangaLinkDao
import moe.curstantine.riba.api.database.dao.TagDao
import moe.curstantine.riba.api.riba.models.RibaAuthor
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaManga
import moe.curstantine.riba.api.riba.models.RibaMangaLink
import moe.curstantine.riba.api.riba.models.RibaMangaList
import moe.curstantine.riba.api.riba.models.RibaTag

@Database(
    version = 1,
    entities = [
        RibaAuthor::class,
        RibaManga::class,
        RibaCover::class,
        RibaMangaList::class,
        RibaMangaLink::class,
        RibaTag::class,
    ],
)
@TypeConverters(Converters::class)
abstract class RibaDatabase : RoomDatabase() {
    abstract fun author(): AuthorDao
    abstract fun cover(): CoverDao
    abstract fun list(): ListDao
    abstract fun manga(): MangaDao
    abstract fun mangaLink(): MangaLinkDao
    abstract fun tag(): TagDao
}