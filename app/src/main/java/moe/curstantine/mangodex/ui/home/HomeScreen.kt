package moe.curstantine.mangodex.ui.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import moe.curstantine.mangodex.R
import moe.curstantine.mangodex.api.APIService
import moe.curstantine.mangodex.api.mangadex.models.DexEntityType
import moe.curstantine.mangodex.api.mangadex.models.DexMangaAttributes
import moe.curstantine.mangodex.nav.MangoNavigator
import moe.curstantine.mangodex.ui.components.common.FlexibleIndicator
import moe.curstantine.mangodex.ui.manga.MangaCard
import moe.curstantine.mangodex.ui.manga.MangaCardData
import moe.curstantine.mangodex.ui.mdlist.MDListCardData

@Composable
fun HomeScreen(mangoNavigator: MangoNavigator) {
    val seasonalManga = MutableLiveData<List<MangaCardData>>()
    val mdListData = MutableLiveData<List<MDListCardData>>()

    LaunchedEffect(Unit, block = {
        val seasonalList = APIService.mangadex.getMDList("7df1dabc-b1c5-4e8e-a757-de5a2a3d37e9")

        val seasonalIds = seasonalList.data.relationships
            .filter { relay -> relay.type == DexEntityType.Manga }
            .map { relay -> relay.id }

        val seasonalTitles = APIService.mangadex.getMangaList(seasonalIds)

        seasonalManga.value = seasonalTitles.data.map {
            MangaCardData(
                it.id,
                it.attributes.title.english
            )
        }
    })

    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Seasonal(seasonalManga)

//        RecentlyAdded()
    }
}

@Composable
private fun Seasonal(data: LiveData<List<MangaCardData>>) {
    val manga = data.observeAsState(listOf())

    Column(
        Modifier.padding(horizontal = 12.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {

        Text(
            stringResource(R.string.seasonal),
            style = MaterialTheme.typography.titleMedium
        )


        if (manga.value.isEmpty()) {
            FlexibleIndicator(height = 200.dp)
        } else {
            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                items(manga.value.size) { index ->
                    MangaCard(manga.value.elementAt(index)) { _ -> }
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