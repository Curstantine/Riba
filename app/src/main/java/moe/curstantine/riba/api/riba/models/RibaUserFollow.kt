package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * Table data which stores whether a user follow a title or not.
 *
 * @property mangaId [RibaManga.id] used as the primary key.
 *
 * @property followedUsers Array of [RibaUser.id]s that follow this title.
 */
@Entity(tableName = "user_follows")
data class RibaUserFollow(
	@PrimaryKey val mangaId: String,
	@ColumnInfo val followedUsers: List<String>,
) {
	companion object {
		fun getDefault(): RibaUserFollow = RibaUserFollow(
			"00000000-0000-0000-0000-000000000000",
			listOf("00000000-0000-0000-0000-000000000000")
		)
	}
}