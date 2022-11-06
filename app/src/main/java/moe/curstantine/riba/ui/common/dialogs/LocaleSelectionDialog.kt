package moe.curstantine.riba.ui.common.dialogs

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.Divider
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.DpOffset
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import moe.curstantine.riba.api.mangadex.models.DexLocale

@Composable
fun LocaleSelectionDialog(
	isOpen: MutableState<Boolean>,
	title: String,
	description: String,
	items: List<DexLocale>,
	onConfirm: (List<DexLocale>) -> Unit
) {
	val coroutineScope = rememberCoroutineScope()
	val localeList = remember { items.toMutableStateList() }
	val availableLocales = remember(localeList) {
		DexLocale.values().filter { it !in localeList && it != DexLocale.NotImplemented }
	}

	SimpleDialog(isOpen) {
		SimpleDialogHeader(title, description)
		Divider(Modifier.padding(top = 24.dp))

		LazyColumn {
			items(localeList.size) { index ->
				val locale = localeList[index]
				val showLocaleDropDown = remember { mutableStateOf(false) }

				Box {
					LocaleListItem(
						locale = locale,
						isSortingEnabled = false,
						onItemPress = { coroutineScope.launch { showLocaleDropDown.value = true } },
						canBeRemoved = localeList.size > 1,
						onRemove = { coroutineScope.launch { localeList.remove(locale) } },
					)

					DropdownMenu(
						modifier = Modifier
							.heightIn(max = 380.dp)
							.width(220.dp),
						expanded = showLocaleDropDown.value,
						offset = DpOffset(10.dp, 0.dp),
						onDismissRequest = { showLocaleDropDown.value = false },
						content = {
							for (availableLocale in availableLocales) {
								LocaleDropDownItem(
									locale = availableLocale,
									onClick = {
										coroutineScope.launch {
											localeList[index] = availableLocale
											showLocaleDropDown.value = false
										}
									}
								)
							}
						}
					)
				}
			}

			item {
				OutlinedButton(
					modifier = Modifier
						.padding(vertical = 12.dp, horizontal = 24.dp)
						.fillMaxWidth(),
					content = { Text(stringResource(moe.curstantine.riba.R.string.add_locale)) },
					onClick = {
						coroutineScope.launch { localeList.add(DexLocale.NotImplemented) }
					},
				)
			}
		}

		Divider(Modifier.padding(bottom = 24.dp))
		SimpleDialogFooter(
			onCancel = { isOpen.value = false },
			onConfirm = {
				onConfirm(localeList)
				isOpen.value = false
			},
		)
	}
}