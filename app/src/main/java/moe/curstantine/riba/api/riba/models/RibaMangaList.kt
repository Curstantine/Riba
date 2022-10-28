package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.riba.api.mangadex.models.DexListVisibility

/**
 * Generalized MDList object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "lists")
data class RibaMangaList(
	@PrimaryKey val id: String,
	@ColumnInfo val name: String,
	@ColumnInfo val visibility: DexListVisibility,
	@ColumnInfo val titles: List<String>,
	@ColumnInfo val userId: String,
	@ColumnInfo val version: Int,
)