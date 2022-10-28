package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass

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
