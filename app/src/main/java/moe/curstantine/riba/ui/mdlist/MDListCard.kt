package moe.curstantine.riba.ui.mdlist

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Card
import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.MaterialTheme.typography
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import moe.curstantine.riba.api.riba.models.RibaMangaList
import moe.curstantine.riba.api.riba.models.RibaUser
import moe.curstantine.riba.ui.theme.RibaTheme
import moe.curstantine.riba.R

@Composable
fun MDListCard(data: MDListCardData, onClick: (() -> Unit)? = null) {
	val total = stringResource(R.string.x_titles, data.list.titles.size)
	val muted = colorScheme.onSurface.copy(alpha = 0.5F)

	Card(
		onClick = { onClick?.invoke() },
		modifier = Modifier
			.height(125.dp)
			.width(175.dp)
			.fillMaxWidth(),
	) {
		Column(
			Modifier
				.padding(8.dp)
				.fillMaxSize()
		) {
			Text(data.list.name, style = typography.titleSmall)
			Text(total, style = typography.bodySmall)

			Spacer(modifier = Modifier.weight(1F))

			if (!data.local) {
				Text(data.user, style = typography.labelLarge.copy(color = muted))
			}
		}
	}
}

@Composable
@Preview(showBackground = true, showSystemUi = false)
private fun MDListCardPreview() {
	val list = RibaMangaList.getDefault()
	val user = RibaUser.getDefault()

	RibaTheme {
		Scaffold {
			Column(
				Modifier
					.padding(it)
					.fillMaxSize(),
				verticalArrangement = Arrangement.Center,
				horizontalAlignment = Alignment.CenterHorizontally,
				content = {
					MDListCard(MDListCardData(list = list, user = user.username))
				}
			)
		}
	}
}

data class MDListCardData(
	val list: RibaMangaList,
	val user: String,
	val local: Boolean = false,
)