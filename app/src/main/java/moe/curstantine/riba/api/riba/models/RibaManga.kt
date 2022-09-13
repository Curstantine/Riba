package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * Generalized Manga object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "manga")
data class RibaManga(
    @PrimaryKey val id: String,
    @ColumnInfo val title: String,
    @ColumnInfo val altTitles: List<String>?,
    @ColumnInfo val description: String?,
    @ColumnInfo val artistIds: List<String>,
    @ColumnInfo val authorIds: List<String>,
    @ColumnInfo val coverId: String?
)