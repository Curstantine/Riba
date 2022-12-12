package moe.curstantine.riba.api.mangadex.database.dao

import androidx.room.*
import moe.curstantine.riba.api.riba.models.RibaMangaList

@Dao
interface ListDao {
	@Query("SELECT * FROM lists WHERE id = :id")
	suspend fun get(id: String): RibaMangaList?

	@Query("SELECT * FROM lists WHERE id IN (:ids)")
	suspend fun get(ids: List<String>): List<RibaMangaList>

	@Query("SELECT * FROM lists WHERE userId IN (:id)")
	suspend fun getForUserID(id: String): List<RibaMangaList>

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(list: RibaMangaList)

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(lists: List<RibaMangaList>)

	@Delete
	suspend fun delete(list: RibaMangaList)
}