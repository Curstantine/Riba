package moe.curstantine.mangodex.ui.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.*
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.mangodex.R
import moe.curstantine.mangodex.api.APIService
import moe.curstantine.mangodex.api.mangadex.DexConstants
import moe.curstantine.mangodex.api.mangadex.models.*
import moe.curstantine.mangodex.api.mangodex.Result
import moe.curstantine.mangodex.api.mangodex.models.MangoFulfilledManga
import moe.curstantine.mangodex.nav.MangoNavigator
import moe.curstantine.mangodex.ui.manga.MangaCardRow

@Composable
fun HomeScreen(
    mangoNavigator: MangoNavigator,
    viewModel: HomeViewModel = viewModel(factory = HomeViewModel.Companion.Factory)
) {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        MangaCardRow(viewModel.getSeasonal(), stringResource(R.string.seasonal))
        MangaCardRow(viewModel.getRecentlyAdded(), stringResource(R.string.recently_added))
    }
}

class HomeViewModel : ViewModel() {
    fun getSeasonal(): LiveData<Result<List<MangoFulfilledManga>>> = seasonalTitles
    fun getRecentlyAdded(): LiveData<Result<List<MangoFulfilledManga>>> = recentlyAddedTitles

    private val seasonalTitles: MutableLiveData<Result<List<MangoFulfilledManga>>> by lazy {
        MutableLiveData<Result<List<MangoFulfilledManga>>>().also {
            loadSeasonalTitles()
        }
    }

    private val recentlyAddedTitles: MutableLiveData<Result<List<MangoFulfilledManga>>> by lazy {
        MutableLiveData<Result<List<MangoFulfilledManga>>>().also {
            loadRecentlyAddedTitles()
        }
    }

    private fun loadSeasonalTitles() {
        viewModelScope.launch(Dispatchers.IO) {
            lateinit var seasonalTitleIds: List<String>
            lateinit var seasonalManga: Result<List<MangoFulfilledManga>>

            val localSeasonalList = APIService.database.list().get(DexConstants.SEASONAL_LIST)
            if (localSeasonalList != null) {
                seasonalTitleIds = localSeasonalList.titles
            } else {
                val seasonalList = APIService.mangadex.getMDList(DexConstants.SEASONAL_LIST)

                if (seasonalList is Result.Success) {
                    seasonalTitleIds = seasonalList.data.data.relationships
                        .filter { relay -> relay.type == DexEntityType.Manga }
                        .map { relay -> relay.id }
                }

                if (seasonalList is Result.Error) {
                    withContext(Dispatchers.Main) {
                        seasonalTitles.value = seasonalList
                    }

                    return@launch
                }
            }

            val localSeasonalManga = APIService.database.manga().get(seasonalTitleIds)
            if (localSeasonalManga.isNotEmpty()) {
                seasonalManga = Result.Success(localSeasonalManga.map {
                    MangoFulfilledManga(
                        manga = it,
                        cover = it.coverId?.let { coverId ->
                            APIService.database.cover().get(coverId)
                        },
                        authors = null,
                        artists = null,
                    )
                })
            } else {
                val serverSeasonalManga = APIService.mangadex.getMangaList(
                    ids = seasonalTitleIds,
                    includes = listOf(DexEntityType.CoverArt)
                )

                if (serverSeasonalManga is Result.Success) {
                    seasonalManga = Result.Success(serverSeasonalManga.data.data.map { manga ->
                        MangoFulfilledManga(
                            manga = manga.toMangoManga(),
                            cover = manga.relationships
                                .firstOrNull { relay -> relay.type == DexEntityType.CoverArt }
                                ?.let { (it as DexRelatedCover).toMangoCover() },
                            authors = null,
                            artists = null,
                        )
                    })
                }
            }

            withContext(Dispatchers.Main) {
                seasonalTitles.value = seasonalManga
            }
        }
    }

    private fun loadRecentlyAddedTitles() {
        viewModelScope.launch(Dispatchers.IO) {
            val recentlyAddedList = APIService.mangadex.getMangaList(
                sort = Pair(DexQueryOrderProperty.CreatedAt, DexQueryOrderValue.Descending),
                includes = listOf(DexEntityType.CoverArt)
            )

            withContext(Dispatchers.Main) {
                if (recentlyAddedList is Result.Success) {
                    val titles = recentlyAddedList.data.data.map { manga ->
                        MangoFulfilledManga(
                            manga = manga.toMangoManga(),
                            cover = manga.relationships
                                .firstOrNull { relay -> relay.type == DexEntityType.CoverArt }
                                ?.let { (it as DexRelatedCover).toMangoCover() },
                            authors = null,
                            artists = null,
                        )
                    }

                    recentlyAddedTitles.value = Result.Success(titles)
                } else {
                    recentlyAddedTitles.value = recentlyAddedList as Result.Error
                }
            }
        }
    }

    companion object {
        object Factory : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return HomeViewModel() as T
            }
        }
    }
}

