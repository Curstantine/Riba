package moe.curstantine.riba.ui.manga

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.widthIn
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import moe.curstantine.riba.R
import moe.curstantine.riba.api.mangadex.DexCoverSize
import moe.curstantine.riba.api.mangadex.DexUtils
import moe.curstantine.riba.api.riba.models.RibaCover

@Composable
fun MangaCover(
    cover: RibaCover?,
    coverSize: DexCoverSize = DexCoverSize.Small,
    maxHeight: Dp = 170.dp,
    elevation: Dp = 4.dp,
    onClick: () -> Unit = {}
) {
    val coverUrl = remember {
        cover?.fileName?.let { fileName ->
            DexUtils.getCoverUrl(cover.mangaId, fileName, coverSize)
        }
    }

    Box(
        Modifier
            .height(maxHeight)
            .widthIn(max = maxHeight.times(0.75F)), contentAlignment = Alignment.Center
    ) {
        ElevatedCard(
            onClick = { onClick.invoke() },
            modifier = Modifier
                .fillMaxWidth()
                .heightIn(0.dp, maxHeight),
            elevation = CardDefaults.elevatedCardElevation(defaultElevation = elevation),
            content = {
                if (coverUrl == null) {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
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
                        contentDescription = "Cover for ${cover?.mangaId}",
                    )
                }
            }
        )
    }
}

@Preview
@Composable
private fun MangaCoverPreview() {
    Row(horizontalArrangement = Arrangement.spacedBy(20.dp)) {
        MangaCover(cover = RibaCover.getDefault())
        MangaCover(cover = RibaCover.getDefault(), maxHeight = 200.dp)
    }
}