package moe.curstantine.mangodex.api.mangadex

object DexUtils {
    fun getCoverUrl(mangaId: String, fileName: String, size: CoverSize): String {
        return DexConstants.COVER_URL + "$mangaId/$fileName".let {
            if (size != CoverSize.Source) it + ".${size.size}.jpg" else it
        }
    }
}