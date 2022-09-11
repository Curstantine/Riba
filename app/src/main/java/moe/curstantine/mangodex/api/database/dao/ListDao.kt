package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.mangodex.models.MangoList

@Dao
interface ListDao {
    @Query("SELECT * FROM lists WHERE id = :id")
    suspend fun get(id: String): MangoList?

    @Query("SELECT * FROM lists WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<MangoList>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(list: MangoList)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(lists: List<MangoList>)

    @Delete
    suspend fun delete(list: MangoList)
}