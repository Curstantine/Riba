package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.JsonClass

typealias DexAuthorArtist = DexResponse<DexAuthorArtistAttributes>
typealias DexAuthorArtistCollection = DexCollectionResponse<DexAuthorArtistAttributes>

typealias DexAuthorArtistData = DexResponseData<DexAuthorArtistAttributes>

/**
 * Common data class for both [DexEntityType.Author] and [DexEntityType.Artist]
 */
@JsonClass(generateAdapter = true)
data class DexAuthorArtistAttributes(
    val name: String,
    val biography: DexLocaleObject,
)

@JsonClass(generateAdapter = true)
data class DexRelatedAuthorArtist(
    override val id: String,
    override val type: DexEntityType,
    val attributes: DexAuthorArtistAttributes?
) : DexRelationship