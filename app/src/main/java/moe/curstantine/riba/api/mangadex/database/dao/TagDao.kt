package moe.curstantine.riba.api.mangadex.database.dao

import androidx.room.*
import moe.curstantine.riba.api.riba.models.RibaTag

@Dao
interface TagDao {
	@Query("SELECT * FROM tags WHERE id = :id")
	suspend fun get(id: String): RibaTag?

	@Query("SELECT * FROM tags WHERE id IN (:ids)")
	suspend fun get(ids: List<String>): List<RibaTag>

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(list: RibaTag)

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(lists: List<RibaTag>)

	@Delete
	suspend fun delete(list: RibaTag)
}