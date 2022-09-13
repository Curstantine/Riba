package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.mangodex.api.riba.models.RibaAuthor

typealias DexAuthor = DexResponse<DexAuthorAttributes>
typealias DexAuthorCollection = DexCollectionResponse<DexAuthorAttributes>

typealias DexAuthorData = DexResponseData<DexAuthorAttributes>

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
    fun toMangoAuthor(): RibaAuthor = RibaAuthor(
        id = id,
        name = attributes?.name,
        description = attributes?.biography?.english,
    )
}

fun DexAuthorData.toMangoAuthor(): RibaAuthor = RibaAuthor(
    id = id,
    name = attributes.name,
    description = attributes.biography.english,
)

