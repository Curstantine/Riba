package moe.curstantine.riba.api.database.dao

import androidx.room.*
import moe.curstantine.riba.api.riba.models.RibaAuthor

@Dao
interface AuthorDao {
    @Query("SELECT * FROM authors WHERE id = :id")
    suspend fun get(id: String): RibaAuthor?

    @Query("SELECT * FROM authors WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<RibaAuthor>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(list: RibaAuthor)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(lists: List<RibaAuthor>)

    @Delete
    suspend fun delete(list: RibaAuthor)
}