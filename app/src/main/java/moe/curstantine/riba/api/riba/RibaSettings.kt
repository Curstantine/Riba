package moe.curstantine.riba.api.riba

import android.content.Context
import android.content.SharedPreferences
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import moe.curstantine.riba.api.mangadex.DexUtils
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.models.DexLocale

class RibaSettings(context: Context) {
	private val preferences: SharedPreferences = context
		.getSharedPreferences(RibaConstants.Preferences.SETTINGS, Context.MODE_PRIVATE)

	init {
		if (!preferences.getBoolean(RibaConstants.Preferences.FIRST_RUN, false)) reset().run {
			preferences.edit().putBoolean(RibaConstants.Preferences.FIRST_RUN, true).apply()
		}
	}

	/**
	 * Resets all settings to default values.
	 */
	fun reset() {
		setChapterLanguages(Defaults.CHAPTER_LANGUAGES)
		setLanguagePreference(Defaults.LANGUAGE_PREFERENCES)
		setOriginalLanguages(Defaults.ORIGINAL_LANGUAGES)
		setDataSaverEnabled(Defaults.DATA_SAVER)
		setPort443Enabled(Defaults.PORT_443)
	}

	/**
	 * Returns the language preference order.
	 *
	 * Used for finding the best locale match for localized values.
	 *
	 * @see [DexUtils.getPreferredLocalizedValue]
	 */
	fun getLanguagePreference(): List<DexLocale> {
		return preferences.getString(RibaConstants.Preferences.LANGUAGE_ORDER, null)!!.let {
			MangaDexService.Serde.localeListAdapter.fromJson(it)!!
		}
	}

	fun setLanguagePreference(languages: List<DexLocale>) {
		preferences.edit().putString(
			RibaConstants.Preferences.LANGUAGE_ORDER,
			MangaDexService.Serde.localeListAdapter.toJson(languages)
		).apply()
	}

	/**
	 * Chapter language preference.
	 */
	fun getChapterLanguages(): List<DexLocale> {
		return preferences.getString(RibaConstants.Preferences.CHAPTER_LANGUAGES, null)!!.let {
			MangaDexService.Serde.localeListAdapter.fromJson(it)!!
		}
	}

	fun setChapterLanguages(languages: List<DexLocale>) {
		preferences.edit().putString(
			RibaConstants.Preferences.CHAPTER_LANGUAGES,
			MangaDexService.Serde.localeListAdapter.toJson(languages)
		).apply()
	}

	/**
	 * Original language preference.
	 *
	 * The language of the originally published title.
	 */
	fun getOriginalLanguages(): List<DexLocale> {
		return preferences.getString(RibaConstants.Preferences.ORIGINAL_LANGUAGES, null)!!.let {
			MangaDexService.Serde.localeListAdapter.fromJson(it)!!
		}
	}

	fun setOriginalLanguages(language: List<DexLocale>) {
		preferences.edit().putString(
			RibaConstants.Preferences.ORIGINAL_LANGUAGES,
			MangaDexService.Serde.localeListAdapter.toJson(language)
		).apply()
	}

	/**
	 * Whether to use the data saver mode.
	 */
	fun isDataSaverEnabled(): Boolean {
		return preferences.getBoolean(RibaConstants.Preferences.DATA_SAVER, false)
	}

	fun setDataSaverEnabled(enabled: Boolean) {
		preferences.edit().putBoolean(RibaConstants.Preferences.DATA_SAVER, enabled).apply()
	}

	/**
	 * Whether to use port 443 for MangaDex@Home.
	 */
	fun isPort443Enabled(): Boolean {
		return preferences.getBoolean(RibaConstants.Preferences.PORT_443, false)
	}

	fun setPort443Enabled(enabled: Boolean) {
		preferences.edit().putBoolean(RibaConstants.Preferences.PORT_443, enabled).apply()
	}

	companion object {
		@Composable
		fun createDummy() = RibaSettings(LocalContext.current)

		object Defaults {
			val CHAPTER_LANGUAGES = listOf(DexLocale.English)

			val LANGUAGE_PREFERENCES = listOf(
				DexLocale.English,
				DexLocale.JapaneseRomanized,
				DexLocale.Japanese,
				DexLocale.KoreanRomanized,
				DexLocale.Korean,
				DexLocale.ChineseRomanized,
				DexLocale.SimplifiedChinese,
				DexLocale.TraditionalChinese,
			)

			val ORIGINAL_LANGUAGES = listOf(
				DexLocale.Japanese,
				DexLocale.SimplifiedChinese,
				DexLocale.TraditionalChinese,
				DexLocale.Korean
			)

			const val DATA_SAVER = false
			const val PORT_443 = false
		}
	}
}