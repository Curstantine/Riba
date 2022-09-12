package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.mangodex.api.mangodex.models.MangoManga

typealias DexManga = DexResponse<DexMangaAttributes>
typealias DexMangaCollection = DexCollectionResponse<DexMangaAttributes>

typealias DexMangaData = DexResponseData<DexMangaAttributes>

@JsonClass(generateAdapter = true)
data class DexMangaAttributes(
    val title: DexLocaleObject,
    val altTitles: List<DexLocaleObject>,
    val description: DexLocaleObject,
)

@JsonClass(generateAdapter = true)
data class DexRelatedManga(
    override val id: String,
    override val type: DexEntityType,
    val related: String?,
) : DexRelationship

fun DexMangaData.toMangoManga(): MangoManga {
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

    return MangoManga(
        id = id,
        title = attributes.title.english!!,
        altTitles = altTitles,
        description = description,
        artistIds = artistIds,
        authorIds = authorIds,
        coverId = coverId,
    )
}