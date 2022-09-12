package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.mangodex.api.mangodex.models.MangoCover

typealias DexCover = DexResponse<DexCoverAttributes>
typealias DexCoverCollection = DexCollectionResponse<DexCoverAttributes>

typealias DexCoverData = DexResponseData<DexCoverAttributes>

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
) : DexRelationship {
    fun toMangoCover(): MangoCover = MangoCover(
        id = id,
        fileName = attributes?.fileName,
    )
}

fun DexCoverData.toMangoCover(): MangoCover = MangoCover(
    id = id,
    fileName = attributes.fileName
)


