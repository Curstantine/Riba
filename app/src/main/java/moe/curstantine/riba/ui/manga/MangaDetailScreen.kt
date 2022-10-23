package moe.curstantine.riba.ui.manga

import android.util.Log
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.ArrowBack
import androidx.compose.material.icons.rounded.Book
import androidx.compose.material.icons.rounded.Bookmark
import androidx.compose.material.icons.rounded.BookmarkAdd
import androidx.compose.material.icons.rounded.MoreVert
import androidx.compose.material.icons.rounded.Share
import androidx.compose.material.icons.rounded.Star
import androidx.compose.material.icons.rounded.Sync
import androidx.compose.material.icons.rounded.Visibility
import androidx.compose.material3.Button
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedIconButton
import androidx.compose.material3.OutlinedIconToggleButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SuggestionChip
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.material3.TopAppBarScrollBehavior
import androidx.compose.material3.surfaceColorAtElevation
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.google.accompanist.flowlayout.FlowRow
import com.google.accompanist.swiperefresh.SwipeRefresh
import com.google.accompanist.swiperefresh.rememberSwipeRefreshState
import dev.jeziellago.compose.markdowntext.MarkdownText
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.RibaHostState
import moe.curstantine.riba.api.mangadex.DexCoverSize
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.DexUtils
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.riba.RibaAPIService
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaAuthor
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaResultManga
import moe.curstantine.riba.api.riba.models.RibaStatistic
import moe.curstantine.riba.api.riba.models.RibaTag
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.common.components.FlexibleIndicator
import moe.curstantine.riba.ui.theme.Nunito
import moe.curstantine.riba.ui.theme.Rubik
import kotlin.math.roundToInt

@Composable
fun MangaDetailScreen(state: RibaHostState, viewModel: MangaDetailsViewModel) {
    val scrollBehavior = TopAppBarDefaults.enterAlwaysScrollBehavior()
    val isRefreshing by viewModel.isRefreshing.collectAsState()
    val manga by viewModel.getDetails().observeAsState()

    SwipeRefresh(
        state = rememberSwipeRefreshState(isRefreshing),
        onRefresh = { viewModel.refresh() }
    ) {
        if (manga == null || isRefreshing) FlexibleIndicator() else {
            Scaffold(
                topBar = { ScreenTopBar(state.navigator, scrollBehavior) },
                snackbarHost = { SnackbarHost(state.snackbarHost) },
                content = { MangaDetailBody(state, scrollBehavior, it, manga!!) }
            )
        }
    }
}

