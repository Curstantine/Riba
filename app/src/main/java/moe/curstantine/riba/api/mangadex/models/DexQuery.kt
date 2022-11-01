package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = false)
enum class DexQueryOrderValue {
	@field:Json(name = "asc")
	Ascending,

	@field:Json(name = "desc")
	Descending
}

/**
 * Query order properties for most endpoints.
 *
 * @see DexChapterQueryOrderProperty for chapter properties.
 */
@JsonClass(generateAdapter = false)
enum class DexQueryOrderProperty {
	@field:Json(name = "order[createdAt]")
	CreatedAt,

	@field:Json(name = "order[updatedAt]")
	UpdatedAt
}

/**
 * Query order properties used for chapter endpoints.
 */
@JsonClass(generateAdapter = false)
enum class DexChapterQueryOrderProperty {
	@field:Json(name = "order[chapter]")
	Chapter,

	@field:Json(name = "order[volume]")
	Volume,

	@field:Json(name = "order[chapterCreatedAt]")
	ChapterCreatedAt,

	@field:Json(name = "order[chapterUpdatedAt]")
	ChapterUpdatedAt,

	@field:Json(name = "order[chapterPublishedAt]")
	ChapterPublishedAt,
}