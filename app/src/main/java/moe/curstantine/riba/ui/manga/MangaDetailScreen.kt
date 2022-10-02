package moe.curstantine.riba.ui.manga

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ArrowBack
import androidx.compose.material.icons.rounded.MoreVert
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.SmallTopAppBar
import androidx.compose.material3.SuggestionChip
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.TopAppBarScrollBehavior
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.rememberNavController
import com.google.accompanist.flowlayout.FlowRow
import com.google.accompanist.swiperefresh.SwipeRefresh
import com.google.accompanist.swiperefresh.rememberSwipeRefreshState
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.R
import moe.curstantine.riba.api.APIService
import moe.curstantine.riba.api.mangadex.DexCoverSize
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.toRibaCover
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaAuthor
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaResultManga
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.common.components.FlexibleIndicator
import moe.curstantine.riba.ui.theme.Rubik

@Composable
fun MangaDetailScreen(
    ribaNavigator: RibaNavigator,
    paddingValues: State<PaddingValues>,
    viewModel: MangaDetailsViewModel = viewModel(factory = MangaDetailsViewModel.Companion.Factory)
) {
    val isRefreshing by viewModel.isRefreshing.collectAsState()
    viewModel.mangaId = remember {
        ribaNavigator.getArgument("id")
            ?: throw IllegalArgumentException("id parameter is missing!")
    }

    val manga = viewModel.getDetails().observeAsState()
    if (manga.value == null) FlexibleIndicator() else {
        SwipeRefresh(
            state = rememberSwipeRefreshState(isRefreshing),
            onRefresh = { viewModel.fullRefresh() },
            content = {
                MangaDetailBody(ribaNavigator, paddingValues, manga.value!!)
            }
        )
    }
}

@Composable
fun MangaDetailBody(
    ribaNavigator: RibaNavigator, paddingValues: State<PaddingValues>, details: RibaResultManga
) {
    val scrollBehavior = TopAppBarDefaults.enterAlwaysScrollBehavior()

    LazyColumn(
        modifier = Modifier.nestedScroll(scrollBehavior.nestedScrollConnection),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        val list = (0..75).map { it.toString() }

        item {
            Spacer(
                Modifier
                    .padding(paddingValues.value)
                    .height((64 - scrollBehavior.state.collapsedFraction.times(64)).dp)
            )
        }

        item { MangaDetailHeader(details) }

        items(list.size) {
            Text(
                text = list[it],
                style = MaterialTheme.typography.bodyLarge,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
            )
        }
    }

    ScreenTopBar(ribaNavigator, scrollBehavior)
}

@Composable
private fun MangaDetailHeader(details: RibaResultManga) {
    val typography = MaterialTheme.typography
    val colorScheme = MaterialTheme.colorScheme

    val manga = details.manga.unwrap()!!

    val authors = details.authors!!.unwrap()!!.map { it.name!! }
    val artists = details.artists!!.unwrap()!!.map { it.name!! }
    val artistsAndAuthors = remember {
        val it = authors + artists.filter { it !in authors }
        it.ifEmpty { null }
    }

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 16.dp)
    ) {
        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            MangaCover(
                details.cover?.unwrap(),
                maxHeight = 240.dp,
                coverSize = DexCoverSize.Medium,
                elevation = 6.dp,
            )

            Column {
                Text(
                    text = manga.title ?: stringResource(R.string.no_title),
                    style = typography.headlineSmall.copy(
                        fontWeight = FontWeight.Bold,
                        fontFamily = Rubik
                    )
                )

                Text(
                    text = artistsAndAuthors?.joinToString(", ")
                        ?: stringResource(R.string.no_author_artists),
                    style = typography.labelMedium.copy(
                        color = colorScheme.onBackground.copy(alpha = 0.75F)
                    )
                )

                // TODO: Handles favorites, scoring and etc
            }
        }

        Spacer(modifier = Modifier.height(16.dp))

        BoxWithConstraints {
            val chipRowWidth = remember { maxWidth / 2 }

            Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                DetailChipRow(authors, stringResource(R.string.authors), chipRowWidth)
                DetailChipRow(artists, stringResource(R.string.artists), chipRowWidth)
            }
        }
    }
}

@Composable
private fun DetailChipRow(values: List<String>, label: String, width: Dp) {
    Column(Modifier.widthIn(max = width)) {
        Text(
            text = label,
            style = MaterialTheme.typography.titleSmall.copy(
                color = MaterialTheme.colorScheme.onBackground.copy(alpha = 0.85F),
                fontFamily = Rubik,
                fontWeight = FontWeight.Medium
            )
        )

        FlowRow(
            mainAxisSpacing = 8.dp,
            content = {
                values.map { SuggestionChip(onClick = {}, label = { Text(it) }) }
            }
        )
    }
}

