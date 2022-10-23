package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.riba.models.RibaAuthor

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
    val version: Int,
)

@JsonClass(generateAdapter = true)
data class DexRelatedAuthor(
    override val id: String,
    override val type: DexEntityType,
    val attributes: DexAuthorAttributes?
) : DexRelationship {
    fun toRibaAuthor(): RibaAuthor = RibaAuthor(
        id = id,
        name = attributes?.name,
        description = attributes?.biography,
        version = attributes?.version ?: -1,
    )
}

fun DexAuthorData.toRibaAuthor(): RibaAuthor = RibaAuthor(
    id = id,
    name = attributes.name,
    description = attributes.biography,
    version = attributes.version,
)

