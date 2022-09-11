package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.mangodex.models.MangoAuthor

@Dao
interface AuthorDao {
    @Query("SELECT * FROM authors WHERE id = :id")
    suspend fun get(id: String): MangoAuthor?

    @Query("SELECT * FROM authors WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<MangoAuthor>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(list: MangoAuthor)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(lists: List<MangoAuthor>)

    @Delete
    suspend fun delete(list: MangoAuthor)
}