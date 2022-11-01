package moe.curstantine.riba.ui.manga

import android.util.Log
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import com.google.accompanist.flowlayout.FlowRow
import com.google.accompanist.swiperefresh.SwipeRefresh
import com.google.accompanist.swiperefresh.rememberSwipeRefreshState
import dev.jeziellago.compose.markdowntext.MarkdownText
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.R
import moe.curstantine.riba.api.mangadex.DexCoverSize
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.DexUtils
import moe.curstantine.riba.api.mangadex.models.DexChapterQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.riba.RibaAPIService
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.*
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.common.components.FlexibleIndicator
import moe.curstantine.riba.ui.theme.Nunito
import moe.curstantine.riba.ui.theme.RibaTheme
import moe.curstantine.riba.ui.theme.Rubik
import kotlin.coroutines.CoroutineContext
import kotlin.math.roundToInt

@Composable
fun MangaDetailScreen(state: RibaHostState, viewModel: MangaDetailsViewModel) {
	val scrollBehavior = TopAppBarDefaults.enterAlwaysScrollBehavior()
	val isRefreshing by viewModel.isRefreshing.collectAsState()

	val manga by viewModel.manga.collectAsState()
	val statistic by viewModel.statistic.collectAsState()
	val cover by viewModel.statistic.collectAsState()

	val isLoading = remember(manga, statistic) { manga == null && statistic == null && cover == null }

	SwipeRefresh(state = rememberSwipeRefreshState(isRefreshing), onRefresh = { viewModel.refresh() }) {
		if (isLoading || isRefreshing) FlexibleIndicator() else {
			Scaffold(topBar = { ScreenTopBar(state.navigator, scrollBehavior) },
				snackbarHost = { SnackbarHost(state.snackbarHost) },
				content = { MangaDetailBody(state, scrollBehavior, it, viewModel) })
		}
	}
}

@Composable
private fun MangaDetailBody(
	state: RibaHostState,
	scrollBehavior: TopAppBarScrollBehavior,
	paddingValues: PaddingValues,
	viewModel: MangaDetailsViewModel,
) {
	val chapters by viewModel.chapters.collectAsState()
	val areChaptersLoading by viewModel.areChaptersLoading.collectAsState()
	var chapterListEndReached by remember { mutableStateOf(false) }

	LazyColumn(Modifier.nestedScroll(scrollBehavior.nestedScrollConnection)) {
		item { MangaDetailHeader(state, paddingValues, viewModel) }

		item {
			AnimatedVisibility(visible = chapters is RibaResult.Error) {
				if (chapters is RibaResult.Error) {
					Box(
						contentAlignment = Alignment.Center,
						modifier = Modifier
							.background(MaterialTheme.colorScheme.error)
							.heightIn(42.dp)
							.fillMaxWidth()
							.padding(horizontal = 16.dp, vertical = 4.dp)
					) {
						Text(
							text = (chapters as RibaResult.Error).error.human,
							style = MaterialTheme.typography.bodyMedium,
							color = MaterialTheme.colorScheme.onError,
						)
					}
				}
			}
		}

		if (chapters is RibaResult.Success) {
			item {
				Row(
					modifier = Modifier
						.fillMaxWidth()
						.height(64.dp)
						.padding(horizontal = 16.dp),
					verticalAlignment = Alignment.CenterVertically
				) {
					Spacer(Modifier.weight(1F))

					IconButton(onClick = { /*TODO*/ }) {
						Icon(
							imageVector = Icons.Rounded.FilterList,
							tint = MaterialTheme.colorScheme.primary,
							contentDescription = stringResource(R.string.filter)
						)
					}
				}
			}

			items((chapters as RibaResult.Success<List<RibaFulfilledChapter>>).value) {
				ChapterItem(it)
			}

			if ((chapters as RibaResult.Success<List<RibaFulfilledChapter>>).value.isNotEmpty()) {
				item {
					LaunchedEffect(true) {
						if (!chapterListEndReached) {
							chapterListEndReached = viewModel.startPagination()
						}
					}
				}
			}
		}

		item {
			AnimatedVisibility(areChaptersLoading) {
				LinearProgressIndicator(modifier = Modifier.fillMaxWidth())
			}
		}
	}
}

