package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.riba.api.mangadex.models.DexLocale
import java.time.LocalDateTime

@Entity(tableName = "groups")
data class RibaGroup(
	@PrimaryKey val id: String,
	@ColumnInfo val name: String,
	@ColumnInfo val description: String?,
	@ColumnInfo val discord: String?,
	@ColumnInfo val twitter: String?,
	@ColumnInfo val website: String?,
	@ColumnInfo val official: Boolean,
	@ColumnInfo val focusedLanguages: List<DexLocale>,
	@ColumnInfo val createdAt: LocalDateTime,
	@ColumnInfo val version: Int,


	/**
	 * UUID of the leader of the group.
	 */
	@ColumnInfo val leader: String?,

	/**
	 * UUIDs of the users that are part of this group.
	 */
	@ColumnInfo val members: List<String>?,
) {
	/**
	 * Compares the age with [version] on [other] and `this` object.
	 *
	 * If the [version] is the same or newer, it'll return `true`.
	 */
	fun isOlderThan(other: RibaGroup): Boolean = other.version >= version

	companion object {
		fun getDefault() = RibaGroup(
			id = "a408e049-2d88-429f-8c03-f0cc8ab2325c",
			name = "Baumkuchen Scans",
			description = "Looking for JP translators  \nContact Tracreed#0975 for more information.",
			discord = null,
			twitter = null,
			website = null,
			official = false,
			focusedLanguages = listOf(DexLocale.English),
			createdAt = LocalDateTime.now(),
			version = 0,
			leader = "29290c4d-440c-41fc-8c62-7b96c691df8c",
			members = listOf(
				"29290c4d-440c-41fc-8c62-7b96c691df8c",
				"c36ab005-6329-4fe1-8517-099d7e134515"
			),
		)
	}
}
