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
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.RibaHostState
import moe.curstantine.riba.api.APIService
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.mangadex.models.toFulfilledRibaManga
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaFulFilledManga
import moe.curstantine.riba.ui.manga.MangaCardRow

@Composable
fun HomeScreen(
    state: RibaHostState,
    paddingValues: State<PaddingValues>,
    viewModel: HomeViewModel
) {
    Box(modifier = Modifier.padding(paddingValues.value)) {
        Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
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
            val localList = APIService.database.list().get(DexConstants.SEASONAL_LIST)
            val seasonalIds: List<String> = if (localList != null) localList.titles
            else {
                val seasonalList = APIService.mangadex.getMDList(DexConstants.SEASONAL_LIST)
                    .map {
                        it.data.relationships
                            .filter { rel -> rel.type == DexEntityType.Manga }
                            .map { rel -> rel.id }
                    }
                if (seasonalList is RibaResult.Success) seasonalList.value else {
                    return@launch seasonal.postValue(seasonalList as RibaResult.Error)
                }
            }

            val localTitles = APIService.database.manga().get(seasonalIds).map {
                RibaFulFilledManga(
                    manga = it,
                    cover = it.coverId?.let { id -> APIService.database.cover().get(id) },
                    tags = null,
                    authors = null,
                    artists = null,
                    statistic = null,
                )
            }
            if (localTitles.size == seasonalIds.size) {
                return@launch seasonal.postValue(RibaResult.Success(localTitles))
            }

            val serverTitles = APIService.mangadex.getManga(
                ids = seasonalIds,
                limit = seasonalIds.size,
                includes = listOf(DexEntityType.CoverArt),
            ).map { it.data.map { manga -> manga.toFulfilledRibaManga() } }

            return@launch seasonal.postValue(serverTitles)
        }
    }

    private fun loadRecent() {
        viewModelScope.launch(Dispatchers.IO) {
            val recentlyAddedList = APIService.mangadex.getManga(
                includes = listOf(DexEntityType.CoverArt),
                sort = Pair(DexQueryOrderProperty.CreatedAt, DexQueryOrderValue.Descending),
            ).map { it.data.map { manga -> manga.toFulfilledRibaManga() } }

            return@launch recent.postValue(recentlyAddedList)
        }
    }
}