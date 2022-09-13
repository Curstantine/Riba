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
    @ColumnInfo val fileName: String?,
)