package moe.curstantine.mangodex.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * Generalized Link object for a Manga that's used by the app,
 * external APIs should transform to this data class.
 *
 * @param al AniList id
 * @param mal MyAnimeList id
 * @param kt Kitsu id
 */
@Entity(tableName = "manga_links")
data class RibaMangaLink(
    @PrimaryKey val mangaId: String,
    @ColumnInfo val al: String?,
    @ColumnInfo val mal: String?,
    @ColumnInfo val kt: String?,
)