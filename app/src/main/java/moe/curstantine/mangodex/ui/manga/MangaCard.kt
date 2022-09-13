package moe.curstantine.mangodex.ui.manga

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import coil.compose.AsyncImage
import moe.curstantine.mangodex.R
import moe.curstantine.mangodex.api.mangadex.DexCoverSize
import moe.curstantine.mangodex.api.mangadex.DexUtils
import moe.curstantine.mangodex.api.riba.RibaResult
import moe.curstantine.mangodex.api.riba.models.RibaCover
import moe.curstantine.mangodex.api.riba.models.RibaFulfilledManga
import moe.curstantine.mangodex.api.riba.models.RibaManga
import moe.curstantine.mangodex.nav.MangoNavigator
import moe.curstantine.mangodex.nav.MangoRoute
import moe.curstantine.mangodex.ui.common.components.FlexibleErrorReceiver
import moe.curstantine.mangodex.ui.common.components.FlexibleIndicator

@Composable
fun MangaCard(manga: RibaManga, cover: RibaCover?, onClick: (RibaManga) -> Unit) {
    val coverUrl = remember {
        cover?.let {
            it.fileName?.let { fileName ->
                DexUtils.getCoverUrl(manga.id, fileName, DexCoverSize.Small)
            }
        }
    }

    Column(
        Modifier
            .width(120.dp)
            .height(250.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        Box(Modifier.height(170.dp), contentAlignment = Alignment.Center) {
            OutlinedCard(
                onClick = { onClick.invoke(manga) },
                modifier = Modifier
                    .fillMaxWidth()
                    .heightIn(0.dp, 170.dp),
                content = {
                    if (coverUrl == null) {
                        Box(
                            modifier = Modifier.fillMaxSize(),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                text = stringResource(R.string.no_cover),
                                textAlign = TextAlign.Center,
                                style = MaterialTheme.typography.bodySmall.copy(
                                    color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5F)
                                ),
                            )
                        }
                    } else {
                        AsyncImage(
                            modifier = Modifier.fillMaxWidth(),
                            model = coverUrl,
                            contentScale = ContentScale.FillWidth,
                            contentDescription = "Cover for ${manga.title}",
                        )
                    }
                }
            )
        }

        Text(
            text = manga.title,
            maxLines = 2,
            style = MaterialTheme.typography.bodySmall,
            overflow = TextOverflow.Ellipsis
        )
    }
}

@Composable
fun MangaCardRow(
    mangoNavigator: MangoNavigator,
    data: LiveData<RibaResult<List<RibaFulfilledManga>>>,
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
            val mangaList = (result as RibaResult.Success).data

            LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                items(mangaList.size) { index ->
                    val fulfilledManga = mangaList.elementAt(index)

                    MangaCard(fulfilledManga.manga, fulfilledManga.cover, onClick = {
                        mangoNavigator.navigateTo(MangoRoute.Manga, Pair("id", it.id))
                    })
                }
            }
        }
    }
}
