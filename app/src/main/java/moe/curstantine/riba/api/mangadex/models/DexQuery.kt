package moe.curstantine.riba.api.mangadex.models

import moe.curstantine.riba.api.adapters.retrofit.EnumValue

enum class DexQueryOrderValue {
	@EnumValue("asc")
	Ascending,

	@EnumValue("desc")
	Descending
}

/**
 * Query order properties for most endpoints.
 *
 * @see DexChapterQueryOrderProperty for chapter properties.
 */
enum class DexQueryOrderProperty(val propStr: String) {
	CreatedAt("order[createdAt]"),
	UpdatedAt("order[updatedAt]"),
}

/**
 * Query order properties used for chapter endpoints.
 */
enum class DexChapterQueryOrderProperty(val propStr: String) {
	Chapter("order[chapter]"),
	Volume("order[volume]"),
	ChapterCreatedAt("order[chapterCreatedAt]"),
	ChapterUpdatedAt("order[chapterUpdatedAt]"),
	ChapterPublishedAt("order[chapterPublishedAt]"),
}