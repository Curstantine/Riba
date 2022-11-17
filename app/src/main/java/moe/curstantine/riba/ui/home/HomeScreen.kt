package moe.curstantine.riba.ui.home

import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Logout
import androidx.compose.material.icons.rounded.MoreVert
import androidx.compose.material.icons.rounded.Person
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.DpOffset
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.riba.RibaAPIService
import moe.curstantine.riba.api.riba.RibaConstants
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaFulFilledManga
import moe.curstantine.riba.api.riba.models.RibaManga
import moe.curstantine.riba.nav.RibaRoute
import moe.curstantine.riba.ui.common.dialogs.AuthDialog
import moe.curstantine.riba.ui.manga.MangaCardRow
import moe.curstantine.riba.ui.theme.Rubik

@Composable
fun HomeScreen(
	state: RibaHostState,
	paddingValues: State<PaddingValues>,
	viewModel: HomeViewModel
) {
	Column(
		modifier = Modifier
			.padding(bottom = paddingValues.value.calculateBottomPadding())
			.verticalScroll(rememberScrollState()),
		verticalArrangement = Arrangement.spacedBy(8.dp)
	) {
		HeaderRow(state, viewModel.viewModelScope, paddingValues)

		MangaCardRow(
			state.navigator,
			viewModel.getSeasonal(),
			stringResource(R.string.seasonal)
		)
		MangaCardRow(
			state.navigator,
			viewModel.getRecent(),
			stringResource(R.string.recently_added)
		)
	}
}

@Composable
private fun HeaderRow(
	state: RibaHostState,
	coroutineScope: CoroutineScope,
	paddingValues: State<PaddingValues>
) {
	val typography = MaterialTheme.typography
	val colorScheme = MaterialTheme.colorScheme
	val rowColor = colorScheme.onBackground.copy(alpha = 0.5F)
	val signOutMessage = stringResource(R.string.signed_out_of, stringResource(R.string.mangadex))

	val user by state.service.mangadex.user.currentUser.collectAsState()
	val isSignedIn = remember(user) { user != null }
	val username = remember(user) { user?.username } ?: stringResource(R.string.guest)

	val showAuthModal = remember { mutableStateOf(false) }
	val dropdownMenuExpanded = remember { mutableStateOf(false) }

	AuthDialog(state, showAuthModal)

	Row(
		modifier = Modifier
			.fillMaxWidth()
			.padding(all = 12.dp)
			.padding(top = paddingValues.value.calculateTopPadding()),
		verticalAlignment = Alignment.CenterVertically,
	) {
		Column {
			Text(
				text = stringResource(R.string.hello_there),
				style = typography.bodySmall.copy(
					fontFamily = Rubik,
					fontWeight = FontWeight.Light,
					color = rowColor.copy(alpha = 0.4F),
				),
			)
			Text(
				text = username,
				style = typography.titleLarge.copy(
					fontFamily = Rubik,
					fontWeight = FontWeight.SemiBold,
					color = rowColor.copy(alpha = 0.75F)
				)
			)
		}

		Spacer(modifier = Modifier.weight(1F))

		AnimatedVisibility(visible = !isSignedIn) {
			TextButton(onClick = { showAuthModal.value = true }) {
				Text(
					stringResource(R.string.sign_in),
					style = typography.labelLarge.copy(
						color = MaterialTheme.colorScheme.primary.copy(alpha = 0.75F)
					)
				)
			}
		}

		AnimatedVisibility(visible = isSignedIn) {
			IconButton(
				content = {
					Icon(
						Icons.Rounded.Logout,
						tint = rowColor,
						contentDescription = stringResource(R.string.sign_out)
					)
				},
				onClick = {
					coroutineScope.launch(Dispatchers.IO) {
						val resp = state.service.mangadex.user.runCatching { logout(Dispatchers.IO) }

						state.snackbarHost.showSnackbar(
							if (resp.isFailure) resp.exceptionOrNull()?.message ?: DexError.Unknown.message
							else signOutMessage
						)
					}
				}
			)
		}

		Box(contentAlignment = Alignment.Center) {
			IconButton(onClick = { dropdownMenuExpanded.value = true }) {
				Icon(
					if (isSignedIn) Icons.Rounded.Person else Icons.Rounded.MoreVert,
					tint = rowColor,
					contentDescription = stringResource(R.string.more)
				)
			}

			AccountDropDown(
				expanded = dropdownMenuExpanded,
				navigateTo = { coroutineScope.launch { state.navigator.navigateTo(it) } },
			)
		}
	}
}

