package moe.curstantine.riba.api.mangadex.database.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import moe.curstantine.riba.api.riba.models.RibaStatistic


@Dao
interface StatisticDao {
    @Query("SELECT * FROM statistics WHERE id = :id")
    suspend fun get(id: String): RibaStatistic?

    @Query("SELECT * FROM statistics WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<RibaStatistic>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(manga: RibaStatistic)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(manga: List<RibaStatistic>)

    @Delete
    suspend fun delete(manga: RibaStatistic)
}