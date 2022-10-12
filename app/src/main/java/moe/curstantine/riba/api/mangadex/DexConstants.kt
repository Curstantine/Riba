package moe.curstantine.riba.api.mangadex

object DexConstants {
    const val BASE_SITE = "https://mangadex.org"
    const val BASE_API = "https://api.mangadex.org"
    const val STATUS_PAGE = "https://status.mangadex.org"

    /**
     * Covers should follow the `COVER_URL/manga-id/cover-filename
     *
     * For thumbnail sizes, `COVER_URL/manga-id/cover-filename.[DexCoverSize].jpg`
     */
    const val COVER_URL = "https://uploads.mangadex.org/covers/"
    const val SEASONAL_LIST = "4be9338a-3402-4f98-b467-43fb56663927"

    /**
     * 15 minutes in seconds
     */
    const val SESSION_EXPIRY = 900

    /**
     * 30 days in seconds
     */
    const val REFRESH_EXPIRY = 2592000
}

enum class DexCoverSize(val size: Int) {
    Small(256),
    Medium(512),
    Source(0)
}