package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.database.entities.RoomManga

@Dao
interface RoomMangaDao {
    @Query("SELECT * FROM manga WHERE id = :id")
    fun get(id: String): RoomManga?

    @Query("SELECT * FROM manga WHERE id IN (:ids)")
    fun get(ids: List<String>): List<RoomManga>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insert(manga: RoomManga)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insert(manga: List<RoomManga>)

    @Delete
    fun delete(manga: RoomManga)
}