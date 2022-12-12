package moe.curstantine.riba.ui.mdlist

import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.MaterialTheme.typography
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import moe.curstantine.riba.api.riba.models.RibaMangaList

@Composable
fun MDListCard(data: MDListCardData, onClick: (() -> Unit)? = null) {
	OutlinedCard(
		onClick = { onClick?.invoke() },
		modifier = Modifier
			.height(125.dp)
			.width(250.dp)
			.fillMaxWidth(),
	) {
		Column(Modifier.padding(8.dp)) {
			Text(data.name, style = MaterialTheme.typography.titleMedium)
			Text(
				text = data.user,
				style = typography.titleMedium.copy(color = colorScheme.onSurface.copy(alpha = 0.75F))
			)
		}
	}
}

data class MDListCardData(
	val id: String,
	val name: String,
	val user: String,
)