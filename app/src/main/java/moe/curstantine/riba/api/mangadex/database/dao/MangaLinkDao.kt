package moe.curstantine.riba.api.mangadex.database.dao

import androidx.room.*
import moe.curstantine.riba.api.riba.models.RibaMangaLink

@Dao
interface MangaLinkDao {
	@Query("SELECT * FROM manga_links WHERE mangaId = :mangaId")
	suspend fun get(mangaId: String): RibaMangaLink?

	@Query("SELECT * FROM manga_links WHERE mangaId IN (:mangaIds)")
	suspend fun get(mangaIds: List<String>): List<RibaMangaLink>

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(manga: RibaMangaLink)

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(manga: List<RibaMangaLink>)

	@Delete
	suspend fun delete(manga: RibaMangaLink)
}