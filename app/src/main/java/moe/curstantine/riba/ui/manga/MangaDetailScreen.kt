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
import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.MaterialTheme.typography
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
import com.google.accompanist.swiperefresh.SwipeRefreshIndicator
import com.google.accompanist.swiperefresh.rememberSwipeRefreshState
import dev.jeziellago.compose.markdowntext.MarkdownText
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.R
import moe.curstantine.riba.api.mangadex.*
import moe.curstantine.riba.api.mangadex.models.DexChapterQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.riba.RibaAPIService
import moe.curstantine.riba.api.riba.RibaError
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.api.riba.models.*
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.common.components.FlexibleErrorReceiver
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

	val isLoading = remember(manga, statistic, cover) { manga == null && statistic == null && cover == null }
	val bubbledError = remember(manga, statistic, cover) {
		(manga?.exceptionOrNull() ?: statistic?.exceptionOrNull() ?: cover?.exceptionOrNull())
			?.let { DexError.tryHandle(it) }
	}

	SwipeRefresh(
		state = rememberSwipeRefreshState(isRefreshing),
		onRefresh = { viewModel.refresh() },
		indicator = { refreshState, trigger ->
			SwipeRefreshIndicator(
				state = refreshState,
				refreshTriggerDistance = trigger,
				contentColor = colorScheme.primary,
				backgroundColor = colorScheme.surface,
			)
		}
	) {
		if (isLoading) FlexibleIndicator()
		else if (bubbledError != null) FlexibleErrorReceiver(bubbledError)
		else {
			Scaffold(
				topBar = { ScreenTopBar(state.navigator, scrollBehavior) },
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
	val mutedOnBackground = colorScheme.onBackground.copy(alpha = 0.75F)

	val chapterRes by viewModel.chapters.collectAsState()
	val areChaptersLoading by viewModel.areChaptersLoading.collectAsState()

	val chapters = remember(chapterRes) { chapterRes?.getOrNull() }
	var chapterListEndReached by remember { mutableStateOf(false) }
	var filtersApplied by remember { mutableStateOf(false) }

	LazyColumn(Modifier.nestedScroll(scrollBehavior.nestedScrollConnection)) {
		item { MangaDetailHeader(state, paddingValues, viewModel) }

		item {
			AnimatedVisibility(visible = chapterRes?.isFailure == true) {
				Box(
					contentAlignment = Alignment.Center,
					modifier = Modifier
						.background(colorScheme.error)
						.heightIn(42.dp)
						.fillMaxWidth()
						.padding(horizontal = 16.dp, vertical = 4.dp)
				) {
					Text(
						text = chapterRes!!.exceptionOrNull()!!.message!!,
						style = typography.bodyMedium,
						color = colorScheme.onError,
					)
				}
			}
		}

		if (chapters != null) {
			if (filtersApplied || chapters.isNotEmpty()) {
				item {
					Row(
						modifier = Modifier
							.fillMaxWidth()
							.height(64.dp)
							.padding(horizontal = 16.dp),
						verticalAlignment = Alignment.CenterVertically
					) {
						Spacer(Modifier.weight(1F))

						IconButton(onClick = { filtersApplied = !filtersApplied }) {
							Icon(
								imageVector = Icons.Rounded.FilterList,
								tint = colorScheme.primary,
								contentDescription = stringResource(R.string.filter)
							)
						}
					}
				}
			}

			if (chapters.isEmpty()) {
				item {
					OutlinedCard(
						modifier = Modifier
							.fillMaxWidth()
							.height(128.dp)
							.padding(16.dp)
					) {
						Column(
							modifier = Modifier.fillMaxSize(),
							horizontalAlignment = Alignment.CenterHorizontally,
							verticalArrangement = Arrangement.Center
						) {
							Text(
								text = stringResource(R.string.no_chapters),
								style = typography.titleMedium,
								color = colorScheme.onBackground,
							)

							AnimatedVisibility(filtersApplied) {
								Text(
									text = stringResource(R.string.tips_turn_off_chapter_filter),
									style = typography.bodySmall,
									color = mutedOnBackground,
								)
							}
						}
					}
				}
			}

			items(chapters) { ChapterItem(it) }

			if (chapters.isNotEmpty()) {
				item {
					LaunchedEffect(true) {
						if (!chapterListEndReached) chapterListEndReached = viewModel.startPagination()
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
	val mutedOnBackground = colorScheme.onBackground.copy(alpha = 0.75F)

	val clipboardManager = LocalClipboardManager.current
	val preferredLanguages = remember { hostState.settings.getLanguagePreference() }

	val notAvailable = stringResource(R.string.not_available)
	val shareMessage = stringResource(R.string.copied_to_clipboard, stringResource(R.string.link).lowercase())

	val currentUser by hostState.service.mangadex.user.currentUser.collectAsState()
	val mangaResult by viewModel.manga.collectAsState()
	val statResult by viewModel.statistic.collectAsState()
	val followedResult by viewModel.followed.collectAsState()
	val authorResult by viewModel.authors.collectAsState()
	val artistResult by viewModel.artists.collectAsState()
	val coverResult by viewModel.cover.collectAsState()
	val tagResult by viewModel.tags.collectAsState()

	val manga = remember(mangaResult) { mangaResult?.getOrNull() }
	val stats = remember(statResult) { statResult?.getOrNull() }
	val followed = remember(followedResult) { followedResult?.getOrNull() }
	val authors = remember(authorResult) { authorResult?.getOrNull() }
	val artists = remember(artistResult) { artistResult?.getOrNull() }
	val cover = remember(coverResult) { coverResult?.getOrNull() }
	val tags = remember(tagResult) { tagResult?.getOrNull() }

	val localizedTitle = remember(manga) {
		manga?.title?.runCatching { getPreferredLocalizedValue(preferredLanguages) }?.getOrNull() ?: notAvailable
	}
	val localizedAuthors = remember(artists) { authors?.map { it.name ?: notAvailable } ?: emptyList() }
	val localizedArtists = remember(artists) { artists?.map { it.name ?: notAvailable } ?: emptyList() }
	val artistAuthors = remember(localizedAuthors, localizedArtists) {
		val filteredArtists = localizedArtists.filter { it !in localizedAuthors }
		(localizedAuthors + filteredArtists).ifEmpty { null }
	}

	val localizedTags = remember(tags) {
		tags?.runCatching {
			map { tag ->
				if (tag.name != null) tag.name.getPreferredLocalizedValue(preferredLanguages)
				else notAvailable
			}
		}?.getOrNull() ?: emptyList()
	}

	val localizedDescription = remember(mangaResult) {
		val localManga = mangaResult?.getOrNull()

		localManga?.description?.runCatching {
			DexUtils.getPreferredLocalizedValue(preferredLanguages, localManga.description)
		}?.getOrNull()
	}

	val isMoreEnabled = remember(mangaResult, tagResult) {
		if (mangaResult == null || mangaResult?.isFailure == true) false else {
			val privateTags = tagResult?.getOrNull()

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
		Row(
			modifier = Modifier.heightIn(220.dp), horizontalArrangement = Arrangement.spacedBy(16.dp)
		) {
			MangaCover(
				cover = cover,
				maxHeight = 220.dp,
				coverSize = DexCoverSize.Medium,
			)

			Column(
				modifier = Modifier.heightIn(220.dp),
				verticalArrangement = Arrangement.SpaceBetween,
			) {
				Column(Modifier.padding(bottom = 16.dp)) {
					Text(
						text = localizedTitle,
						style = (when (localizedTitle.length) {
							in 0..50 -> typography.headlineSmall
							in 51..75 -> typography.titleLarge
							else -> typography.titleMedium
						}).copy(fontWeight = FontWeight.Bold, fontFamily = Rubik)
					)
					Text(
						text = artistAuthors?.joinToString(", ") ?: stringResource(R.string.no_author_artists),
						style = typography.labelMedium.copy(color = mutedOnBackground)
					)
				}

				if (stats != null) {
					FlowRow(
						modifier = Modifier.padding(bottom = 8.dp),
						mainAxisSpacing = 12.dp,
					) {
						val textStyle = typography.labelLarge.copy(fontWeight = FontWeight.Medium, fontFamily = Rubik)

						Row(
							verticalAlignment = Alignment.CenterVertically,
							horizontalArrangement = Arrangement.spacedBy(2.dp)
						) {
							Icon(
								tint = colorScheme.primary,
								imageVector = Icons.Rounded.Star,
								contentDescription = stringResource(R.string.rating),
								modifier = Modifier.size(22.dp)
							)
							Text(
								text = ((stats.bayesian * 100.0).roundToInt() / 100.0).toString(),
								style = textStyle,
								color = colorScheme.primary
							)
						}

						Row(
							verticalAlignment = Alignment.CenterVertically,
							horizontalArrangement = Arrangement.spacedBy(2.dp)
						) {
							Icon(
								tint = mutedOnBackground,
								imageVector = Icons.Rounded.Bookmark,
								contentDescription = stringResource(R.string.follows),
								modifier = Modifier.size(22.dp)
							)
							Text(
								text = stats.follows.toString(),
								style = textStyle,
								color = mutedOnBackground
							)
						}

						// TODO: Add total views
						Row(
							verticalAlignment = Alignment.CenterVertically,
							horizontalArrangement = Arrangement.spacedBy(2.dp)
						) {
							Icon(
								tint = mutedOnBackground.copy(alpha = 0.35F),
								imageVector = Icons.Rounded.Visibility,
								contentDescription = stringResource(R.string.views),
								modifier = Modifier.size(22.dp)
							)
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
			modifier = Modifier.padding(top = 16.dp, bottom = 24.dp),
			horizontalArrangement = Arrangement.spacedBy(4.dp)
		) {
			if (currentUser != null && followed != null) {
				OutlinedIconToggleButton(
					checked = followed,
					onCheckedChange = {
						viewModel.mutateStatus(
							isFollowing = it,
							onFail = { error -> hostState.snackbarHost.showSnackbar(error.message) }
						)
					},
					content = {
						Icon(Icons.Rounded.BookmarkAdd, contentDescription = stringResource(R.string.add_to_library))
					},
				)
			}

			OutlinedIconToggleButton(checked = hasTrackers, onCheckedChange = { hasTrackers = it }, content = {
				Icon(Icons.Rounded.Sync, contentDescription = stringResource(R.string.trackers))
			})

			OutlinedIconButton(
				onClick = {
					viewModel.viewModelScope.launch {
						clipboardManager.setText(AnnotatedString(DexUtils.getMangaUrl(manga!!.id)))
						hostState.snackbarHost.showSnackbar(message = shareMessage)
					}
				},
				content = { Icon(Icons.Rounded.Share, contentDescription = stringResource(R.string.share)) },
			)

			Button(onClick = { /*TODO*/ }, modifier = Modifier.fillMaxWidth()) {
				Icon(Icons.Rounded.Book, contentDescription = stringResource(R.string.start_reading))
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
						style = typography.titleSmall.copy(
							color = colorScheme.onBackground.copy(alpha = 0.85F),
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

	val chapterName = remember { chap.chapter.getNormalizedTitle() }
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
						style = typography.bodySmall
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
		style = typography.titleSmall.copy(
			color = colorScheme.onBackground.copy(alpha = 0.85F),
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
	TopAppBar(
		title = {},
		scrollBehavior = scrollBehavior,
		colors = TopAppBarDefaults.smallTopAppBarColors(
			scrolledContainerColor = Color.Transparent,
			containerColor = Color.Transparent,
			titleContentColor = Color.Transparent
		),
		navigationIcon = {
			IconButton(
				onClick = { ribaNavigator.popBackStack() },
				content = { Icon(Icons.Rounded.ArrowBack, stringResource(R.string.back)) },
			)
		},
		actions = {
			// TODO: Handle more
			IconButton(onClick = { }, content = { Icon(Icons.Rounded.MoreVert, stringResource(R.string.more)) })
		}
	)


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

	private val _followed = MutableStateFlow<Result<Boolean>?>(null)
	val followed: StateFlow<Result<Boolean>?> get() = _followed.asStateFlow()

	private val _manga = MutableStateFlow<Result<RibaManga>?>(null)
	val manga: StateFlow<Result<RibaManga>?> get() = _manga.asStateFlow()

	private val _statistic = MutableStateFlow<Result<RibaStatistic>?>(null)
	val statistic: StateFlow<Result<RibaStatistic>?> get() = _statistic.asStateFlow()

	private val _cover = MutableStateFlow<Result<RibaCover>?>(null)
	val cover: StateFlow<Result<RibaCover>?> get() = _cover.asStateFlow()

	private val _authors = MutableStateFlow<Result<List<RibaAuthor>>?>(null)
	val authors: StateFlow<Result<List<RibaAuthor>>?> get() = _authors.asStateFlow()

	private val _artists = MutableStateFlow<Result<List<RibaAuthor>>?>(null)
	val artists: StateFlow<Result<List<RibaAuthor>>?> get() = _artists.asStateFlow()

	private val _tags = MutableStateFlow<Result<List<RibaTag>>?>(null)
	val tags: StateFlow<Result<List<RibaTag>>?> get() = _tags.asStateFlow()

	private val _chapters = MutableStateFlow<Result<List<RibaFulfilledChapter>>?>(null)
	val chapters: StateFlow<Result<List<RibaFulfilledChapter>>?> get() = _chapters.asStateFlow()

	init {
		if (!isDummy) {
			loadDetails()
		} else {
			_manga.value = Result.success(
				RibaManga.getDefault().copy(title = mapOf(Pair(DexLocale.English, "Pe".repeat(26))))
			)
			_statistic.value = Result.success(RibaStatistic.getDefault())
			_cover.value = Result.success(RibaCover.getDefault())
			_authors.value = Result.success(listOf(RibaAuthor.getDefault()))
			_artists.value = Result.success(listOf(RibaAuthor.getDefault()))
			_tags.value = Result.success(listOf(RibaTag.getDefault()))
			_chapters.value = Result.success(
				listOf(
//				RibaFulfilledChapter.getDefault()
				)
			)
		}
	}

	// TODO: Handle offline errors.
	private fun loadDetails(refresh: Boolean = false) = viewModelScope.launch(Dispatchers.IO) {
		Log.i(
			DexLogTag.DEBUG.tagName, "${if (refresh) "Refreshing" else "Loading"} details for $mangaId"
		)

		val localManga = service.mangadex.manga.runCatching {
			get(Dispatchers.IO, mangaId, forceInsert = refresh, tryDatabase = !refresh)
		}
			.onFailure { _manga.emit(Result.failure(DexError.tryHandle(it))) }
			.also { if (it.isFailure) return@launch else it }
			.getOrThrow()

		launch {
			service.mangadex.manga.runCatching { checkFollowStatus(Dispatchers.IO, mangaId, refresh) }
				.onFailure { _followed.emit(Result.failure(DexError.tryHandle(it))) }
				.onSuccess { _followed.emit(Result.success(it)) }
		}

		launch {
			service.mangadex.manga.runCatching { getStatistic(Dispatchers.IO, mangaId) }
				.onFailure { _statistic.emit(Result.failure(DexError.tryHandle(it))) }
				.onSuccess { _statistic.emit(Result.success(it)) }
		}

		launch {
			service.mangadex.author.runCatching {
				getStrictCollection(
					Dispatchers.IO,
					localManga.artistIds + localManga.authorIds.filter { it !in localManga.artistIds },
					forceInsert = refresh,
					tryDatabase = !refresh
				)
			}.onSuccess { response ->
				val artistResolve = response.filter { it.id in localManga.artistIds }
				val authorResolve = response.filter { it.id in localManga.authorIds }

				_artists.emit(Result.success(artistResolve))
				_authors.emit(Result.success(authorResolve))
			}.onFailure {
				val error = DexError.tryHandle(it)

				_artists.emit(Result.failure(error))
				_authors.emit(Result.failure(error))
			}
		}

		if (localManga.coverId != null) {
			launch {
				service.mangadex.manga.runCatching {
					getCover(Dispatchers.IO, localManga.coverId, forceInsert = refresh, tryDatabase = !refresh)
				}
					.onFailure { _cover.emit(Result.failure(DexError.tryHandle(it))) }
					.onSuccess { _cover.emit(Result.success(it)) }
			}
		}

		launch {
			service.mangadex.manga.database.runCatching { getTagCollection(localManga.tagIds) }
				.onFailure { _tags.emit(Result.failure(DexError.tryHandle(it))) }
				.onSuccess {
					if (it.size == localManga.tagIds.size) _tags.emit(Result.success(it)) else {
						_tags.emit(
							Result.failure(
								DexError.MissingTags.setAdditional(
									"Expected ${localManga.tagIds.size} tags, but got only ${it.size}"
								)
							)
						)
					}
				}
		}

		launch { handleChapterLoad(coroutineContext, refresh) }

		if (refresh) _isRefreshing.emit(false)
	}

	private suspend fun handleChapterLoad(context: CoroutineContext, refresh: Boolean) = withContext(context) {
		_areChaptersLoading.emit(true)

		service.mangadex.chapter.runCatching {
			getCollection(
				mangaId = mangaId,
				forceInsert = refresh,
				sort = Pair(DexChapterQueryOrderProperty.Chapter, DexQueryOrderValue.Descending),
				limit = 50,
				translatedLanguage = translatedLanguages.value,
				offset = offset.value,
			)
		}
			.onFailure { _chapters.emit(Result.failure(DexError.tryHandle(it))) }
			.onSuccess { response ->
				launch {
					val size = response.data[mangaId]?.size
					val total = response.total

					if (size != null && size < total) offset.value = offset.value?.plus(size)
					else offset.value = null
				}

				val flattened = (response.data[mangaId] ?: emptyList()).let {
					if (_chapters.value?.isSuccess == true && !refresh) _chapters.value!!.getOrThrow() + it
					else it
				}
				_chapters.emit(Result.success(flattened))
			}

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
			Result.success(
				if (_chapters.value?.isSuccess == true) _chapters.value!!.getOrThrow() + chapters
				else chapters
			)
		)

		launch {
			if (_chapters.value?.isSuccess == true) {
				val size = _chapters.value!!.getOrThrow().size
				val total = 100

				if (size < total) offset.value = offset.value?.plus(size)
				else offset.value = null
			}
		}

		_areChaptersLoading.emit(false)
	}

	fun mutateStatus(
		isFollowing: Boolean,
		onFail: (suspend CoroutineScope.(RibaError) -> Unit)? = null
	) = viewModelScope.launch {
		service.mangadex.manga.runCatching {
			if (isFollowing) follow(Dispatchers.IO, mangaId)
			else unfollow(Dispatchers.IO, mangaId)
		}
			.onSuccess { _followed.emit(Result.success(isFollowing)) }
			.onFailure {
				val error = DexError.tryHandle(it)
				_followed.emit(Result.failure(error))
				launch { onFail?.invoke(this, error) }
			}
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

		if (!isDummy) {
			offset.emit(0)
			loadDetails(true)
		} else {
			// Since we can check whether it blocks the main or not like this.
			@Suppress("BlockingMethodInNonBlockingContext")
			Thread.sleep(10000)
			_isRefreshing.emit(false)
		}
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