package moe.curstantine.riba.api.mangadex.database.dao

import androidx.room.*
import moe.curstantine.riba.api.riba.models.RibaManga

@Dao
interface MangaDao {
	@Query("SELECT * FROM manga WHERE id = :id")
	suspend fun get(id: String): RibaManga?

	@Query("SELECT * FROM manga WHERE id IN (:ids)")
	suspend fun get(ids: List<String>): List<RibaManga>

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(manga: RibaManga)

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(manga: List<RibaManga>)

	@Delete
	suspend fun delete(manga: RibaManga)
}