package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json

typealias DexLinks = Map<DexLink, String>

enum class DexLink {
    @Json(name = "al")
    AniList,

    @Json(name = "ap")
    AnimePlanet,

    @Json(name = "bw")
    BookWalker,

    @Json(name = "mu")
    MangaUpdates,

    @Json(name = "nu")
    NovelUpdates,

    @Json(name = "kt")
    Kitsu,

    @Json(name = "amz")
    Amazon,

    @Json(name = "ebj")
    EBookJapan,

    @Json(name = "mal")
    MyAnimeList,

    @Json(name = "cdj")
    CdJapan,

    @Json(name = "raw")
    Raw,

    @Json(name = "engtl")
    EnglishTranslation,
}