package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.mangadex.DexUtils
import moe.curstantine.riba.api.riba.models.RibaManga
import moe.curstantine.riba.api.riba.models.RibaStatistic

typealias DexManga = DexResponse<DexMangaAttributes>
typealias DexMangaCollection = DexCollectionResponse<DexMangaAttributes>

typealias DexMangaData = DexResponseData<DexMangaAttributes>

@JsonClass(generateAdapter = true)
data class DexMangaAttributes(
	val title: DexLocaleObject,
	val altTitles: List<DexLocaleObject>,
	val description: DexLocaleObject,
	val contentRating: DexContentRating,
	val tags: List<DexTagData>,
	val version: Int,
)

fun DexMangaData.toRibaManga(): RibaManga {
	var coverId: String? = null
	val artistIds = mutableListOf<String>()
	val authorIds = mutableListOf<String>()

	for (relationship in relationships) {
		when (relationship.type) {
			DexEntityType.Artist -> artistIds.add(relationship.id)
			DexEntityType.Author -> authorIds.add(relationship.id)
			DexEntityType.CoverArt -> coverId = relationship.id
			else -> continue
		}
	}

	return RibaManga(
		id = id,
		title = attributes.title,
		altTitles = attributes.altTitles,
		description = attributes.description,
		artistIds = artistIds,
		authorIds = authorIds,
		coverId = coverId,
		version = attributes.version,
		tagIds = attributes.tags.map { it.id },
		contentRating = attributes.contentRating,
	)
}

/**
 * A [DexRelationship] that contains a [DexManga]; used for both
 * sibling-sibling and parent-related relationships.
 *
 * e.g.:
 * - [DexAuthor]'s [DexRelationship] is [DexRelatedManga]
 * - [DexManga]'s [DexRelationship] is [DexRelatedManga] ([related] is non-null)
 *
 * @property related is only non-null when the relationship is sibling-sibling.
 */
@JsonClass(generateAdapter = true)
data class DexRelatedManga(
	override val id: String,
	override val type: DexEntityType,
	val related: DexMangaRelationType?,
) : DexRelationship

/**
 * Statistics object returned by both queries and single GETs.
 *
 * @property statistics contains a map with manga uuids as keys and [DexMangaStatistic] as values.
 */
@JsonClass(generateAdapter = true)
data class DexMangaStatistics(
	override val result: DexResult,
	val statistics: Map<String, DexMangaStatistic>
) : DexBaseResponse {
	fun toRibaStatisticCollection(): Map<String, RibaStatistic> {
		return this.statistics.mapValues { it.value.toRibaStatistic(it.key) }
	}
}

/**
 * Statistic object for a [DexManga].
 *
 * Usually wrapped within a map with the key being the id of the [DexManga].
 */
@JsonClass(generateAdapter = true)
data class DexMangaStatistic(
	val follows: Int,
	val rating: ShadowedDexStatisticsObject,
) {
	fun toRibaStatistic(id: String): RibaStatistic = RibaStatistic(
		id = id,
		follows = follows,
		bayesian = rating.bayesian,
	)
}

@JsonClass(generateAdapter = true)
data class ShadowedDexStatisticsObject(
	val bayesian: Float,
)

/**
 * The type of relationship between two [DexManga]s.
 */
@Suppress("unused")
@JsonClass(generateAdapter = false)
enum class DexMangaRelationType {
	@field:Json(name = "monochrome")
	Monochrome,

	@field:Json(name = "colored")
	Colored,

	@field:Json(name = "preserialization")
	Preserialization,

	@field:Json(name = "serialization")
	Serialization,

	@field:Json(name = "prequel")
	Prequel,

	@field:Json(name = "sequel")
	Sequel,

	@field:Json(name = "main_story")
	MainStory,

	@field:Json(name = "side_story")
	SideStory,

	@field:Json(name = "adapted_from")
	AdaptedFrom,

	@field:Json(name = "spin_off")
	SpinOff,

	@field:Json(name = "based_on")
	BasedOn,

	@field:Json(name = "doujinshi")
	Doujinshi,

	@field:Json(name = "same_franchise")
	SameFranchise,

	@field:Json(name = "shared_universe")
	SharedUniverse,

	@field:Json(name = "alternate_story")
	AlternateStory,

	@field:Json(name = "alternate_version")
	AlternateVersion;

	override fun toString(): String = DexUtils.toNormalizedString(name)
	fun toTitleCase(): String = DexUtils.toTitleCase(name)
}

/**
 * Group types for tags in a Manga.
 */
@Suppress("unused")
@JsonClass(generateAdapter = false)
enum class DexMangaTagGroup {
	@field:Json(name = "content")
	Content,

	@field:Json(name = "genre")
	Genre,

	@field:Json(name = "theme")
	Theme,

	@field:Json(name = "format")
	Format;

	override fun toString(): String = DexUtils.toTitleCase(name)
}