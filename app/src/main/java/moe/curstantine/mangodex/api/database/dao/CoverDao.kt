package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.mangodex.models.MangoCover

@Dao
interface CoverDao {
    @Query("SELECT * FROM covers WHERE id = :id")
    suspend fun get(id: String): MangoCover?

    @Query("SELECT * FROM covers WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<MangoCover>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(list: MangoCover)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(lists: List<MangoCover>)

    @Delete
    suspend fun delete(list: MangoCover)
}