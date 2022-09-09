package moe.curstantine.mangodex.ui.common.pages

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.layout.*
import androidx.compose.material3.FilledTonalButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import moe.curstantine.mangodex.api.mangadex.DexConstants
import moe.curstantine.mangodex.api.mangadex.DexError
import moe.curstantine.mangodex.api.mangodex.Error

@Composable
fun CenteredErrorPage(error: Error) {
    Column(
        modifier = Modifier
            .fillMaxHeight()
            .fillMaxWidth(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = ":(", style = MaterialTheme.typography.displayMedium)
        Text(
            text = error.humanString,
            style = MaterialTheme.typography.bodyMedium,
            textAlign = TextAlign.Center
        )

        if (error.additionalInfo != null) {
            Text(
                text = error.additionalInfo!!,
                style = MaterialTheme.typography.bodySmall,
                textAlign = TextAlign.Center
            )
        }

        if (error is DexError) {
            val localCtx = LocalContext.current
            val intent = remember { Intent(Intent.ACTION_VIEW, Uri.parse(DexConstants.statusPage)) }

            Box(Modifier.height(16.dp))
            FilledTonalButton(onClick = { localCtx.startActivity(intent) }) {
                Text("Status Page")
            }
        }
    }
}