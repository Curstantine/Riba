package moe.curstantine.riba.api.mangadex

import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.mangadex.models.DexLocaleObject

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

	/**
	 * Tries to find a localized value that matches a given locale.
	 *
	 * It'll respect the precedence of the [preferredLocales] list,
	 * and if none of the values match, it'll return the first non-null value.
	 *
	 * eg:
	 * 	1. When [preferredLocales] are `["en", "zh"]` and `localizedObject` is `{"en": "English", "zh": "Chinese"}`
	 * 	it'll return the value in `en` key.
	 * 	2. When [preferredLocales] are `["en", "zh"]` and `localizedObject` is `{"fr": "French"}`,
	 * 	it'll return the value in `fr` key.
	 *
	 * @throws NoSuchElementException if the [localizedObject] doesn't have non-null values.
	 */
	fun getPreferredLocalizedValue(preferredLocales: List<DexLocale>, localizedObject: DexLocaleObject): String {
		for (locale in preferredLocales) {
			if (localizedObject[locale] != null) return localizedObject[locale]!!
		}

		return localizedObject.firstNotNullOf { it.value }
	}

	fun getMangaUrl(mangaId: String): String {
		return DexConstants.BASE_SITE + "/title/" + mangaId
	}
}