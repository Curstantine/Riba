package moe.curstantine.riba.ui.manga

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.widthIn
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ElevatedCard
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import coil.compose.AsyncImage
import coil.compose.AsyncImagePainter
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
	val coverUrl: String? = remember {
		cover?.fileName?.let { fileName ->
			DexUtils.getCoverUrl(cover.mangaId, fileName, coverSize)
		}
	}

	Box(
		modifier = Modifier
			.height(maxHeight)
			.widthIn(max = maxHeight.times(0.75F)),
		contentAlignment = Alignment.Center
	) {
		ElevatedCard(
			onClick = { onClick.invoke() },
			modifier = Modifier
				.fillMaxWidth()
				.heightIn(0.dp, maxHeight),
			elevation = CardDefaults.elevatedCardElevation(
				defaultElevation = elevation,
				disabledElevation = 0.dp
			)
		) {
			var willLoad by remember { mutableStateOf(coverUrl != null) }
			var isLoading by remember { mutableStateOf(false) }

			AnimatedVisibility(!willLoad) {
				Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
					val textInt = if (coverUrl == null) R.string.no_cover else R.string.cover_error

					Text(
						text = stringResource(textInt),
						textAlign = TextAlign.Center,
						style = MaterialTheme.typography.bodySmall.copy(
							color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5F)
						),
					)
				}
			}

			AnimatedVisibility(isLoading) {
				Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
					CircularProgressIndicator()
				}
			}

			AsyncImage(
				model = coverUrl,
				modifier = Modifier.fillMaxWidth(),
				contentScale = ContentScale.FillWidth,
				contentDescription = "Cover for ${cover?.mangaId}",
				onState = {
					when (it) {
						is AsyncImagePainter.State.Loading -> {
							willLoad = true
							isLoading = true
						}
						is AsyncImagePainter.State.Success -> isLoading = false
						is AsyncImagePainter.State.Empty,
						is AsyncImagePainter.State.Error -> {
							isLoading = false
							willLoad = false
						}
					}
				},
			)
		}
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