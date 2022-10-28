package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.riba.models.RibaChapter
import java.time.LocalDateTime

typealias DexChapter = DexResponse<DexChapterAttributes>
typealias DexChapterCollection = DexCollectionResponse<DexChapterAttributes>

typealias DexChapterData = DexResponseData<DexChapterAttributes>

/**
 * NOTE: DO NOT use dates to validate whether a chapter is available or not, cunts like
 * Bilibili love to fuck it up to redirect Dex users to their site.
 */
@JsonClass(generateAdapter = true)
data class DexChapterAttributes(
	val volume: String?,
	val chapter: String?,
	val title: String?,
	val translatedLanguage: DexLocale,
	val externalUrl: String?,

	/**
	 * The date this chapter will be published on MangaDex.
	 *
	 * This can be used to find when the chapter will be available on MangaDex when
	 * the content is restricted to the uploader site.
	 * e.g. Bilibili chapters that are locked for 2 weeks, or so.
	 */
	val publishAt: LocalDateTime,

	/**
	 * The timestamp this chapter will be readable even out of MangaDex.
	 *
	 * Useful for finding chapters that are locked till a certain date.
	 *
	 * - If [publishAt] is in future and has [externalUrl], then [readableAt] is equal to the [createdAt] date
	 * - Otherwise readableAt is equals publishAt date
	 */
	val readableAt: LocalDateTime,

	/**
	 * The timestamp this chapter was created.
	 */
	val createdAt: LocalDateTime,

	/**
	 * Last updated timestamp of this chapter.
	 */
	val updatedAt: LocalDateTime,
	val version: Int,
)

fun DexChapterData.toRibaChapter(): RibaChapter {
	lateinit var manga: String
	lateinit var uploader: String
	val scanlationGroups = mutableListOf<String>()

	for (relationship in relationships) {
		when (relationship.type) {
			DexEntityType.Manga -> manga = relationship.id
			DexEntityType.User -> uploader = relationship.id
			DexEntityType.ScanlationGroup -> scanlationGroups.add(relationship.id)
			else -> continue
		}
	}

	return RibaChapter(
		id = id,
		manga = manga,
		uploader = uploader,
		groups = scanlationGroups,
		volume = attributes.volume,
		chapter = attributes.chapter,
		title = attributes.title,
		language = attributes.translatedLanguage,
		externalUrl = attributes.externalUrl,
		publishAt = attributes.publishAt,
		readableAt = attributes.readableAt,
		createdAt = attributes.createdAt,
		updatedAt = attributes.updatedAt,
		version = attributes.version
	)
}


/**
 * Response returned by MangaDex when at-home chapter endpoint is called.
 *
 * To get a page, format a link with:
 * - [baseUrl]
 * - Page quality: [DexAtHomeShadowedChapter.data] or [DexAtHomeShadowedChapter.dataSaver]
 * - [chapter]'s [DexAtHomeShadowedChapter.hash]
 * - Page name that's from [DexAtHomeShadowedChapter.data] or [DexAtHomeShadowedChapter.dataSaver]
 *
 * Which will make it into:
 * ```
 * baseUrl/(data|dataSaver)/hash/(data[x]|dataSaver[x])
 * ```
 */
@JsonClass(generateAdapter = true)
data class DexChapterAtHome(
	override val result: DexResult,
	/**
	 * URL to be used with [DexAtHomeShadowedChapter] to get the page.
	 */
	val baseUrl: String,
	val chapter: DexAtHomeShadowedChapter
) : DexBaseResponse

/**
 * Typically wrapped within [DexChapterAtHome].
 */
@JsonClass(generateAdapter = true)
data class DexAtHomeShadowedChapter(
	val hash: String,
	val data: List<String>,
	val dataSaver: List<String>,
)

/**
 * POST request body for reporting an At-Home chapter.
 *
 * Reports are done to https://api.mangadex.network/report
 */
@JsonClass(generateAdapter = true)
data class DexAtHomeChapterReportBody(
	/**
	 * Full URL of the page.
	 */
	val url: String,
	val success: Boolean,
	val cached: Boolean,

	/**
	 * The size (in bytes) of the retrieved image
	 */
	val bytes: Int,

	/**
	 * The time (in miliseconds) that the complete retrieval (not TTFB) of the image took
	 */
	val duration: Int,
)