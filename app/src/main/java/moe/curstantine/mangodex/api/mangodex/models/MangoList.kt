package moe.curstantine.mangodex.api.mangodex.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.mangodex.api.mangadex.models.DexMDListVisibility

/**
 * Generalized MDList object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "lists")
data class MangoList(
    @PrimaryKey val id: String,
    @ColumnInfo val name: String,
    @ColumnInfo val visibility: DexMDListVisibility,
    @ColumnInfo val titles: List<String>,
)