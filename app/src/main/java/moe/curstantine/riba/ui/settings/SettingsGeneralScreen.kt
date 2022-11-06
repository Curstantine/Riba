package moe.curstantine.riba.ui.settings

import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.scrollable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.api.riba.RibaSettings
import moe.curstantine.riba.ui.common.dialogs.LocaleSelectionDialog
import moe.curstantine.riba.ui.common.dialogs.SortableItemDialog
import moe.curstantine.riba.ui.theme.RibaTheme
import moe.curstantine.riba.ui.theme.Rubik

@Composable
fun SettingsGeneralScreen(state: RibaHostState) {
	val coroutineScope = rememberCoroutineScope()
	val scrollState = rememberScrollState()
	val scrollBehavior = TopAppBarDefaults.exitUntilCollapsedScrollBehavior()

	Scaffold(
		topBar = {
			TopAppBar(
				title = { Text(stringResource(R.string.general)) },
				scrollBehavior = scrollBehavior,
				navigationIcon = {
					IconButton(onClick = { state.navigator.popBackStack() }) {
						Icon(Icons.Rounded.ArrowBack, contentDescription = stringResource(R.string.back))
					}
				}
			)
		}
	) {
		Column(
			modifier = Modifier
				.padding(it)
				.scrollable(scrollState, Orientation.Vertical)
				.nestedScroll(scrollBehavior.nestedScrollConnection),
			verticalArrangement = Arrangement.spacedBy(16.dp),
		) {
			LanguageContent(coroutineScope, state.settings)
			ContentDeliveryContent(coroutineScope, state.settings)

			Spacer(Modifier.weight(1f))
			OutlinedButton(
				modifier = Modifier
					.padding(horizontal = 16.dp, vertical = 8.dp)
					.fillMaxWidth(),
				onClick = { coroutineScope.launch { state.settings.reset() } },
				content = { Text(stringResource(R.string.reset_to_defaults)) }
			)

		}
	}
}

@Composable
private fun LanguageContent(coroutineScope: CoroutineScope, settings: RibaSettings) {
	val showLanguagePrecedenceDialog = remember { mutableStateOf(false) }
	val showChapterLanguageFilterDialog = remember { mutableStateOf(false) }

	val languagePrecedenceText = stringResource(R.string.language_precedence)
	val languagePrecedenceDescriptionText = stringResource(R.string.language_precedence_description)
	val chapterLanguageFilterText = stringResource(R.string.chapter_language_filter)
	val chapterLanguageFilterDescriptionText = stringResource(R.string.chapter_language_filter_description)
	val originalLanguageFilterText = stringResource(R.string.original_language_filter)
	val originalLanguageFilterDescriptionText = stringResource(R.string.original_language_filter_description)

	Column {
		CategoryHeader(text = stringResource(R.string.language))
		ListItem(
			modifier = Modifier.clickable { showLanguagePrecedenceDialog.value = true },
			headlineText = { Text(languagePrecedenceText) },
			supportingText = { Text(languagePrecedenceDescriptionText) },
		)
		ListItem(
			modifier = Modifier.clickable { showChapterLanguageFilterDialog.value = true },
			headlineText = { Text(chapterLanguageFilterText) },
			supportingText = { Text(chapterLanguageFilterDescriptionText) },
		)
		ListItem(
			modifier = Modifier.clickable { },
			headlineText = { Text(originalLanguageFilterText) },
			supportingText = { Text(originalLanguageFilterDescriptionText) },
		)
	}

	if (showLanguagePrecedenceDialog.value) {
		SortableItemDialog(
			isOpen = showLanguagePrecedenceDialog,
			title = languagePrecedenceText,
			description = languagePrecedenceDescriptionText,
			items = settings.getLanguagePreference(),
			onConfirm = {
				coroutineScope.launch { settings.setLanguagePreference(it) }
			}
		)
	}

	if (showChapterLanguageFilterDialog.value) {
		LocaleSelectionDialog(
			isOpen = showChapterLanguageFilterDialog,
			title = chapterLanguageFilterText,
			description = chapterLanguageFilterDescriptionText,
			items = settings.getChapterLanguages(),
			onConfirm = {
				coroutineScope.launch { settings.setChapterLanguages(it) }
			}
		)
	}

}

@Composable
private fun ContentDeliveryContent(coroutineScope: CoroutineScope, settings: RibaSettings) {
	var isDataSaverEnabled by remember { mutableStateOf(settings.isDataSaverEnabled()) }
	var isPort433Enabled by remember { mutableStateOf(settings.isPort443Enabled()) }

	Column {
		CategoryHeader(text = stringResource(R.string.content_delivery))
		ListItem(
			headlineText = { Text(stringResource(R.string.data_saver)) },
			supportingText = { Text(stringResource(R.string.chapter_language_filter_description)) },
			trailingContent = {
				Switch(checked = isDataSaverEnabled, onCheckedChange = {
					isDataSaverEnabled = it
					coroutineScope.launch { settings.setDataSaverEnabled(it) }
				})
			},
		)
		ListItem(
			headlineText = { Text(stringResource(R.string.mangadex_home_port_443)) },
			supportingText = { Text(stringResource(R.string.mangadex_home_port_443_description)) },
			trailingContent = {
				Switch(checked = isPort433Enabled, onCheckedChange = {
					isPort433Enabled = it
					coroutineScope.launch { settings.setPort443Enabled(!isPort433Enabled) }
				})
			},
		)
	}
}

@Composable
private fun CategoryHeader(text: String) = Text(
	text = text,
	modifier = Modifier
		.padding(horizontal = 8.dp)
		.padding(bottom = 6.dp),
	style = MaterialTheme.typography.labelLarge.copy(
		fontFamily = Rubik,
		fontWeight = FontWeight.Medium,
		color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5F)
	)
)

@Preview
@Composable
private fun GeneralScreenPreview() {
	RibaTheme { SettingsGeneralScreen(RibaHostState.createDummy()) }
}