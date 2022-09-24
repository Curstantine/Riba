package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.riba.models.RibaManga

typealias DexManga = DexResponse<DexMangaAttributes>
typealias DexMangaCollection = DexCollectionResponse<DexMangaAttributes>

typealias DexMangaData = DexResponseData<DexMangaAttributes>

@JsonClass(generateAdapter = true)
data class DexMangaAttributes(
    val title: DexLocaleObject,
    val altTitles: List<DexLocaleObject>,
    val description: DexLocaleObject,
    val version: Int,
)

@JsonClass(generateAdapter = true)
data class DexRelatedManga(
    override val id: String,
    override val type: DexEntityType,
    val related: String?,
) : DexRelationship

fun DexMangaData.toMangoManga(): RibaManga {
    val altTitles = attributes.altTitles
        .filter { it.english != null || it.japanese != null || it.japaneseRomanized != null }
        .mapNotNull { it.english ?: it.japanese ?: it.japaneseRomanized }

    val description = attributes.description.let {
        it.english ?: it.japanese ?: it.japaneseRomanized
    }

    var coverId: String? = null
    val artistIds = mutableListOf<String>()
    val authorIds = mutableListOf<String>()

    for (relationship in relationships) {
        when (relationship.type) {
            DexEntityType.Artist -> artistIds.add(relationship.id)
            DexEntityType.Author -> authorIds.add(relationship.id)
            DexEntityType.CoverArt -> coverId = relationship.id
            else -> {}
        }
    }

    // TODO: Handle nullable title
    return RibaManga(
        id = id,
        title = attributes.title.english ?: attributes.title.japanese ?: attributes.title.japaneseRomanized ?: "N/A",
        altTitles = altTitles,
        description = description,
        artistIds = artistIds,
        authorIds = authorIds,
        coverId = coverId,
        version = attributes.version
    )
}