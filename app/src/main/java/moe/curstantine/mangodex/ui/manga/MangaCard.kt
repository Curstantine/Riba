package moe.curstantine.mangodex.ui.manga

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import moe.curstantine.mangodex.R
import moe.curstantine.mangodex.api.mangadex.models.DexMangaAttributes
import moe.curstantine.mangodex.api.mangadex.models.DexMangaCollection
import moe.curstantine.mangodex.api.mangodex.Result
import moe.curstantine.mangodex.ui.common.components.FlexibleErrorReceiver
import moe.curstantine.mangodex.ui.common.components.FlexibleIndicator

@Composable
fun MangaCard(manga: DexMangaAttributes, onClick: (DexMangaAttributes) -> Unit) {
    Column(
        Modifier
            .width(120.dp)
            .height(250.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        OutlinedCard(
            onClick = { onClick.invoke(manga) },
            modifier = Modifier
                .height(170.dp)
                .fillMaxWidth(),
            content = {}
        )

        Text(
            text = manga.title.english ?: stringResource(R.string.no_title),
            maxLines = 2,
            style = MaterialTheme.typography.bodySmall,
            overflow = TextOverflow.Ellipsis
        )
    }
}

@Composable
fun MangaCardRow(data: LiveData<Result<DexMangaCollection>>, title: String) {
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

        if (result is Result.Error) {
            FlexibleErrorReceiver((result as Result.Error).error)
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
