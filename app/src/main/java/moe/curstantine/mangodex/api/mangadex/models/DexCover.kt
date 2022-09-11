package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.JsonClass

typealias DexCover = DexResponse<DexCoverAttributes>
typealias DexCoverCollection = DexCollectionResponse<DexCoverAttributes>

@JsonClass(generateAdapter = true)
data class DexCoverAttributes(
    val fileName: String,
    val volume: String?,
)

@JsonClass(generateAdapter = true)
data class DexRelatedCover(
    override val id: String,
    override val type: DexEntityType,
    val attributes: DexCoverAttributes?,
) : DexRelationship