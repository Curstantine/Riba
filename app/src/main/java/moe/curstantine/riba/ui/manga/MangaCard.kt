package moe.curstantine.riba.ui.manga

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
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
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaFulFilledManga
import moe.curstantine.riba.api.riba.models.RibaManga
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.nav.RibaRoute
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
			text = manga.title?.get(DexLocale.English) ?: stringResource(R.string.no_title),
			maxLines = 2,
			style = MaterialTheme.typography.bodySmall,
			overflow = TextOverflow.Ellipsis
		)
	}
}

@Composable
fun MangaCardRow(
	ribaNavigator: RibaNavigator,
	data: LiveData<Result<List<RibaFulFilledManga>>>,
	title: String
) {
	val result by data.observeAsState()

	Column(
		modifier = Modifier
			.padding(horizontal = 12.dp)
			.height(250.dp),
		verticalArrangement = Arrangement.spacedBy(8.dp)
	) {
		Text(title, style = MaterialTheme.typography.titleMedium)

		if (result == null) FlexibleIndicator(height = 250.dp)
		else if (result!!.isFailure) FlexibleErrorReceiver(DexError.tryHandle(result!!.exceptionOrNull()!!))
		else if (result!!.isSuccess) {
			LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
				items(result!!.getOrThrow()) {
					MangaCard(it.manga, it.cover, onClick = { manga ->
						ribaNavigator.navigateTo(RibaRoute.Manga, Pair("id", manga.id))
					})
				}
			}
		}
	}
}
