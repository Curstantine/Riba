package moe.curstantine.riba.ui.common.components

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Error
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import moe.curstantine.riba.api.riba.RibaError

@Composable
fun ErrorCard(error: RibaError) {
	val typography = MaterialTheme.typography
	val colorScheme = MaterialTheme.colorScheme

	val additional = remember(error) { error.getAdditional() }

	OutlinedCard(
		modifier = Modifier
			.fillMaxWidth()
			.heightIn(min = 64.dp)
			.padding(8.dp),
		colors = CardDefaults.outlinedCardColors(
			containerColor = MaterialTheme.colorScheme.errorContainer,
			contentColor = MaterialTheme.colorScheme.onErrorContainer,
		)
	) {
		Row(Modifier.fillMaxWidth()) {
			Icon(imageVector = Icons.Rounded.Error, contentDescription = null)
			Spacer(modifier = Modifier.width(12.dp))
			Text(
				text = error.message,
				style = typography.titleMedium.copy(color = colorScheme.onErrorContainer)
			)
		}

		if (additional != null) {
			Text(
				text = additional,
				style = typography.bodyMedium.copy(
					color = colorScheme.onErrorContainer.copy(alpha = 0.75F)
				)
			)
		}
	}
}

@Preview
@Composable
private fun ErrorCardPreview() {
	ErrorCard(RibaError("Error message", "Additional message", Error("Caused Error")))
}