package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.mangodex.models.MangoManga

@Dao
interface MangaDao {
    @Query("SELECT * FROM manga WHERE id = :id")
    suspend fun get(id: String): MangoManga?

    @Query("SELECT * FROM manga WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<MangoManga>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(manga: MangoManga)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(manga: List<MangoManga>)

    @Delete
    suspend fun delete(manga: MangoManga)
}