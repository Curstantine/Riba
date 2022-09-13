package moe.curstantine.riba.ui.home

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
import moe.curstantine.riba.R
import moe.curstantine.riba.api.APIService
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.models.*
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaFulfilledManga
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.manga.MangaCardRow

@Composable
fun HomeScreen(
    ribaNavigator: RibaNavigator,
    viewModel: HomeViewModel = viewModel(factory = HomeViewModel.Companion.Factory)
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        MangaCardRow(ribaNavigator, viewModel.getSeasonal(), stringResource(R.string.seasonal))
        MangaCardRow(ribaNavigator, viewModel.getRecent(), stringResource(R.string.recently_added))
    }
}

class HomeViewModel : ViewModel() {
    fun getSeasonal(): LiveData<RibaResult<List<RibaFulfilledManga>>> = seasonal
    fun getRecent(): LiveData<RibaResult<List<RibaFulfilledManga>>> = recent

    private val seasonal: MutableLiveData<RibaResult<List<RibaFulfilledManga>>> by lazy {
        MutableLiveData<RibaResult<List<RibaFulfilledManga>>>().also {
            loadSeasonal()
        }
    }

    private val recent: MutableLiveData<RibaResult<List<RibaFulfilledManga>>> by lazy {
        MutableLiveData<RibaResult<List<RibaFulfilledManga>>>().also {
            loadRecent()
        }
    }

    private fun loadSeasonal() {
        viewModelScope.launch(Dispatchers.IO) {
            lateinit var seasonalTitleIds: List<String>
            lateinit var seasonalManga: RibaResult<List<RibaFulfilledManga>>

            val localSeasonalList = APIService.database.list().get(DexConstants.SEASONAL_LIST)
            if (localSeasonalList != null) {
                seasonalTitleIds = localSeasonalList.titles
            } else {
                val seasonalList = APIService.mangadex.getMDList(DexConstants.SEASONAL_LIST)

                if (seasonalList is RibaResult.Success) {
                    seasonalTitleIds = seasonalList.data.data.relationships
                        .filter { relay -> relay.type == DexEntityType.Manga }
                        .map { relay -> relay.id }
                }

                if (seasonalList is RibaResult.Error) {
                    withContext(Dispatchers.Main) {
                        seasonal.value = seasonalList
                    }

                    return@launch
                }
            }

            val localSeasonalManga = APIService.database.manga().get(seasonalTitleIds)
            if (localSeasonalManga.isNotEmpty()) {
                seasonalManga = RibaResult.Success(localSeasonalManga.map {
                    RibaFulfilledManga(
                        manga = it,
                        cover = it.coverId?.let { coverId ->
                            APIService.database.cover().get(coverId)
                        },
                        authors = null,
                        artists = null,
                    )
                })
            } else {
                val serverSeasonalManga = APIService.mangadex.getManga(
                    ids = seasonalTitleIds,
                    includes = listOf(DexEntityType.CoverArt),
                    limit = seasonalTitleIds.size
                )

                if (serverSeasonalManga is RibaResult.Success) {
                    seasonalManga = RibaResult.Success(serverSeasonalManga.data.data.map { manga ->
                        RibaFulfilledManga(
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
                seasonal.value = seasonalManga
            }
        }
    }

    private fun loadRecent() {
        viewModelScope.launch(Dispatchers.IO) {
            val recentlyAddedList = APIService.mangadex.getManga(
                sort = Pair(DexQueryOrderProperty.CreatedAt, DexQueryOrderValue.Descending),
                includes = listOf(DexEntityType.CoverArt)
            )

            withContext(Dispatchers.Main) {
                if (recentlyAddedList is RibaResult.Success) {
                    val titles = recentlyAddedList.data.data.map { manga ->
                        RibaFulfilledManga(
                            manga = manga.toMangoManga(),
                            cover = manga.relationships
                                .firstOrNull { relay -> relay.type == DexEntityType.CoverArt }
                                ?.let { (it as DexRelatedCover).toMangoCover() },
                            authors = null,
                            artists = null,
                        )
                    }

                    recent.value = RibaResult.Success(titles)
                } else {
                    recent.value = recentlyAddedList as RibaResult.Error
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

