package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.mangodex.models.MangoArtist

@Dao
interface ArtistDao {
    @Query("SELECT * FROM artists WHERE id = :id")
    suspend fun get(id: String): MangoArtist?

    @Query("SELECT * FROM artists WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<MangoArtist>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(list: MangoArtist)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(lists: List<MangoArtist>)

    @Delete
    suspend fun delete(list: MangoArtist)
}