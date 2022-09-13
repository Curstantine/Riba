package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.riba.models.RibaCover

@Dao
interface CoverDao {
    @Query("SELECT * FROM covers WHERE id = :id")
    suspend fun get(id: String): RibaCover?

    @Query("SELECT * FROM covers WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<RibaCover>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(list: RibaCover)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(lists: List<RibaCover>)

    @Delete
    suspend fun delete(list: RibaCover)
}