package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * Generalized Cover object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "covers")
data class RibaCover(
	@PrimaryKey val id: String,
	@ColumnInfo val mangaId: String,
	@ColumnInfo val volume: String?,
	@ColumnInfo val fileName: String?,
	@ColumnInfo val version: Int,
) {
	companion object {
		fun getDefault() = RibaCover(
			id = "d3b3a942-6cf4-4fa4-a9f4-627d8b361f8f",
			mangaId = "9c33607-9180-4ba6-b85c-e4b5faee7192",
			volume = null,
			fileName = null,
			version = 0
		)
	}
}