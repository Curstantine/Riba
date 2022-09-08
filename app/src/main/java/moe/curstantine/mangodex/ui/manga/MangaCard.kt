package moe.curstantine.mangodex.ui.manga

import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

@Composable
fun MangaCard(data: MangaCardData, onClick: (MangaCardData) -> Unit) {
    Column(
        Modifier
            .width(120.dp)
            .height(210.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        OutlinedCard(
            onClick = { onClick.invoke(data) },
            modifier = Modifier
                .height(170.dp)
                .fillMaxWidth(),
            content = {}
        )

        Text(
            text = data.title,
            maxLines = 2,
            style = MaterialTheme.typography.bodySmall,
            overflow = TextOverflow.Ellipsis
        )
    }
}

@Preview
@Composable
fun MangaCardPreview() {
    MangaCard(data = MangaCardData(id = "1", title = "Manga Title")) {}
}

data class MangaCardData(val id: String, val title: String)