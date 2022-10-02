package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.riba.api.mangadex.models.DexMangaTagGroup

@Entity(tableName = "tags")
data class RibaTag(
    @PrimaryKey val id: String,
    @ColumnInfo val name: String?,
    @ColumnInfo val group: DexMangaTagGroup,
    @ColumnInfo val version: Int,
    ) {
    companion object {
        fun getDefault() = RibaTag(
            id = "0",
            name = "Misc",
            group = DexMangaTagGroup.Format,
            version = 0,
        )
    }
}