package moe.curstantine.mangodex.ui.common.components

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
import moe.curstantine.mangodex.api.mangadex.DexInternalError
import moe.curstantine.mangodex.api.mangodex.InternalError

@Composable
fun FlexibleErrorReceiver(internalError: InternalError) {
    val colorScheme = MaterialTheme.colorScheme
    val typography = MaterialTheme.typography

    Column(
        modifier = Modifier
            .fillMaxHeight()
            .fillMaxWidth(),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = internalError.humanString,
            style = typography.bodyLarge,
            textAlign = TextAlign.Center
        )

        if (internalError.additionalInfo != null) {
            Text(
                text = internalError.additionalInfo!!,
                style = typography.bodySmall.copy(color = colorScheme.onSurface.copy(alpha = 0.75F)),
                textAlign = TextAlign.Center
            )
        }

        Box(Modifier.height(16.dp))
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceEvenly) {

            if (internalError is DexInternalError) {
                val localCtx = LocalContext.current
                val intent =
                    remember { Intent(Intent.ACTION_VIEW, Uri.parse(DexConstants.statusPage)) }

                FilledTonalButton(onClick = { localCtx.startActivity(intent) }) {
                    Text("Status Page")
                }
            }

        }
    }
}