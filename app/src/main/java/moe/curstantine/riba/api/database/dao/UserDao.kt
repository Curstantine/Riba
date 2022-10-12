package moe.curstantine.riba.api.database.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import moe.curstantine.riba.api.riba.models.RibaTag
import moe.curstantine.riba.api.riba.models.RibaUser

@Dao
interface UserDao {
    @Query("SELECT * FROM users WHERE id = :id")
    suspend fun get(id: String): RibaUser?

    @Query("SELECT * FROM users WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<RibaTag>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(list: RibaUser)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(lists: List<RibaUser>)

    @Delete
    suspend fun delete(list: RibaUser)
}