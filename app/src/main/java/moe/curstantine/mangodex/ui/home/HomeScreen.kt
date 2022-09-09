package moe.curstantine.mangodex.ui.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
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
import moe.curstantine.mangodex.api.mangadex.DexInternalError
import moe.curstantine.mangodex.api.mangadex.models.DexEntityType
import moe.curstantine.mangodex.api.mangadex.models.DexMangaCollection
import moe.curstantine.mangodex.api.mangodex.Result
import moe.curstantine.mangodex.nav.MangoNavigator
import moe.curstantine.mangodex.ui.common.components.FlexibleIndicator
import moe.curstantine.mangodex.ui.common.pages.CenteredErrorPage
import moe.curstantine.mangodex.ui.manga.MangaCard
import retrofit2.HttpException

@Composable
fun HomeScreen(
    mangoNavigator: MangoNavigator,
    viewModel: HomeViewModel = viewModel(factory = HomeScreenViewModelFactory())
) {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Seasonal(viewModel.getSeasonalTitles())
    }

}

@Composable
private fun Seasonal(data: LiveData<Result<DexMangaCollection>>) {
    val result by data.observeAsState()

    Column(
        Modifier.padding(horizontal = 12.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {

        Text(
            stringResource(R.string.seasonal),
            style = MaterialTheme.typography.titleMedium
        )

        if (result == null) {
            FlexibleIndicator(height = 210.dp)
        }

        if (result is Result.Error) {
            CenteredErrorPage(internalError = (result as Result.Error).error)
        }

        if (result is Result.Success) {
            val mangaList = (result as Result.Success).data.data

            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                items(mangaList.size) { index ->
                    MangaCard(mangaList.elementAt(index).attributes, onClick = {})
                }
            }
        }
    }
}

@Composable
private fun RecentlyAdded() {
    Column(
        Modifier.padding(horizontal = 12.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {

        Text(
            stringResource(R.string.recently_added),
            style = MaterialTheme.typography.titleMedium
        )

        LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
//            items(mangaData.size) { index ->
//                MangaCard(mangaData.elementAt(index)) { _ -> }
//            }
        }
    }
}

class HomeViewModel : ViewModel() {
    private val seasonalTitles: MutableLiveData<Result<DexMangaCollection>> by lazy {
        MutableLiveData<Result<DexMangaCollection>>().also {
            loadSeasonalTitles()
        }
    }

    private fun loadSeasonalTitles() {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                val seasonalList = APIService.mangadex.getMDList(DexConstants.seasonalList)
                val seasonalIds = seasonalList.data.relationships
                    .filter { relay -> relay.type == DexEntityType.Manga }
                    .map { relay -> relay.id }

                withContext(Dispatchers.Main) {
                    seasonalTitles.value =
                        Result.Success(APIService.mangadex.getMangaList(seasonalIds))
                }
            } catch (e: HttpException) {
                withContext(Dispatchers.Main) {
                    seasonalTitles.value = Result.Error(DexInternalError.fromHTTP(e.code()))
                }
            }
        }
    }

    fun getSeasonalTitles(): LiveData<Result<DexMangaCollection>> {
        return seasonalTitles
    }
}

class HomeScreenViewModelFactory() : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        return HomeViewModel() as T
    }
}