package moe.curstantine.mangodex.api.database.dao

import androidx.room.*
import moe.curstantine.mangodex.api.mangodex.models.MangoMangaLink

@Dao
interface MangaLinkDao {
    @Query("SELECT * FROM manga_links WHERE mangaId = :mangaId")
    suspend fun get(mangaId: String): MangoMangaLink?

    @Query("SELECT * FROM manga_links WHERE mangaId IN (:mangaIds)")
    suspend fun get(mangaIds: List<String>): List<MangoMangaLink>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(manga: MangoMangaLink)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(manga: List<MangoMangaLink>)

    @Delete
    suspend fun delete(manga: MangoMangaLink)
}