@Composable
private fun MangaDetailBody(
    state: RibaHostState,
    scrollBehavior: TopAppBarScrollBehavior,
    paddingValues: PaddingValues,
    details: RibaResultManga
) {
    LazyColumn(
        modifier = Modifier.nestedScroll(scrollBehavior.nestedScrollConnection),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        val list = (0..75).map { it.toString() }

        item { MangaDetailHeader(state, paddingValues, details) }

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
}

@Composable
private fun MangaDetailHeader(
    hostState: RibaHostState,
    paddingValues: PaddingValues,
    details: RibaResultManga
) {
    val typography = MaterialTheme.typography
    val colorScheme = MaterialTheme.colorScheme
    val clipboardManager = LocalClipboardManager.current
    val coroutineScope = rememberCoroutineScope()

    val notAvailable = stringResource(R.string.not_available)
    val mutedOnBackground = colorScheme.onBackground.copy(alpha = 0.75F)

    val manga = remember { details.manga.unwrap() }
    val stats = remember { details.statistic?.unwrapOrNull() }

    val tags = remember {
        details.tags
            ?.unwrapOrNull()
            ?.map { it.name?.get(DexLocale.English) ?: "N/A" } ?: emptyList()
    }

    val authors = remember {
        details.authors?.unwrapOrNull()?.map { it.name ?: notAvailable } ?: emptyList()
    }
    val artists = remember {
        details.artists?.unwrapOrNull()?.map { it.name ?: notAvailable } ?: emptyList()
    }
    val artistsAndAuthors = remember {
        (authors + artists.filter { it !in authors }).ifEmpty { null }
    }

    val isDetailsExpanded = remember { mutableStateOf(false) }
    var isInLibrary by remember { mutableStateOf(false) }
    var hasTrackers by remember { mutableStateOf(false) }

    val shareMessage = stringResource(
        R.string.copied_to_clipboard,
        stringResource(R.string.link).lowercase()
    )

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(colorScheme.surfaceColorAtElevation(2.dp))
            .padding(paddingValues)
            .padding(horizontal = 16.dp)
            .padding(bottom = 16.dp)
    ) {
        Row(
            modifier = Modifier.heightIn(220.dp),
            horizontalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            MangaCover(
                details.cover?.unwrapOrNull(),
                maxHeight = 220.dp,
                coverSize = DexCoverSize.Medium,
            )

            Column(
                modifier = Modifier.heightIn(220.dp),
                verticalArrangement = Arrangement.SpaceBetween,
            ) {
                Column(Modifier.padding(bottom = 16.dp)) {
                    Text(
                        text = manga.title?.get(DexLocale.English)
                            ?: stringResource(R.string.no_title),
                        style = typography.headlineSmall.copy(
                            fontWeight = FontWeight.Bold,
                            fontFamily = Rubik
                        )
                    )
                    Text(
                        text = artistsAndAuthors?.joinToString(", ")
                            ?: stringResource(R.string.no_author_artists),
                        style = typography.labelMedium.copy(color = mutedOnBackground)
                    )

                }

                FlowRow(
                    modifier = Modifier.padding(bottom = 8.dp),
                    mainAxisSpacing = 12.dp,
                ) {
                    val textStyle = typography.labelLarge.copy(
                        fontWeight = FontWeight.Medium,
                        fontFamily = Rubik
                    )

                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            tint = colorScheme.primary,
                            imageVector = Icons.Rounded.Star,
                            contentDescription = "Rating",
                            modifier = Modifier.size(22.dp)
                        )
                        Spacer(modifier = Modifier.width(2.dp))
                        if (stats != null) {
                            Text(
                                text = ((stats.bayesian * 100.0).roundToInt() / 100.0).toString(),
                                style = textStyle,
                                color = colorScheme.primary
                            )
                        }
                    }

                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            tint = mutedOnBackground,
                            imageVector = Icons.Rounded.Bookmark,
                            contentDescription = "Follows",
                            modifier = Modifier.size(22.dp)
                        )
                        Spacer(modifier = Modifier.width(2.dp))
                        if (stats != null) {
                            Text(
                                text = stats.follows.toString(),
                                style = textStyle,
                                color = mutedOnBackground
                            )
                        }
                    }

                    // TODO: Add total views
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Icon(
                            tint = mutedOnBackground.copy(alpha = 0.35F),
                            imageVector = Icons.Rounded.Visibility,
                            contentDescription = "Views",
                            modifier = Modifier.size(22.dp)
                        )
                        Spacer(modifier = Modifier.width(2.dp))
                        Text(
                            text = stringResource(R.string.not_available),
                            style = textStyle,
                            color = mutedOnBackground.copy(alpha = 0.35F)
                        )
                    }
                }
            }
        }

        Row(
            modifier = Modifier.padding(top = 16.dp, bottom = 24.dp),
            horizontalArrangement = Arrangement.spacedBy(4.dp)
        ) {

            OutlinedIconToggleButton(
                checked = isInLibrary,
                onCheckedChange = { isInLibrary = it },
                content = {
                    Icon(
                        Icons.Rounded.BookmarkAdd,
                        contentDescription = stringResource(R.string.add_to_library)
                    )
                }
            )

            OutlinedIconToggleButton(
                checked = hasTrackers,
                onCheckedChange = { hasTrackers = it },
                content = {
                    Icon(Icons.Rounded.Sync, contentDescription = stringResource(R.string.trackers))
                }
            )

            OutlinedIconButton(
                onClick = {
                    coroutineScope.launch {
                        clipboardManager.setText(AnnotatedString(DexUtils.getMangaUrl(manga.id)))
                        hostState.snackbarHost.showSnackbar(message = shareMessage)
                    }
                },
                content = {
                    Icon(Icons.Rounded.Share, contentDescription = stringResource(R.string.share))
                }
            )

            Button(onClick = { /*TODO*/ }, modifier = Modifier.fillMaxWidth()) {
                Icon(
                    Icons.Rounded.Book,
                    contentDescription = stringResource(R.string.start_reading)
                )
                Text(text = stringResource(R.string.start_reading))
            }
        }

        BoxWithConstraints {
            val constraints = this
            val halfRowWidth = remember { maxWidth / 2 }

            Column(verticalArrangement = Arrangement.spacedBy(14.dp)) {
                Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                    DetailChipRow(authors, stringResource(R.string.authors), halfRowWidth)
                    DetailChipRow(artists, stringResource(R.string.artists), halfRowWidth)
                }

                if (tags.size <= 5) {
                    DetailChipRow(tags, stringResource(R.string.tags), constraints.maxWidth)
                }
            }
        }

        // TODO: Add better markdown support (mainly for lines/rules, codeblocks and lists)
        AnimatedVisibility(isDetailsExpanded.value) {
            Column(verticalArrangement = Arrangement.spacedBy(14.dp)) {
                if (tags.size > 5) {
                    BoxWithConstraints(Modifier.padding(top = 14.dp)) {
                        DetailChipRow(tags, stringResource(R.string.tags), this.maxWidth)
                    }
                }

                if (manga.description != null) {
                    Text(
                        text = stringResource(R.string.description),
                        style = MaterialTheme.typography.titleSmall.copy(
                            color = MaterialTheme.colorScheme.onBackground.copy(alpha = 0.85F),
                            fontFamily = Rubik,
                            fontWeight = FontWeight.Medium
                        )
                    )

                    MarkdownText(
                        markdown = manga.description[DexLocale.English] ?: "",
                        style = typography.bodyMedium.copy(
                            fontFamily = Nunito,
                            color = colorScheme.onBackground.copy(alpha = 0.75F)
                        )
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(8.dp))

        FilledTonalButton(
            modifier = Modifier.fillMaxWidth(),
            onClick = { isDetailsExpanded.value = !isDetailsExpanded.value },
            content = {
                Text(
                    text = if (isDetailsExpanded.value) stringResource(R.string.show_less)
                    else stringResource(R.string.show_more)
                )
            }
        )
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
                values.map {
                    SuggestionChip(
                        onClick = {},
                        label = { Text(it, maxLines = 1) })
                }
            }
        )
    }
}

