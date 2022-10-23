package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.mangadex.models.DexLocaleObject
import moe.curstantine.riba.api.mangadex.models.DexMangaTagGroup

/**
 * Generalized Tag object that's used by the app, all external APIs should dissolve to this.
 */
@Entity(tableName = "tags")
data class RibaTag(
    @PrimaryKey val id: String,
    @ColumnInfo val name: DexLocaleObject?,
    @ColumnInfo val group: DexMangaTagGroup,
    @ColumnInfo val version: Int,
) {
    companion object {
        fun getDefault() = RibaTag(
            id = "423e2eae-a7a2-4a8b-ac03-a8351462d71d",
            name = mapOf(Pair(DexLocale.English, "Romance")),
            group = DexMangaTagGroup.Genre,
            version = 0,
        )
    }
}