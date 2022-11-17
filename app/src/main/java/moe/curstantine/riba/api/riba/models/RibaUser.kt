package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.riba.api.mangadex.models.DexUserRole

@Entity(tableName = "users")
data class RibaUser(
	@PrimaryKey val id: String,
	@ColumnInfo val username: String,
	@ColumnInfo val avatar: String?,
	@ColumnInfo val roles: List<DexUserRole>,
	@ColumnInfo val version: Int,
) {
	/**
	 * Compares the age with [version] on [other] and `this` object.
	 *
	 * If the [version] is the same or newer, it'll return `true`.
	 */
	fun isOlderThan(other: RibaUser): Boolean = other.version >= version

	companion object {
		fun getDefault() = RibaUser(
			id = "c36ab005-6329-4fe1-8517-099d7e134515",
			username = "Curstantine",
			avatar = null,
			roles = listOf(
				DexUserRole.Member,
				DexUserRole.MdAtHome,
				DexUserRole.GlobalModerator,
				DexUserRole.Administrator
			),
			version = 0,
		)
	}
}
