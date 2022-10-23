package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.riba.models.RibaGroup
import java.time.LocalDateTime

typealias DexGroup = DexResponse<DexGroupAttributes>
typealias DexGroupCollection = DexCollectionResponse<DexGroupAttributes>

typealias DexGroupData = DexResponseData<DexGroupAttributes>

@JsonClass(generateAdapter = true)
data class DexGroupAttributes(
    val name: String,
    val description: String?,
    val discord: String?,
    val twitter: String?,
    val website: String?,
    val official: Boolean,
    val createdAt: LocalDateTime,
    val focusedLanguages: List<DexLocale>,
    val version: Int,
)

@JsonClass(generateAdapter = true)
data class DexRelatedGroup(
    override val id: String,
    override val type: DexEntityType,
    val attributes: DexGroupAttributes?,
) : DexRelationship {
    /**
     * @throws IllegalStateException if [attributes] is null.
     */
    fun toRibaGroup(): RibaGroup {
        if (attributes == null) {
            throw IllegalStateException("Attributes cannot be null trying to convert to a ${RibaGroup::class.simpleName}")
        }

        return RibaGroup(
            id = id,
            name = attributes.name,
            description = attributes.description,
            discord = attributes.discord,
            twitter = attributes.twitter,
            website = attributes.website,
            official = attributes.official,
            createdAt = attributes.createdAt,
            focusedLanguages = attributes.focusedLanguages,
            version = attributes.version,
            leader = null,
            members = null,
        )
    }
}

/**
 * @throws [NoSuchElementException] if the [RibaGroup.leader] is missing.
 */
fun DexGroupData.toRibaGroup(): RibaGroup {
    val members = relationships
        .filter { it.type == DexEntityType.Member }
        .map { it.id }

    val leader = relationships
        .first { it.type == DexEntityType.Leader }
        .id

    return RibaGroup(
        id = id,
        name = attributes.name,
        description = attributes.description,
        discord = attributes.discord,
        twitter = attributes.twitter,
        website = attributes.website,
        official = attributes.official,
        createdAt = attributes.createdAt,
        focusedLanguages = attributes.focusedLanguages,
        version = attributes.version,
        leader = leader,
        members = members,
    )
}