@Composable
private fun MangaDetailHeader(
	hostState: RibaHostState,
	paddingValues: PaddingValues,
	viewModel: MangaDetailsViewModel,
) {
	val typography = MaterialTheme.typography
	val colorScheme = MaterialTheme.colorScheme
	val mutedOnBackground = colorScheme.onBackground.copy(alpha = 0.75F)

	val clipboardManager = LocalClipboardManager.current
	val preferredLanguages = remember { hostState.settings.getLanguagePreference() }

	val notAvailable = stringResource(R.string.not_available)
	val shareMessage = stringResource(R.string.copied_to_clipboard, stringResource(R.string.link).lowercase())

	val currentUser by hostState.service.mangadex.user.currentUser.collectAsState()
	val manga by viewModel.manga.collectAsState()
	val stats by viewModel.statistic.collectAsState()
	val followed by viewModel.followed.collectAsState()
	val authors by viewModel.authors.collectAsState()
	val artists by viewModel.artists.collectAsState()
	val cover by viewModel.cover.collectAsState()
	val tags by viewModel.tags.collectAsState()

	val localizedAuthors = remember(authors) {
		authors?.unwrapOrNull()?.map { it.name ?: notAvailable } ?: emptyList()
	}

	val localizedArtists = remember(artists) {
		artists?.unwrapOrNull()?.map { it.name ?: notAvailable } ?: emptyList()
	}

	val localizedTags = remember(tags) {
		tags?.unwrapOrNull()?.map { tag ->
			tag.name
				?.runCatching { DexUtils.getPreferredLocalizedValue(preferredLanguages, tag.name) }
				?.getOrNull() ?: notAvailable
		} ?: emptyList()
	}

	val artistAuthors = remember(localizedAuthors, localizedArtists) {
		val filteredArtists = localizedArtists.filter { it !in localizedAuthors }
		(localizedAuthors + filteredArtists).ifEmpty { null }
	}

	val localizedDescription = remember(manga) {
		val localManga = manga?.unwrapOrNull()

		localManga?.description?.runCatching {
			DexUtils.getPreferredLocalizedValue(preferredLanguages, localManga.description)
		}?.getOrNull()
	}

	val isMoreEnabled = remember(manga, tags) {
		if (manga == null || manga is RibaResult.Error) false else {
			val privateTags = tags?.unwrapOrNull()

			(localizedDescription != null) || (privateTags != null && privateTags.size > 5)
		}
	}

	var isDetailsExpanded by remember { mutableStateOf(false) }
	var hasTrackers by remember { mutableStateOf(false) }

	Column(
		modifier = Modifier
			.fillMaxWidth()
			.background(colorScheme.surfaceColorAtElevation(2.dp))
			.padding(paddingValues)
			.padding(horizontal = 16.dp)
			.padding(bottom = 16.dp)
	) {
		val privateManga = remember(manga) { manga!!.unwrap() }

		Row(
			modifier = Modifier.heightIn(220.dp), horizontalArrangement = Arrangement.spacedBy(16.dp)
		) {
			MangaCover(
				cover?.unwrapOrNull(),
				maxHeight = 220.dp,
				coverSize = DexCoverSize.Medium,
			)

			Column(
				modifier = Modifier.heightIn(220.dp),
				verticalArrangement = Arrangement.SpaceBetween,
			) {
				Column(Modifier.padding(bottom = 16.dp)) {
					Text(
						text = privateManga.title?.get(DexLocale.English) ?: notAvailable,
						style = typography.headlineSmall.copy(fontWeight = FontWeight.Bold, fontFamily = Rubik)
					)
					Text(
						text = artistAuthors?.joinToString(", ") ?: stringResource(R.string.no_author_artists),
						style = typography.labelMedium.copy(color = mutedOnBackground)
					)
				}

				if (stats != null) {
					val privateStats = remember { stats!!.unwrap() }

					FlowRow(
						modifier = Modifier.padding(bottom = 8.dp),
						mainAxisSpacing = 12.dp,
					) {
						val textStyle = typography.labelLarge.copy(
							fontWeight = FontWeight.Medium, fontFamily = Rubik
						)

						Row(verticalAlignment = Alignment.CenterVertically) {
							Icon(
								tint = colorScheme.primary,
								imageVector = Icons.Rounded.Star,
								contentDescription = stringResource(R.string.rating),
								modifier = Modifier.size(22.dp)
							)
							Spacer(modifier = Modifier.width(2.dp))
							Text(
								text = ((privateStats.bayesian * 100.0).roundToInt() / 100.0).toString(),
								style = textStyle,
								color = colorScheme.primary
							)
						}

						Row(verticalAlignment = Alignment.CenterVertically) {
							Icon(
								tint = mutedOnBackground,
								imageVector = Icons.Rounded.Bookmark,
								contentDescription = stringResource(R.string.follows),
								modifier = Modifier.size(22.dp)
							)
							Spacer(modifier = Modifier.width(2.dp))
							Text(
								text = privateStats.follows.toString(),
								style = textStyle,
								color = mutedOnBackground
							)
						}

						// TODO: Add total views
						Row(verticalAlignment = Alignment.CenterVertically) {
							Icon(
								tint = mutedOnBackground.copy(alpha = 0.35F),
								imageVector = Icons.Rounded.Visibility,
								contentDescription = stringResource(R.string.views),
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
		}

		Row(
			modifier = Modifier.padding(top = 16.dp, bottom = 24.dp), horizontalArrangement = Arrangement.spacedBy(4.dp)
		) {
			val privateFollowed = remember(followed) { followed?.unwrapOrNull() }

			if (currentUser != null && privateFollowed != null) {
				OutlinedIconToggleButton(checked = privateFollowed, onCheckedChange = {
					viewModel.viewModelScope.launch {
						val res = hostState.service.mangadex.manga.let {
							if (!privateFollowed) it.follow(privateManga.id)
							else it.unfollow(privateManga.id)
						}

						when (res) {
							is RibaResult.Success -> viewModel.followed.emit(RibaResult.Success(!privateFollowed))
							is RibaResult.Error -> {
								hostState.snackbarHost.showSnackbar(res.error.human)
							}
						}
					}
				}, content = {
					Icon(
						Icons.Rounded.BookmarkAdd, contentDescription = stringResource(R.string.add_to_library)
					)
				})
			}

			OutlinedIconToggleButton(checked = hasTrackers, onCheckedChange = { hasTrackers = it }, content = {
				Icon(Icons.Rounded.Sync, contentDescription = stringResource(R.string.trackers))
			})

			OutlinedIconButton(onClick = {
				viewModel.viewModelScope.launch {
					clipboardManager.setText(AnnotatedString(DexUtils.getMangaUrl(privateManga.id)))
					hostState.snackbarHost.showSnackbar(message = shareMessage)
				}
			}, content = {
				Icon(Icons.Rounded.Share, contentDescription = stringResource(R.string.share))
			})

			Button(onClick = { /*TODO*/ }, modifier = Modifier.fillMaxWidth()) {
				Icon(
					Icons.Rounded.Book, contentDescription = stringResource(R.string.start_reading)
				)
				Text(text = stringResource(R.string.start_reading))
			}
		}

		BoxWithConstraints {
			val constraints = this

			Column(verticalArrangement = Arrangement.spacedBy(14.dp)) {
				FlowRow(mainAxisSpacing = 16.dp, crossAxisSpacing = 16.dp) {
					DetailChipRow(localizedAuthors, stringResource(R.string.authors), constraints.maxWidth)
					DetailChipRow(localizedArtists, stringResource(R.string.artists), constraints.maxWidth)
				}

				if (localizedTags.size <= 5) {
					DetailChipRow(localizedTags, stringResource(R.string.tags), constraints.maxWidth)
				}
			}
		}


		AnimatedVisibility(isDetailsExpanded) {
			Column {
				if (localizedTags.size > 5) {
					BoxWithConstraints(Modifier.padding(top = 14.dp)) {
						DetailChipRow(localizedTags, stringResource(R.string.tags), this.maxWidth)
					}
				}

				// TODO: Add better markdown support (mainly for lines/rules, codeblocks and lists)
				if (localizedDescription != null) {
					Spacer(Modifier.padding(top = 14.dp))

					Text(
						modifier = Modifier.padding(bottom = 4.dp),
						text = stringResource(R.string.description),
						style = MaterialTheme.typography.titleSmall.copy(
							color = MaterialTheme.colorScheme.onBackground.copy(alpha = 0.85F),
							fontFamily = Rubik,
							fontWeight = FontWeight.Medium
						)
					)

					MarkdownText(
						markdown = localizedDescription,
						style = typography.bodyMedium.copy(
							fontFamily = Nunito,
							color = colorScheme.onBackground.copy(alpha = 0.75F)
						)
					)
				}
			}
		}

		if (isMoreEnabled) {
			Spacer(modifier = Modifier.height(8.dp))

			FilledTonalButton(modifier = Modifier.fillMaxWidth(),
				onClick = { isDetailsExpanded = !isDetailsExpanded },
				content = {
					Text(
						text = if (isDetailsExpanded) stringResource(R.string.show_less)
						else stringResource(R.string.show_more)
					)
				})
		}
	}
}

@Composable
private fun ChapterItem(chap: RibaFulfilledChapter) {
	val which = remember {
		if (chap.chapter.chapter != null) {
			if (chap.chapter.title.isNullOrEmpty()) R.string.chapter_x
			else R.string.ch_x
		} else R.string.oneshot
	}

	val chapterName = remember {
		if (chap.chapter.chapter != null) {
			if (!chap.chapter.title.isNullOrBlank()) "${chap.chapter.chapter} - ${chap.chapter.title}"
			else chap.chapter.chapter.toString()
		} else ""
	}

	val groupNames = remember { chap.groups.map { it.name } }
	val languageFlagId = remember { chap.chapter.language.getFlagId() }

	ListItem(
		headlineText = { Text(text = stringResource(which, chapterName)) },
		supportingText = { Text(text = groupNames.joinToString(", ")) },
		leadingContent = {
			Box(contentAlignment = Alignment.Center) {
				if (languageFlagId != null) {
					Image(
						modifier = Modifier.size(24.dp),
						contentScale = ContentScale.FillWidth,
						painter = painterResource(id = languageFlagId),
						contentDescription = chap.chapter.language.toString(),
					)
				} else {
					Text(
						text = chap.chapter.language.toString(),
						style = MaterialTheme.typography.bodySmall
					)
				}
			}
		},
	)
}

@Composable
private fun DetailChipRow(values: List<String>, label: String, width: Dp) = if (values.isEmpty()) Unit
else Column(Modifier.widthIn(max = width)) {
	Text(
		text = label,
		style = MaterialTheme.typography.titleSmall.copy(
			color = MaterialTheme.colorScheme.onBackground.copy(alpha = 0.85F),
			fontFamily = Rubik,
			fontWeight = FontWeight.Medium
		)
	)

	FlowRow(mainAxisSpacing = 8.dp, content = {
		values.map {
			SuggestionChip(onClick = {}, label = { Text(it, maxLines = 1) })
		}
	})
}

@Composable
private fun ScreenTopBar(ribaNavigator: RibaNavigator, scrollBehavior: TopAppBarScrollBehavior) =
	TopAppBar(title = {}, scrollBehavior = scrollBehavior, colors = TopAppBarDefaults.smallTopAppBarColors(
		scrolledContainerColor = Color.Transparent,
		containerColor = Color.Transparent,
		titleContentColor = Color.Transparent
	), actions = {
		IconButton(
			onClick = { ribaNavigator.popBackStack() },
			content = { Icon(Icons.Rounded.ArrowBack, stringResource(R.string.back)) },
		)

		Spacer(Modifier.weight(1F))

		// TODO: Handle more
		IconButton(onClick = { }, content = { Icon(Icons.Rounded.MoreVert, stringResource(R.string.more)) })
	})


class MangaDetailsViewModel(
	private val service: RibaAPIService,
	private val mangaId: String,
	private val isDummy: Boolean = false,
) : ViewModel() {
	// TODO: Add pagination and filtering.
	private val translatedLanguages = MutableStateFlow(listOf(DexLocale.English))

	/**
	 * Offset should start from 0, to collection limit.
	 *
	 * Null is used when there are no more chapters to fetch.
	 */
	private val offset = MutableStateFlow<Int?>(0)

	private val _isRefreshing = MutableStateFlow(false)
	val isRefreshing: StateFlow<Boolean> get() = _isRefreshing.asStateFlow()

	private val _areChaptersLoading = MutableStateFlow(false)
	val areChaptersLoading: StateFlow<Boolean> get() = _areChaptersLoading.asStateFlow()

	val followed = MutableStateFlow<RibaResult<Boolean>?>(null)

	private val _manga = MutableStateFlow<RibaResult<RibaManga>?>(null)
	val manga: StateFlow<RibaResult<RibaManga>?> get() = _manga.asStateFlow()

	private val _statistic = MutableStateFlow<RibaResult<RibaStatistic>?>(null)
	val statistic: StateFlow<RibaResult<RibaStatistic>?> get() = _statistic.asStateFlow()

	private val _cover = MutableStateFlow<RibaResult<RibaCover>?>(null)
	val cover: StateFlow<RibaResult<RibaCover>?> get() = _cover.asStateFlow()

	private val _authors = MutableStateFlow<RibaResult<List<RibaAuthor>>?>(null)
	val authors: StateFlow<RibaResult<List<RibaAuthor>>?> get() = _authors.asStateFlow()

	private val _artists = MutableStateFlow<RibaResult<List<RibaAuthor>>?>(null)
	val artists: StateFlow<RibaResult<List<RibaAuthor>>?> get() = _artists.asStateFlow()

	private val _tags = MutableStateFlow<RibaResult<List<RibaTag>>?>(null)
	val tags: StateFlow<RibaResult<List<RibaTag>>?> get() = _tags.asStateFlow()

	private val _chapters = MutableStateFlow<RibaResult<List<RibaFulfilledChapter>>?>(null)
	val chapters: StateFlow<RibaResult<List<RibaFulfilledChapter>>?> get() = _chapters.asStateFlow()

	init {
		if (!isDummy) {
			loadDetails()
		} else {
			_manga.value = RibaResult.Success(RibaManga.getDefault())
			_statistic.value = RibaResult.Success(RibaStatistic.getDefault())
			_cover.value = RibaResult.Success(RibaCover.getDefault())
			_authors.value = RibaResult.Success(listOf(RibaAuthor.getDefault()))
			_artists.value = RibaResult.Success(listOf(RibaAuthor.getDefault()))
			_tags.value = RibaResult.Success(listOf(RibaTag.getDefault()))
			_chapters.value = RibaResult.Success(listOf(RibaFulfilledChapter.getDefault()))
		}
	}

	private fun loadDetails(refresh: Boolean = false) = viewModelScope.launch(Dispatchers.IO) {
		Log.i(
			DexLogTag.DEBUG.tag, "${if (refresh) "Refreshing" else "Loading"} details for $mangaId"
		)

		val localManga =
			service.mangadex.manga.get(mangaId, forceInsert = refresh, tryDatabase = !refresh).also { _manga.emit(it) }
				.let { if (it is RibaResult.Success) it.value else return@launch }

		launch {
			followed.emit(service.mangadex.manga.checkFollowStatus(mangaId, refresh))
		}

		launch {
			_statistic.emit(service.mangadex.manga.getStatistic(mangaId))
		}

		launch {
			val response = service.mangadex.author.getStrictCollection(
				localManga.artistIds + localManga.authorIds.filter { it !in localManga.artistIds },
				forceInsert = refresh,
				tryDatabase = !refresh
			)

			val artistResolve = response.map { item -> item.filter { it.id in localManga.artistIds } }
			val authorResolve = response.map { item -> item.filter { it.id in localManga.authorIds } }

			_artists.emit(artistResolve)
			_authors.emit(authorResolve)
		}

		launch {
			if (localManga.coverId != null) {
				_cover.emit(
					service.mangadex.manga.getCover(
						localManga.coverId,
						forceInsert = refresh,
						tryDatabase = !refresh,
					)
				)
			}
		}

		launch {
			val resolve = service.mangadex.manga.database.getTagCollection(localManga.tagIds)

			if (resolve.size != localManga.tagIds.size) {
				val error = DexError(
					"Failed to resolve tags", "Expected ${localManga.tagIds.size} tags, but got only ${resolve.size}"
				)

				_tags.emit(RibaResult.Error(error))
			} else {
				_tags.emit(RibaResult.Success(resolve))
			}
		}

		launch { handleChapterLoad(coroutineContext, refresh) }
	}

	private suspend fun handleChapterLoad(context: CoroutineContext, refresh: Boolean) = withContext(context) {
		_areChaptersLoading.emit(true)

		val response = service.mangadex.chapter.getCollection(
			mangaId = mangaId,
			forceInsert = refresh,
			sort = Pair(DexChapterQueryOrderProperty.Chapter, DexQueryOrderValue.Descending),
			limit = 50,
			translatedLanguage = translatedLanguages.value,
			offset = offset.value,
		)

		launch {
			if (response is RibaResult.Success) {
				val size = response.value.data[mangaId]?.size
				val total = response.value.total

				if (size != null && size < total) offset.value = offset.value?.plus(size)
				else offset.value = null
			}
		}

		val flattened: RibaResult<List<RibaFulfilledChapter>> = response.map { it.data[mangaId] ?: emptyList() }.map {
			if (_chapters.value is RibaResult.Success) {
				(_chapters.value as RibaResult.Success<List<RibaFulfilledChapter>>).value + it
			} else it
		}

		_chapters.emit(flattened)
		_areChaptersLoading.emit(false)
	}

	private suspend fun handleDummyChapterLoad(context: CoroutineContext) = withContext(context) {
		_areChaptersLoading.emit(true)

		val chapters = mutableListOf<RibaFulfilledChapter>()
		for (i in 0..50) {
			chapters.add(RibaFulfilledChapter.getDefault())
		}

		// Since we can check whether it blocks the main or not like this.
		@Suppress("BlockingMethodInNonBlockingContext")
		Thread.sleep(10000)

		_chapters.emit(
			if (_chapters.value is RibaResult.Success) {
				RibaResult.Success(
					(_chapters.value as RibaResult.Success<List<RibaFulfilledChapter>>).value + chapters
				)
			} else RibaResult.Success(chapters)
		)

		launch {
			if (_chapters.value is RibaResult.Success) {
				val size = (_chapters.value as RibaResult.Success<List<RibaFulfilledChapter>>).value.size
				val total = 100

				if (size < total) offset.value = offset.value?.plus(size)
				else offset.value = null
			}
		}

		_areChaptersLoading.emit(false)
	}

	/**
	 * Returns true if the end is reached.
	 */
	fun startPagination(): Boolean {
		if (offset.value == null) return true

		return if (!isDummy) {
			viewModelScope.launch(Dispatchers.IO) { handleChapterLoad(coroutineContext, false) }
			false
		} else {
			viewModelScope.launch(Dispatchers.IO) { handleDummyChapterLoad(coroutineContext) }
			false
		}
	}

	fun refresh() = viewModelScope.launch(Dispatchers.IO) {
		_isRefreshing.emit(true)
		offset.emit(0)
		loadDetails(true).run { _isRefreshing.emit(false) }
	}

	companion object {
		fun Factory(service: RibaAPIService, mangaId: String, isDummy: Boolean) = object : ViewModelProvider.Factory {
			@Suppress("UNCHECKED_CAST")
			override fun <T : ViewModel> create(modelClass: Class<T>): T {
				return MangaDetailsViewModel(service, mangaId, isDummy) as T
			}
		}
	}
}

@Composable
@Preview(showBackground = true)
private fun DetailScreenPreview() {
	val state = RibaHostState.createDummy()

	RibaTheme {
		MangaDetailScreen(
			state,
			viewModel(
				factory = MangaDetailsViewModel.Factory(state.service, RibaManga.getDefault().id, true)
			)
		)
	}
}