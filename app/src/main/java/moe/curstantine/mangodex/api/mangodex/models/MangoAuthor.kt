package moe.curstantine.mangodex.api.mangodex.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * Generalized Author object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "authors")
data class MangoAuthor(
    @PrimaryKey val id: String,
    @ColumnInfo val name: String?,
    @ColumnInfo val description: String?
)