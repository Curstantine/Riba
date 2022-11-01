package moe.curstantine.riba.api.riba

import android.content.Context
import android.content.SharedPreferences
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.models.DexLocale

class RibaSettings(context: Context) {
	private val preferences: SharedPreferences = context.getSharedPreferences(
		RibaConstants.Preferences.SETTINGS,
		Context.MODE_PRIVATE
	)

	init {
		if (!preferences.getBoolean(RibaConstants.Preferences.FIRST_RUN, false)) {
			setLanguagePreference(listOf(DexLocale.English, DexLocale.JapaneseRomanized, DexLocale.Japanese))
		}
	}

	fun getLanguagePreference(): List<DexLocale> {
		return preferences.getString(RibaConstants.Preferences.LANGUAGE_ORDER, null)!!.let {
			MangaDexService.Serde.Adapters.localeListAdapter.fromJson(it)!!
		}
	}

	fun setLanguagePreference(languages: List<DexLocale>) {
		preferences.edit().putString(
			RibaConstants.Preferences.LANGUAGE_ORDER,
			MangaDexService.Serde.Adapters.localeListAdapter.toJson(languages)
		).apply()
	}

	companion object {
		@Composable
		fun createDummy() = RibaSettings(LocalContext.current)
	}
}