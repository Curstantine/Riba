package moe.curstantine.riba.api.mangadex.database.dao

import androidx.room.*
import moe.curstantine.riba.api.riba.models.RibaGroup

@Dao
interface GroupDao {
	@Query("SELECT * FROM groups WHERE id = :id")
	suspend fun get(id: String): RibaGroup?

	@Query("SELECT * FROM groups WHERE id IN (:ids)")
	suspend fun get(ids: List<String>): List<RibaGroup>

	@Query("SELECT * FROM groups WHERE leader = :leaderId")
	suspend fun getFromLeaderId(leaderId: String): List<RibaGroup>

	@Query("SELECT * FROM groups WHERE members LIKE '%' || :userId || '%'")
	suspend fun getFromUserId(userId: String): List<RibaGroup>

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(list: RibaGroup)

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(lists: List<RibaGroup>)

	@Delete
	suspend fun delete(list: RibaGroup)
}