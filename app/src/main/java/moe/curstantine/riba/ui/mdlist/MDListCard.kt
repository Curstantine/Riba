package moe.curstantine.riba.ui.mdlist

import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@Composable
fun MDListCard(data: MDListCardData, onClick: (MDListCardData) -> Unit) {

	OutlinedCard(
		onClick = { onClick.invoke(data) },
		modifier = Modifier
			.height(150.dp)
			.fillMaxWidth(),
	) {
		Row {
			Box(modifier = Modifier.width(100.dp))

			Column(Modifier.padding(vertical = 8.dp, horizontal = 16.dp)) {
				Text(data.title, style = MaterialTheme.typography.titleLarge)
			}

		}
	}
}

data class MDListCardData(
	val title: String,
)