@Composable
private fun AccountDropDown(expanded: MutableState<Boolean>, navigateTo: (RibaRoute) -> Unit) {
	val context = LocalContext.current

	val statusIntent = remember {
		Intent(Intent.ACTION_VIEW, Uri.parse(DexConstants.STATUS_PAGE))
	}

	val issuesIntent = remember {
		Intent(Intent.ACTION_VIEW, Uri.parse(RibaConstants.ISSUES_URL))
	}

	DropdownMenu(
		modifier = Modifier.width(150.dp),
		expanded = expanded.value,
		onDismissRequest = { expanded.value = false },
		offset = DpOffset(x = (-120).dp, y = 0.dp),
	) {
		DropdownMenuItem(
			onClick = { context.startActivity(statusIntent) },
			text = { Text(text = stringResource(R.string.status)) },
		)

		DropdownMenuItem(
			onClick = { context.startActivity(issuesIntent) },
			text = { Text(text = stringResource(R.string.issues)) },
		)

		Divider(modifier = Modifier.padding(vertical = 8.dp))

		DropdownMenuItem(
			onClick = { navigateTo(RibaRoute.Settings.Screen) },
			text = { Text(text = stringResource(R.string.settings)) },
		)
	}
}

@Composable
@Preview(showBackground = true)
private fun PreviewHeaderRow() {
	HeaderRow(
		RibaHostState.createDummy(),
		rememberCoroutineScope(),
		remember { mutableStateOf(PaddingValues(0.dp)) })
}

@Composable
@Preview(showBackground = true)
private fun PreviewAccountDropDown() {
	AccountDropDown(
		expanded = remember { mutableStateOf(true) },
		navigateTo = {},
	)
}

class HomeViewModel(private val service: RibaAPIService) : ViewModel() {
	fun getSeasonal(): LiveData<Result<List<RibaFulFilledManga>>> = seasonal
	fun getRecent(): LiveData<Result<List<RibaFulFilledManga>>> = recent

	private val seasonal: MutableLiveData<Result<List<RibaFulFilledManga>>> by lazy {
		MutableLiveData<Result<List<RibaFulFilledManga>>>().also { loadSeasonal() }
	}

	private val recent: MutableLiveData<Result<List<RibaFulFilledManga>>> by lazy {
		MutableLiveData<Result<List<RibaFulFilledManga>>>().also { loadRecent() }
	}

	private fun loadSeasonal() = viewModelScope.launch(Dispatchers.IO) {
		Log.i(DexLogTag.DEBUG.tagName, "Loading seasonal list.")

		val list = service.mangadex.mdList.runCatching {
			get(Dispatchers.IO, DexConstants.SEASONAL_LIST, tryDatabase = true)
		}
			.onFailure { return@launch seasonal.postValue(Result.failure(it)) }
			.getOrThrow()

		val titles = service.mangadex.manga.runCatching {
			getStrictCollection(Dispatchers.IO, ids = list.titles)
		}
			.onFailure { return@launch seasonal.postValue(Result.failure(it)) }
			.getOrThrow()


		val coverAssociates: Map<String, RibaCover?> = titles
			.filter { it.coverId != null }
			.associateBy<RibaManga, String, RibaCover?>({ it.coverId!! }, { null }).toMutableMap()
			.apply {
				service.mangadex.manga.runCatching {
					getCoverCollection(
						dispatcher = Dispatchers.IO,
						ids = this@apply.keys.toList(),
						limit = this@apply.size
					)
				}.onSuccess { it.forEach { cover -> this[cover.id] = cover } }
			}

		val fulfilledTitles = titles.map {
			RibaFulFilledManga.fromNullables(manga = it, cover = coverAssociates[it.coverId])
		}

		return@launch seasonal.postValue(Result.success(fulfilledTitles))
	}

	private fun loadRecent() = viewModelScope.launch(Dispatchers.IO) {
		Log.i(DexLogTag.DEBUG.tagName, "Loading recent list.")

		val titles = service.mangadex.manga.runCatching {
			getCollection(
				dispatcher = Dispatchers.IO,
				limit = 25,
				sort = Pair(DexQueryOrderProperty.CreatedAt, DexQueryOrderValue.Descending)
			)
		}
			.onFailure { return@launch recent.postValue(Result.failure(it)) }
			.getOrThrow()

		val coverAssociates: Map<String, RibaCover?> = titles
			.filter { it.coverId != null }
			.associateBy<RibaManga, String, RibaCover?>({ it.coverId!! }, { null }).toMutableMap()
			.apply {
				service.mangadex.manga.runCatching {
					getCoverCollection(
						dispatcher = Dispatchers.IO,
						ids = this@apply.keys.toList(),
						limit = this@apply.size
					)
				}.onSuccess { it.forEach { cover -> this[cover.id] = cover } }
			}

		val fulfilledTitles = titles.map {
			RibaFulFilledManga.fromNullables(manga = it, cover = coverAssociates[it.coverId])
		}

		return@launch recent.postValue(Result.success(fulfilledTitles))
	}
}