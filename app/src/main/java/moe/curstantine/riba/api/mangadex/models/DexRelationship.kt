package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.mangadex.DexUtils

/**
 * Basic relationship returned by MangaDex.
 *
 * Extend this interface based on the type of relationship related to the entity.
 *
 * Use [DexRelationshipImpl] for an implementation of this interface.
 *
 * @property id The ID of the related entity.
 * @property type The type of the related entity.
 */
interface DexRelationship {
    val id: String
    val type: DexEntityType
}

/**
 * Implementation of [DexRelationship].
 *
 * Used in relationships where the correct type is not known or not fetched.
 */
@JsonClass(generateAdapter = true)
data class DexRelationshipImpl(
    override val id: String,
    override val type: DexEntityType
) : DexRelationship

/**
 * Content rating of a [DexManga]
 */
@JsonClass(generateAdapter = false)
enum class DexContentRating {
    @field:Json(name = "safe")
    Safe,

    @field:Json(name = "suggestive")
    Suggestive,

    @field:Json(name = "erotica")
    Erotica,

    @field:Json(name = "pornographic")
    Pornographic;

    fun toTitleCase(): String = DexUtils.toTitleCase(name)
    override fun toString(): String = DexUtils.toNormalizedString(name)

    companion object {
        fun fromString(string: String): DexMangaTagGroup? {
            return DexMangaTagGroup.values().find { it.toString() == string }
        }
    }
}