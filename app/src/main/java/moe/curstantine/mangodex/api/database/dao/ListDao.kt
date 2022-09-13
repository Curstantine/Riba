package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.riba.models.RibaMangaList

@Dao
interface ListDao {
    @Query("SELECT * FROM lists WHERE id = :id")
    suspend fun get(id: String): RibaMangaList?

    @Query("SELECT * FROM lists WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<RibaMangaList>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(list: RibaMangaList)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(lists: List<RibaMangaList>)

    @Delete
    suspend fun delete(list: RibaMangaList)
}