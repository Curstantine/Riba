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
import moe.curstantine.mangodex.api.mangadex.models.DexEntityType
import moe.curstantine.mangodex.api.mangadex.models.DexMangaCollection
import moe.curstantine.mangodex.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.mangodex.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.mangodex.api.mangodex.Result
import moe.curstantine.mangodex.nav.MangoNavigator
import moe.curstantine.mangodex.ui.manga.MangaCardRow

@Composable
fun HomeScreen(
    mangoNavigator: MangoNavigator,
    viewModel: HomeViewModel = viewModel(factory = HomeScreenViewModelFactory())
) {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        MangaCardRow(viewModel.getSeasonalTitles(), stringResource(R.string.seasonal))
        MangaCardRow(viewModel.getRecentlyAddedTitles(), stringResource(R.string.recently_added))
    }
}

class HomeViewModel : ViewModel() {
    private val seasonalTitles: MutableLiveData<Result<DexMangaCollection>> by lazy {
        MutableLiveData<Result<DexMangaCollection>>().also {
            loadSeasonalTitles()
        }
    }

    private val recentlyAddedTitles: MutableLiveData<Result<DexMangaCollection>> by lazy {
        MutableLiveData<Result<DexMangaCollection>>().also {
            loadRecentlyAddedTitles()
        }
    }

    fun getSeasonalTitles(): LiveData<Result<DexMangaCollection>> {
        return seasonalTitles
    }

    fun getRecentlyAddedTitles(): LiveData<Result<DexMangaCollection>> {
        return recentlyAddedTitles
    }

    private fun loadSeasonalTitles() {
        viewModelScope.launch(Dispatchers.IO) {
            val seasonalList = APIService.mangadex.getMDList(DexConstants.SEASONAL_LIST)

            if (seasonalList is Result.Error) {
                withContext(Dispatchers.Main) {
                    seasonalTitles.value = seasonalList
                }

                return@launch
            }

            if (seasonalList is Result.Success) {
                val seasonalManga = APIService.mangadex.getMangaList(
                    ids = seasonalList.data.data.relationships
                        .filter { relay -> relay.type == DexEntityType.Manga }
                        .map { relay -> relay.id },
                )

                withContext(Dispatchers.Main) {
                    seasonalTitles.value = seasonalManga
                }
            }
        }
    }

    private fun loadRecentlyAddedTitles() {
        viewModelScope.launch(Dispatchers.IO) {
            val recentlyAddedList = APIService.mangadex.getMangaList(
                sort = Pair(DexQueryOrderProperty.CreatedAt, DexQueryOrderValue.Descending)
            )

            withContext(Dispatchers.Main) {
                recentlyAddedTitles.value = recentlyAddedList
            }
        }
    }
}

class HomeScreenViewModelFactory : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        return HomeViewModel() as T
    }
}