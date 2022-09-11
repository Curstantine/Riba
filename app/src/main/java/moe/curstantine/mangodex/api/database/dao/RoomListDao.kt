package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.database.entities.RoomList

@Dao
interface RoomListDao {
    @Query("SELECT * FROM md_lists WHERE id = :id")
    fun get(id: String): RoomList?

    @Query("SELECT * FROM md_lists WHERE id IN (:ids)")
    fun get(ids: List<String>): List<RoomList>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insert(list: RoomList)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insert(lists: List<RoomList>)

    @Delete
    fun delete(list: RoomList)
}