@Composable
private fun ScreenTopBar(ribaNavigator: RibaNavigator, scrollBehavior: TopAppBarScrollBehavior) =
    TopAppBar(
        title = {},
        scrollBehavior = scrollBehavior,
        colors = TopAppBarDefaults.smallTopAppBarColors(
            scrolledContainerColor = Color.Transparent,
            containerColor = Color.Transparent,
            titleContentColor = Color.Transparent
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
        }
    )


class MangaDetailsViewModel(private val service: RibaAPIService, private val mangaId: String) :
    ViewModel() {
    private val _isRefreshing = MutableStateFlow(false)
    val isRefreshing: StateFlow<Boolean> get() = _isRefreshing.asStateFlow()

    fun getDetails(): LiveData<RibaResultManga> = details
    private val details: MutableLiveData<RibaResultManga> by lazy {
        MutableLiveData<RibaResultManga>().also { loadDetails() }
    }

    private fun loadDetails(refresh: Boolean = false) = viewModelScope.launch(Dispatchers.IO) {
        Log.i(
            DexLogTag.DEBUG.tag,
            "${if (refresh) "Refreshing" else "Loading"} details for $mangaId"
        )

        val localManga = when (val mangaData = service.mangadex.manga.get(
            mangaId, forceInsert = refresh, tryDatabase = !refresh
        )) {
            is RibaResult.Success -> mangaData.unwrapOrNull()!!
            is RibaResult.Error -> return@launch details
                .postValue(RibaResultManga.fromNullables(mangaData))
        }

        val artists: Deferred<RibaResult<List<RibaAuthor>>> = async(Dispatchers.IO) {
            service.mangadex.author.getStrictCollection(
                localManga.artistIds,
                forceInsert = refresh,
                tryDatabase = !refresh
            )
        }

        val authors: Deferred<RibaResult<List<RibaAuthor>>> = async(Dispatchers.IO) {
            service.mangadex.author.getStrictCollection(
                localManga.authorIds,
                forceInsert = refresh,
                tryDatabase = !refresh,
            )
        }

        val statistic: Deferred<RibaResult<RibaStatistic>> = async(Dispatchers.IO) {
            service.mangadex.manga.getStatistic(mangaId)
        }

        val cover: Deferred<RibaResult<RibaCover?>> = async(Dispatchers.IO) {
            if (localManga.coverId == null) {
                return@async RibaResult.Success(null)
            }

            return@async service.mangadex.manga.getCover(
                localManga.coverId,
                forceInsert = refresh,
                tryDatabase = !refresh,
            )
        }

        val tags: Deferred<RibaResult<List<RibaTag>>> = async(Dispatchers.IO) {
            val resolve = service.mangadex.manga.database.getTagCollection(localManga.tagIds)

            if (resolve.size != localManga.tagIds.size) {
                val error = DexError(
                    "Failed to resolve tags",
                    "Expected ${localManga.tagIds.size} tags, but got only ${resolve.size}"
                )

                Log.w(DexLogTag.MISSING.tag, "Missing Tag ids", error)

                return@async RibaResult.Error(error)
            }

            return@async RibaResult.Success(resolve)
        }

        details.postValue(
            RibaResultManga(
                manga = RibaResult.Success(localManga),
                artists = artists.await(),
                authors = authors.await(),
                cover = cover.await(),
                tags = tags.await(),
                statistic = statistic.await()
            )
        )
    }

    fun refresh() = viewModelScope.launch(Dispatchers.IO) {
        _isRefreshing.emit(true)
        loadDetails(true)
        _isRefreshing.emit(false)
    }

}

@Composable
@Preview(showBackground = true)
private fun DetailBodyPreview() {
    val state = RibaHostState.createDummy()
    val scrollBehavior = TopAppBarDefaults.enterAlwaysScrollBehavior()

    Scaffold(
        topBar = { ScreenTopBar(state.navigator, scrollBehavior) },
        content = { MangaDetailBody(state, scrollBehavior, it, RibaResultManga.getDefault()) }
    )
}