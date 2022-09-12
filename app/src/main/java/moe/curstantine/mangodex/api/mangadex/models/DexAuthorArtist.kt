package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.mangodex.api.mangodex.models.MangoArtist
import moe.curstantine.mangodex.api.mangodex.models.MangoAuthor

typealias DexAuthorArtist = DexResponse<DexAuthorArtistAttributes>
typealias DexAuthorArtistCollection = DexCollectionResponse<DexAuthorArtistAttributes>

typealias DexAuthorArtistData = DexResponseData<DexAuthorArtistAttributes>

/**
 * Common data class for both [DexEntityType.Author] and [DexEntityType.Artist].
 *
 * [DexEntityType.Artist] is [DexEntityType.Author] with a different `type` field,
 * MangaDex doesn't have a different object for it. [DexEntityType.Artist] can only
 * appear in [DexRelationship]s.
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
) : DexRelationship {
    fun toMangoArtist(): MangoArtist = MangoArtist(
        id = id,
        name = attributes?.name,
        description = attributes?.biography?.english,
    )

    fun toMangoAuthor(): MangoAuthor = MangoAuthor(
        id = id,
        name = attributes?.name,
        description = attributes?.biography?.english,
    )
}

fun DexAuthorArtistData.toMangoArtist(): MangoArtist = MangoArtist(
    id = id,
    name = attributes.name,
    description = attributes.biography.english,
)

fun DexAuthorArtistData.toMangoAuthor(): MangoAuthor = MangoAuthor(
    id = id,
    name = attributes.name,
    description = attributes.biography.english,
)

