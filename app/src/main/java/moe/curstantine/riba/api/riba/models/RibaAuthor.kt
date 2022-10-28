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
	companion object {
		fun getDefault() = RibaAuthor(
			"fc343004-569b-4750-aba0-05ab35efc17c",
			"Hologfx",
			mapOf(Pair(DexLocale.English, "Hologfx")),
			0
		)
	}
}