package moe.curstantine.riba.ui.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.api.APIService
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.mangadex.models.DexRelatedCover
import moe.curstantine.riba.api.mangadex.models.toMangoManga
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaFulFilledManga
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.manga.MangaCardRow

@Composable
fun HomeScreen(
    ribaNavigator: RibaNavigator,
    paddingValues: State<PaddingValues>,
    viewModel: HomeViewModel
) {
    Box(modifier = Modifier.padding(paddingValues.value)) {
        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
            MangaCardRow(ribaNavigator, viewModel.getSeasonal(), stringResource(R.string.seasonal))
            MangaCardRow(
                ribaNavigator,
                viewModel.getRecent(),
                stringResource(R.string.recently_added)
            )
        }
    }
}

class HomeViewModel : ViewModel() {
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

    private fun loadSeasonal() {
        viewModelScope.launch(Dispatchers.IO) {
            lateinit var seasonalTitleIds: List<String>

            val localSeasonalList = APIService.database.list().get(DexConstants.SEASONAL_LIST)
            if (localSeasonalList != null) {
                seasonalTitleIds = localSeasonalList.titles
            } else {
                val seasonalList = APIService.mangadex.getMDList(DexConstants.SEASONAL_LIST)

                if (seasonalList is RibaResult.Success) {
                    seasonalTitleIds = seasonalList.data.data.relationships
                        .filter { relay -> relay.type == DexEntityType.Manga }
                        .map { relay -> relay.id }
                } else if (seasonalList is RibaResult.Error) {
                    return@launch seasonal.postValue(seasonalList)
                }
            }

            val localSeasonalManga = APIService.database.manga().get(seasonalTitleIds)
            if (localSeasonalManga.isNotEmpty()) {
                return@launch seasonal.postValue(
                    RibaResult.Success(localSeasonalManga.map {
                        RibaFulFilledManga(
                            manga = it,
                            cover = it.coverId?.let { coverId ->
                                APIService.database.cover().get(coverId)
                            },
                            authors = null,
                            artists = null,
                        )
                    })
                )
            }

            val serverSeasonalManga = APIService.mangadex.getManga(
                ids = seasonalTitleIds,
                includes = listOf(DexEntityType.CoverArt),
                limit = seasonalTitleIds.size
            )
            if (serverSeasonalManga is RibaResult.Success) {
                return@launch seasonal.postValue(
                    RibaResult.Success(serverSeasonalManga.data.data.map { manga ->
                        RibaFulFilledManga(
                            manga = manga.toMangoManga(),
                            cover = manga.relationships
                                .firstOrNull { relay -> relay.type == DexEntityType.CoverArt }
                                ?.let { (it as DexRelatedCover).toRibaCover(manga.id) },
                            authors = null,
                            artists = null,
                        )
                    })
                )
            } else if (serverSeasonalManga is RibaResult.Error) {
                return@launch seasonal.postValue(serverSeasonalManga)
            }
        }
    }

    private fun loadRecent() {
        viewModelScope.launch(Dispatchers.IO) {
            val recentlyAddedList = APIService.mangadex.getManga(
                sort = Pair(DexQueryOrderProperty.CreatedAt, DexQueryOrderValue.Descending),
                includes = listOf(DexEntityType.CoverArt)
            )

            if (recentlyAddedList is RibaResult.Success) {
                return@launch recent.postValue(
                    RibaResult.Success(recentlyAddedList.data.data.map { manga ->
                        RibaFulFilledManga(
                            manga = manga.toMangoManga(),
                            cover = manga.relationships
                                .firstOrNull { relay -> relay.type == DexEntityType.CoverArt }
                                ?.let { (it as DexRelatedCover).toRibaCover(manga.id) },
                            authors = null,
                            artists = null,
                        )
                    })
                )
            } else if (recentlyAddedList is RibaResult.Error) {
                return@launch recent.postValue(recentlyAddedList)
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