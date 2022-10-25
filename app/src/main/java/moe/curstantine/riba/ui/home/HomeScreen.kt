package moe.curstantine.riba.ui.home

import android.content.Intent
import android.net.Uri
import android.util.Log
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Logout
import androidx.compose.material.icons.rounded.MoreVert
import androidx.compose.material.icons.rounded.Person
import androidx.compose.material3.Divider
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.State
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
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
import moe.curstantine.riba.RibaHostState
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.riba.RibaAPIService
import moe.curstantine.riba.api.riba.RibaConstants
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaFulFilledManga
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

    val user by state.service.mangadex.user.getCurrent().observeAsState()
    val username = user?.unwrapOrNull()?.username ?: stringResource(R.string.guest)
    val isSignedIn = user?.unwrapOrNull() != null

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
                    coroutineScope.launch {
                        val resp = state.service.mangadex.user.logout()

                        state.snackbarHost.showSnackbar(
                            if (resp is RibaResult.Error) resp.error.human
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
            onClick = { navigateTo(RibaRoute.Settings) },
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
    fun getSeasonal(): LiveData<RibaResult<List<RibaFulFilledManga>>> = seasonal
    fun getRecent(): LiveData<RibaResult<List<RibaFulFilledManga>>> = recent

    private val seasonal: MutableLiveData<RibaResult<List<RibaFulFilledManga>>> by lazy {
        MutableLiveData<RibaResult<List<RibaFulFilledManga>>>().also {
            loadSeasonal()
        }
    }

    private val recent: MutableLiveData<RibaResult<List<RibaFulFilledManga>>> by lazy {
        MutableLiveData<RibaResult<List<RibaFulFilledManga>>>().also {
            loadRecent()
        }
    }

    private fun loadSeasonal() = viewModelScope.launch(Dispatchers.IO) {
        Log.i(DexLogTag.DEBUG.tag, "Loading seasonal list.")

        val list = when (val list =
            service.mangadex.mdlist.get(DexConstants.SEASONAL_LIST, tryDatabase = true)) {
            is RibaResult.Success -> list.unwrapOrNull()!!
            is RibaResult.Error -> return@launch seasonal.postValue(list)
        }

        val titles = when (val collection =
            service.mangadex.manga.getStrictCollection(ids = list.titles)) {
            is RibaResult.Success -> collection.unwrapOrNull()!!
            is RibaResult.Error -> return@launch seasonal.postValue(collection)
        }

        return@launch seasonal.postValue(RibaResult.Success(titles.map {
            RibaFulFilledManga.fromNullables(
                manga = it,
                cover = it.coverId?.let { id ->
                    service.mangadex.manga.getCover(id).unwrapOrNull()
                },
            )
        }))

    }

    private fun loadRecent() = viewModelScope.launch(Dispatchers.IO) {
        Log.i(DexLogTag.DEBUG.tag, "Loading recent list.")

        val list = service.mangadex.manga.getCollection(
            limit = 25,
            sort = Pair(DexQueryOrderProperty.CreatedAt, DexQueryOrderValue.Descending),
        ).map {
            it.map { manga ->
                RibaFulFilledManga.fromNullables(
                    manga = manga,
                    cover = manga.coverId?.let { id ->
                        service.mangadex.manga.getCover(id).unwrapOrNull()
                    },
                )
            }
        }

        return@launch recent.postValue(list)
    }
}