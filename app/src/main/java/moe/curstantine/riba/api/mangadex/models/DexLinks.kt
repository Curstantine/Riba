package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

typealias DexLinks = Map<DexLink, String>

@Suppress("unused")
@JsonClass(generateAdapter = false)
enum class DexLink {
	@field:Json(name = "al")
	AniList,

	@field:Json(name = "ap")
	AnimePlanet,

	@field:Json(name = "bw")
	BookWalker,

	@field:Json(name = "mu")
	MangaUpdates,

	@field:Json(name = "nu")
	NovelUpdates,

	@field:Json(name = "kt")
	Kitsu,

	@field:Json(name = "amz")
	Amazon,

	@field:Json(name = "ebj")
	EBookJapan,

	@field:Json(name = "mal")
	MyAnimeList,

	@field:Json(name = "cdj")
	CdJapan,

	@field:Json(name = "raw")
	Raw,

	@field:Json(name = "engtl")
	EnglishTranslation,
}