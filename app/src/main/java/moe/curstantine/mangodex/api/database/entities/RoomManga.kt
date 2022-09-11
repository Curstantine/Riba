package moe.curstantine.mangodex.api.database.entities

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.mangodex.api.mangadex.models.DexEntityType
import moe.curstantine.mangodex.api.mangadex.models.DexMangaData

@Entity(tableName = "manga")
data class RoomManga(
    @PrimaryKey val id: String,
    @ColumnInfo val title: String,
    @ColumnInfo val altTitle: String?,
    @ColumnInfo val description: String?,
    @ColumnInfo val artistIds: List<String>,
    @ColumnInfo val authorIds: List<String>,
    @ColumnInfo val coverId: String?
)

fun RoomManga.fromDexManga(manga: DexMangaData) = RoomManga(
    id = manga.id,
    title = manga.attributes.title.english!!,
    altTitle = manga.attributes.altTitles.first { it.english != null }.english,
    description = manga.attributes.description.english,
    artistIds = manga.relationships.filter { it.type == DexEntityType.Artist }.map { it.id },
    authorIds = manga.relationships.filter { it.type == DexEntityType.Author }.map { it.id },
    coverId = manga.relationships.first { it.type == DexEntityType.CoverArt }.id
)