package moe.curstantine.mangodex.ui.manga

import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import moe.curstantine.mangodex.api.mangadex.models.DexMangaAttributes

@Composable
fun MangaCard(manga: DexMangaAttributes, onClick: (DexMangaAttributes) -> Unit) {
    Column(
        Modifier
            .width(120.dp)
            .height(210.dp),
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
            text = manga.title.english,
            maxLines = 2,
            style = MaterialTheme.typography.bodySmall,
            overflow = TextOverflow.Ellipsis
        )
    }
}
