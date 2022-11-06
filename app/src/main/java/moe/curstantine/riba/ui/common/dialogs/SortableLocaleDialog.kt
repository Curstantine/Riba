package moe.curstantine.riba.ui.common.dialogs

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ArrowDownward
import androidx.compose.material.icons.rounded.ArrowUpward
import androidx.compose.material.icons.rounded.Delete
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.DpOffset
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.mangadex.models.DexLocaleType

@Composable
fun SortableItemDialog(
	isOpen: MutableState<Boolean>,
	title: String,
	description: String,
	items: List<DexLocale>,
	onConfirm: (List<DexLocale>) -> Unit
) {
	val coroutineScope = rememberCoroutineScope()
	val localeMap = remember { items.mapIndexed { index, it -> index to it }.toMutableStateMap() }

	SimpleDialog(isOpen) {
		SimpleDialogHeader(title, description)
		Divider(Modifier.padding(top = 24.dp))

		LazyColumn(Modifier.height(320.dp)) {
			items(localeMap.size) { key ->
				val locale = localeMap[key]!!
				var showLocaleDropDown by remember { mutableStateOf(false) }

				Box {
					LocaleListItem(
						locale = locale,
						canBeRemoved = localeMap.keys.size > 1,
						onItemPress = { showLocaleDropDown = true },
						onRemove = {
							coroutineScope.launch {
								val temp = localeMap.toMutableMap()

								// Gets the keys from deleted index until end,
								// then pushes each and every item up by 1, which will
								// overwrite the deleted item.
								// This leads to the last key being duplicated,
								// hence why the last key is removed from the temp map.
								for (i in (key + 1) until temp.size) {
									temp[i - 1] = temp[i]!!
								}

								temp.remove(temp.keys.last())
								localeMap.clear()
								localeMap.putAll(temp)
							}
						},
						isMoveUpEnabled = key != 0,
						onMoveUp = {
							coroutineScope.launch {
								val index = localeMap.values.indexOf(locale)
								if (index > 0) {
									val temp = localeMap[index - 1]!!
									localeMap[index - 1] = locale
									localeMap[index] = temp
								}
							}
						},
						isMoveDownEnabled = key < localeMap.keys.size - 1,
						onMoveDown = {
							coroutineScope.launch {
								val index = localeMap.values.indexOf(locale)
								if (index < localeMap.size - 1) {
									val temp = localeMap[index + 1]!!
									localeMap[index + 1] = locale
									localeMap[index] = temp
								}
							}
						}
					)

					DropdownMenu(
						modifier = Modifier
							.heightIn(max = 380.dp)
							.width(220.dp),
						expanded = showLocaleDropDown,
						offset = DpOffset(10.dp, 0.dp),
						onDismissRequest = { showLocaleDropDown = false }
					) {
						val availableLocales = remember {
							DexLocale.values().filter { it !in localeMap.values && it != DexLocale.NotImplemented }
						}

						for (availableLocale in availableLocales) {
							LocaleDropDownItem(
								locale = availableLocale,
								onClick = {
									coroutineScope.launch {
										localeMap[key] = availableLocale
										showLocaleDropDown = false
									}
								}
							)
						}
					}
				}
			}

			item {
				OutlinedButton(
					modifier = Modifier
						.padding(vertical = 12.dp, horizontal = 24.dp)
						.fillMaxWidth(),
					content = { Text(stringResource(R.string.add_locale)) },
					onClick = {
						coroutineScope.launch {
							localeMap[localeMap.size] = DexLocale.NotImplemented
						}
					},
				)
			}
		}

		Divider(Modifier.padding(bottom = 24.dp))
		SimpleDialogFooter(
			onCancel = { isOpen.value = false },
			onConfirm = {
				onConfirm(localeMap.values.toList())
				isOpen.value = false
			},
		)
	}
}

@Composable
fun LocaleDropDownItem(locale: DexLocale, onClick: () -> Unit) {
	val languageFlagId = remember(locale) { locale.getFlagId() }
	val languageName = remember(locale) { locale.getLanguage() }
	val languageType = remember(locale) { locale.getTypeName() }

	DropdownMenuItem(
		onClick = onClick,
		text = {
			Column(verticalArrangement = Arrangement.spacedBy(2.dp)) {
				Text(languageName)
				if (locale.type != DexLocaleType.Default) {
					Text(languageType, color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5F))
				}
			}
		},
		leadingIcon = {
			if (languageFlagId != null) {
				Image(
					modifier = Modifier.size(24.dp),
					contentScale = ContentScale.FillWidth,
					painter = painterResource(id = languageFlagId),
					contentDescription = null,
				)
			}
		},
	)
}

@Composable
fun LocaleListItem(
	locale: DexLocale,
	onItemPress: () -> Unit = {},
	onMoveUp: () -> Unit = {},
	onMoveDown: () -> Unit = {},
	onRemove: () -> Unit = {},
	isSortingEnabled: Boolean = true,
	canBeRemoved: Boolean = false,
	isMoveUpEnabled: Boolean = false,
	isMoveDownEnabled: Boolean = false,
) {
	val languageName = remember(locale) { locale.getLanguage() }
	val languageType = remember(locale) { locale.getTypeName() }
	val languageFlagId = remember(locale) { locale.getFlagId() }

	ListItem(
		modifier = Modifier
			.padding(0.dp)
			.clickable { onItemPress.invoke() },
		headlineText = { Text(languageName) },
		supportingText = {
			if (locale.type != DexLocaleType.Default) {
				Text(languageType, color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5F))
			}
		},
		leadingContent = {
			if (isSortingEnabled) {
				DeleteButton(canBeRemoved, onRemove)
			} else if (languageFlagId != null) {
				Box(contentAlignment = Alignment.Center) {
					Image(
						modifier = Modifier.size(24.dp),
						contentScale = ContentScale.FillWidth,
						painter = painterResource(id = languageFlagId),
						contentDescription = null,
					)
				}
			}
		},
		trailingContent = {
			if (isSortingEnabled) {
				Row(horizontalArrangement = Arrangement.End) {
					IconButton(enabled = isMoveUpEnabled, onClick = onMoveUp) {
						Icon(Icons.Rounded.ArrowUpward, contentDescription = stringResource(R.string.up))
					}

					IconButton(enabled = isMoveDownEnabled, onClick = onMoveDown) {
						Icon(Icons.Rounded.ArrowDownward, contentDescription = stringResource(R.string.down))
					}
				}
			} else {
				DeleteButton(canBeRemoved, onRemove)
			}
		},
	)
}

@Composable
private fun DeleteButton(enabled: Boolean, onClick: () -> Unit) {
	AnimatedVisibility(enabled) {
		IconButton(enabled = enabled, onClick = onClick) {
			Icon(
				Icons.Rounded.Delete,
				contentDescription = stringResource(R.string.remove),
				tint = MaterialTheme.colorScheme.error
			)
		}
	}
}