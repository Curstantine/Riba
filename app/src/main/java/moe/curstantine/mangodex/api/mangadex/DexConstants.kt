package moe.curstantine.mangodex.api.mangadex

object DexConstants {
    const val BASE_SITE = "https://mangadex.org"
    const val BASE_API = "https://api.mangadex.org"
    const val STATUS_PAGE = "https://status.mangadex.org"

    /**
     * Covers should follow the `COVER_URL/manga-id/cover-filename
     *
     * For thumbnail sizes, `COVER_URL/manga-id/cover-filename.[CoverSize].jpg`
     */
    const val COVER_URL = "https://uploads.mangadex.org/covers/"

    const val SEASONAL_LIST = "7df1dabc-b1c5-4e8e-a757-de5a2a3d37e9"
}

enum class CoverSize(val size: Int) {
    Small(256),
    Medium(512),
    Source(0)
}