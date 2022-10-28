package moe.curstantine.riba.api.mangadex

object DexUtils {
	fun toNormalizedString(value: String): String =
		value.replace(Regex("([A-Z])")) { "_${it.value.lowercase()}" }.substring(1)

	fun toTitleCase(value: String): String =
		value.replace(Regex("([A-Z])")) { " ${it.value}" }.substring(1)

	fun getCoverUrl(mangaId: String, fileName: String, size: DexCoverSize): String {
		return DexConstants.COVER_URL + "$mangaId/$fileName".let {
			if (size != DexCoverSize.Source) it + ".${size.size}.jpg" else it
		}
	}

	fun getMangaUrl(mangaId: String): String {
		return DexConstants.BASE_SITE + "/title/" + mangaId
	}
}