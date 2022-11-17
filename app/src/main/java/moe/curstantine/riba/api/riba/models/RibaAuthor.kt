package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.mangadex.models.DexLocaleObject

/**
 * Generalized Author object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "authors")
data class RibaAuthor(
	@PrimaryKey val id: String,
	@ColumnInfo val name: String?,
	@ColumnInfo val description: DexLocaleObject?,
	@ColumnInfo val version: Int,
) {
	/**
	 * Compares the age with [version] on [other] and `this` object.
	 *
	 * If the [version] is the same or newer, it'll return `true`.
	 */
	fun isOlderThan(other: RibaAuthor): Boolean = other.version >= version

	companion object {
		fun getDefault() = RibaAuthor(
			"fc343004-569b-4750-aba0-05ab35efc17c",
			"Hologfx",
			mapOf(Pair(DexLocale.English, "Hologfx")),
			0
		)
	}
}