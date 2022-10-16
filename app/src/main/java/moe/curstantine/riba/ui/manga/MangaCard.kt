package moe.curstantine.riba.ui.manga

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import moe.curstantine.riba.R
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaFulFilledManga
import moe.curstantine.riba.api.riba.models.RibaManga
import moe.curstantine.riba.nav.RibaRoute
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.common.components.FlexibleErrorReceiver
import moe.curstantine.riba.ui.common.components.FlexibleIndicator

@Composable
fun MangaCard(manga: RibaManga, cover: RibaCover?, onClick: (RibaManga) -> Unit) {
    Column(
        verticalArrangement = Arrangement.spacedBy(4.dp),
        modifier = Modifier
            .width(120.dp)
            .height(250.dp),
    ) {
        MangaCover(cover, onClick = { onClick(manga) })
        Text(
            text = manga.title ?: stringResource(R.string.no_title),
            maxLines = 2,
            style = MaterialTheme.typography.bodySmall,
            overflow = TextOverflow.Ellipsis
        )
    }
}

@Composable
fun MangaCardRow(
    ribaNavigator: RibaNavigator,
    data: LiveData<RibaResult<List<RibaFulFilledManga>>>,
    title: String
) {
    val result by data.observeAsState()

    Column(
        Modifier
            .padding(horizontal = 12.dp)
            .height(250.dp),
        verticalArrangement = Arrangement.spacedBy(8.dp)
    ) {
        Text(title, style = MaterialTheme.typography.titleMedium)

        if (result == null) {
            FlexibleIndicator(height = 250.dp)
        }

        if (result is RibaResult.Error) {
            FlexibleErrorReceiver((result as RibaResult.Error).error)
        }

        if (result is RibaResult.Success) {
            val mangaList = (result as RibaResult.Success).value

            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                items(mangaList.size) { index ->
                    val fulfilledManga = mangaList.elementAt(index)

                    MangaCard(fulfilledManga.manga, fulfilledManga.cover, onClick = {
                        ribaNavigator.navigateTo(RibaRoute.Base.Manga, Pair("id", it.id))
                    })
                }
            }
        }
    }
}
