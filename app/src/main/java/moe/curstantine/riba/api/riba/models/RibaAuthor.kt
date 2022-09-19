package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * Generalized Author object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "authors")
data class RibaAuthor(
    @PrimaryKey val id: String,
    @ColumnInfo val name: String?,
    @ColumnInfo val description: String?
) {
    companion object {
        fun getDefault() = RibaAuthor(
            "fc343004-569b-4750-aba0-05ab35efc17c",
            "Hologfx",
            "Holo"
        )
    }
}