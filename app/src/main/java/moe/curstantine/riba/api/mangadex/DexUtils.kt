package moe.curstantine.riba.api.mangadex

object DexUtils {
    fun getCoverUrl(mangaId: String, fileName: String, size: DexCoverSize): String {
        return DexConstants.COVER_URL + "$mangaId/$fileName".let {
            if (size != DexCoverSize.Source) it + ".${size.size}.jpg" else it
        }
    }
}