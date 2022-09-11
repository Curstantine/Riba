package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.JsonClass

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