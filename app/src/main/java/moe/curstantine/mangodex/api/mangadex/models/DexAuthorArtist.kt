package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.mangodex.api.mangodex.models.MangoAuthor

typealias DexAuthorArtist = DexResponse<DexAuthorAttributes>
typealias DexAuthorArtistCollection = DexCollectionResponse<DexAuthorAttributes>

typealias DexAuthorArtistData = DexResponseData<DexAuthorAttributes>

/**
 * Common data class for both [DexEntityType.Author] and [DexEntityType.Artist].
 *
 * [DexEntityType.Artist] is [DexEntityType.Author] with a different `type` field,
 * MangaDex doesn't have a different object for it. [DexEntityType.Artist] can only
 * appear in [DexRelationship]s.
 */
@JsonClass(generateAdapter = true)
data class DexAuthorAttributes(
    val name: String,
    val biography: DexLocaleObject,
)

@JsonClass(generateAdapter = true)
data class DexRelatedAuthor(
    override val id: String,
    override val type: DexEntityType,
    val attributes: DexAuthorAttributes?
) : DexRelationship {
    fun toMangoAuthor(): MangoAuthor = MangoAuthor(
        id = id,
        name = attributes?.name,
        description = attributes?.biography?.english,
    )
}

fun DexAuthorArtistData.toMangoAuthor(): MangoAuthor = MangoAuthor(
    id = id,
    name = attributes.name,
    description = attributes.biography.english,
)

