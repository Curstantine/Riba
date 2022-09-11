package moe.curstantine.mangodex.api.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import moe.curstantine.mangodex.api.database.dao.RoomListDao
import moe.curstantine.mangodex.api.database.dao.RoomMangaDao
import moe.curstantine.mangodex.api.database.entities.RoomList
import moe.curstantine.mangodex.api.database.entities.RoomManga

@Database(entities = [RoomManga::class, RoomList::class], version = 1)
@TypeConverters(Converters::class)
abstract class MangoDatabase : RoomDatabase() {
    abstract fun manga(): RoomMangaDao
    abstract fun list(): RoomListDao
}