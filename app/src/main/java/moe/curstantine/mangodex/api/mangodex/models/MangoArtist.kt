package moe.curstantine.mangodex.api.mangodex.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * Generalized Artist object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "artists")
data class MangoArtist(
    @PrimaryKey val id: String,
    @ColumnInfo val name: String?,
    @ColumnInfo val description: String?
)