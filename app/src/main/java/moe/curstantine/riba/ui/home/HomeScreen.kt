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
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.riba.RibaAPIService
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

    private fun loadSeasonal() {
        viewModelScope.launch(Dispatchers.IO) {
            val list = when (val list =
                service.mangadex.mdlist.get(DexConstants.SEASONAL_LIST, tryDatabase = true)) {
                is RibaResult.Success -> list.unwrap()!!
                is RibaResult.Error -> return@launch seasonal.postValue(list)
            }

            val titles = when (val collection =
                service.mangadex.manga.getStrictCollection(ids = list.titles)) {
                is RibaResult.Success -> collection.unwrap()!!
                is RibaResult.Error -> return@launch seasonal.postValue(collection)
            }

            return@launch seasonal.postValue(RibaResult.Success(titles.map {
                RibaFulFilledManga(
                    manga = it,
                    cover = it.coverId?.let { id -> service.mangadex.manga.getCover(id).unwrap() },
                    tags = null,
                    statistic = null,
                    authors = null,
                    artists = null,
                )
            }))
        }
    }

    private fun loadRecent() {
        viewModelScope.launch(Dispatchers.IO) {
            val recentlyAddedList = service.mangadex.manga.getCollection(
                includes = listOf(DexEntityType.CoverArt),
                sort = Pair(DexQueryOrderProperty.CreatedAt, DexQueryOrderValue.Descending),
            ).map {
                it.map { manga ->
                    RibaFulFilledManga(
                        manga = manga,
                        cover = manga.coverId?.let { id ->
                            service.mangadex.manga.getCover(id).unwrap()
                        },
                        tags = null,
                        statistic = null,
                        authors = null,
                        artists = null,
                    )
                }
            }

            return@launch recent.postValue(recentlyAddedList)
        }
    }
}