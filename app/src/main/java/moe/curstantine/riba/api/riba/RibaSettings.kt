package moe.curstantine.riba.api.riba

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.DexUtils
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.models.DexLocale

class RibaSettings(context: Context) {
	private val preferences: SharedPreferences = context.getSharedPreferences(
		RibaConstants.Preferences.SETTINGS,
		Context.MODE_PRIVATE
	)

	init {
		if (!preferences.getBoolean(RibaConstants.Preferences.FIRST_RUN, false)) {
			try {
				reset()
				preferences.edit().putBoolean(RibaConstants.Preferences.FIRST_RUN, true).apply()
			} catch (e: Throwable) {
				Log.e(DexLogTag.DEBUG.tag, "pepega'd @$e")
			}
		}
	}

	/**
	 * Resets all settings to default values.
	 */
	fun reset() {
		setChapterLanguages(listOf(DexLocale.English))
		setLanguagePreference(
			listOf(
				DexLocale.English,
				DexLocale.JapaneseRomanized,
				DexLocale.Japanese,
				DexLocale.KoreanRomanized,
				DexLocale.Korean,
				DexLocale.ChineseRomanized,
				DexLocale.SimplifiedChinese,
				DexLocale.TraditionalChinese,
			)
		)
		setOriginalLanguage(
			listOf(
				DexLocale.Japanese,
				DexLocale.SimplifiedChinese,
				DexLocale.TraditionalChinese,
				DexLocale.Korean
			)
		)
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
	fun getOriginalLanguage(): List<DexLocale> {
		return preferences.getString(RibaConstants.Preferences.LANGUAGE_ORIGINAL, null)!!.let {
			MangaDexService.Serde.localeListAdapter.fromJson(it)!!
		}
	}

	fun setOriginalLanguage(language: List<DexLocale>) {
		preferences.edit().putString(
			RibaConstants.Preferences.LANGUAGE_ORIGINAL,
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
	}
}