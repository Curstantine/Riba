package moe.curstantine.riba.api.mangadex.database.dao

import androidx.room.*
import moe.curstantine.riba.api.riba.models.RibaUser
import moe.curstantine.riba.api.riba.models.RibaUserFollow

@Dao
interface UserFollowDao {
	@Query("SELECT * FROM user_follows WHERE mangaId = :mangaId")
	suspend fun get(mangaId: String): RibaUserFollow?

	@Query("SELECT * FROM user_follows WHERE followedUsers LIKE '%' || :userId || '%'")
	suspend fun getFromUser(userId: String): List<RibaUserFollow>?

	@Insert(onConflict = OnConflictStrategy.REPLACE)
	suspend fun insert(list: RibaUserFollow)

	@Delete
	suspend fun delete(list: RibaUser)
}