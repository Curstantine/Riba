package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.riba.models.RibaCover

typealias DexCover = DexResponse<DexCoverAttributes>
typealias DexCoverCollection = DexCollectionResponse<DexCoverAttributes>

typealias DexCoverData = DexResponseData<DexCoverAttributes>

@JsonClass(generateAdapter = true)
data class DexCoverAttributes(
	val fileName: String,
	val volume: String?,
	val version: Int,
)

fun DexCoverData.toRibaCover(): RibaCover = RibaCover(
	id = id,
	mangaId = relationships.first { it.type == DexEntityType.Manga }.id,
	volume = attributes.volume,
	fileName = attributes.fileName,
	version = attributes.version,
)

/**
 * [DexRelationship] that contains a [DexCover]
 */
@JsonClass(generateAdapter = true)
data class DexRelatedCover(
	override val id: String,
	override val type: DexEntityType,
	val attributes: DexCoverAttributes?,
) : DexRelationship {
	fun toRibaCover(mangaId: String): RibaCover = RibaCover(
		id = id,
		mangaId = mangaId,
		volume = attributes?.volume,
		fileName = attributes?.fileName,
		version = attributes?.version ?: -1,
	)
}

