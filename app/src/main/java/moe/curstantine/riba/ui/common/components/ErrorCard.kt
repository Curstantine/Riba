package moe.curstantine.riba.ui.common.components

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Error
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedCard
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import moe.curstantine.riba.api.riba.RibaError

@Composable
fun ErrorCard(error: RibaError) {
    val typography = MaterialTheme.typography
    val colorScheme = MaterialTheme.colorScheme

    OutlinedCard(
        modifier = Modifier.fillMaxWidth().heightIn(min = 64.dp).padding(8.dp),
        colors = CardDefaults.outlinedCardColors(
            containerColor = MaterialTheme.colorScheme.errorContainer,
            contentColor = MaterialTheme.colorScheme.onErrorContainer,
        )
    ) {
        Row(Modifier.fillMaxWidth()) {
            Icon(imageVector = Icons.Rounded.Error, contentDescription = null)
            Spacer(modifier = Modifier.width(12.dp))
            Text(
                error.human,
                style = typography.titleMedium.copy(color = colorScheme.onErrorContainer)
            )
        }

        if (error.additional != null) {
            Text(
                error.additional!!,
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
    ErrorCard(RibaError.Companion.Impl.ResultNotError)
}