@Composable
private fun ScreenTopBar(ribaNavigator: RibaNavigator, scrollBehavior: TopAppBarScrollBehavior) {
    SmallTopAppBar(
        title = {},
        scrollBehavior = scrollBehavior,
        colors = TopAppBarDefaults.smallTopAppBarColors(
            scrolledContainerColor = Color.Transparent,
            containerColor = Color.Transparent,
            titleContentColor = Color.Transparent
        ),
        modifier = Modifier
            .background(
                brush = Brush.verticalGradient(
                    startY = 75F,
                    endY = 200F,
                    colors = listOf(MaterialTheme.colorScheme.surface, Color.Transparent),
                )
            ),
        actions = {
            IconButton(
                onClick = { ribaNavigator.popBackStack() },
                content = { Icon(Icons.Rounded.ArrowBack, stringResource(R.string.back)) },
            )

            Spacer(Modifier.weight(1F))

            // TODO: Handle more
            IconButton(
                onClick = { },
                content = { Icon(Icons.Rounded.MoreVert, stringResource(R.string.more)) }
            )
        },
    )
}

class MangaDetailsViewModel : ViewModel() {
    lateinit var mangaId: String

    private val _isRefreshing = MutableStateFlow(false)

    val isRefreshing: StateFlow<Boolean>
        get() = _isRefreshing.asStateFlow()

    fun getDetails(): LiveData<RibaResultManga> = details

    private val details: MutableLiveData<RibaResultManga> by lazy {
        MutableLiveData<RibaResultManga>().also { loadDetails() }
    }

    private fun loadDetails() {
        viewModelScope.launch(Dispatchers.IO) {
            // Manga is already fetched by the time we get here
            val localManga = APIService.database.manga().get(mangaId)!!

            val artists: Deferred<RibaResult<List<RibaAuthor>>> = async(Dispatchers.IO) {
                conditionallyGetAuthorType(localManga.artistIds, Dispatchers.IO)
            }
            val authors: Deferred<RibaResult<List<RibaAuthor>>> = async(Dispatchers.IO) {
                conditionallyGetAuthorType(localManga.authorIds, Dispatchers.IO)
            }
            val cover: Deferred<RibaResult<RibaCover?>> = async(Dispatchers.IO) {
                if (localManga.coverId == null) {
                    return@async RibaResult.Success(null)
                }

                val local = APIService.database.cover().get(localManga.coverId)
                if (local?.fileName != null) {
                    return@async RibaResult.Success(local)
                }

                val remote = APIService.mangadex.getCover(localManga.coverId)
                if (remote is RibaResult.Success) {
                    return@async RibaResult.Success(remote.value.data.toRibaCover())
                } else {
                    return@async remote as RibaResult.Error
                }
            }

            details.postValue(
                RibaResultManga(
                    manga = RibaResult.Success(localManga),
                    artists = artists.await(),
                    authors = authors.await(),
                    cover = cover.await(),
                )
            )

        }
    }

    private suspend fun conditionallyGetAuthorType(
        ids: List<String>, dispatcher: CoroutineDispatcher
    ): RibaResult<List<RibaAuthor>> {
        return withContext(dispatcher) {
            val local = APIService.database.author().get(ids)
            val missingArtistIds = local.filter { it.name == null }.map { it.id }

            if (missingArtistIds.isNotEmpty()) {
                return@withContext when (val missing =
                    APIService.mangadex.getAuthor(ids = missingArtistIds, forceInsert = true)
                ) {
                    is RibaResult.Error -> missing
                    is RibaResult.Success -> RibaResult.Success(
                        APIService.database.author().get(ids)
                    )

                }
            }


            return@withContext RibaResult.Success(local)
        }
    }


    fun fullRefresh() {
        viewModelScope.launch(Dispatchers.IO) {
            _isRefreshing.emit(true)

            APIService.mangadex.getManga(
                id = mangaId,
                includes = listOf(
                    DexEntityType.CoverArt,
                    DexEntityType.Artist,
                    DexEntityType.Author,
                ),
                forceInsert = true
            )

            loadDetails()

            _isRefreshing.emit(false)
        }
    }

    companion object {
        object Factory : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return MangaDetailsViewModel() as T
            }
        }
    }
}

@Composable
@Preview(showBackground = true)
private fun DetailBodyPreview() {
    MangaDetailBody(
        RibaNavigator(rememberNavController()),
        remember { mutableStateOf(PaddingValues()) },
        RibaResultManga.getDefault(),
    )
}