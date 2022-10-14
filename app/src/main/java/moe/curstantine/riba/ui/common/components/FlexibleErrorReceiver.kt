package moe.curstantine.riba.ui.common.components

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
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
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.riba.RibaError

@Composable
fun FlexibleErrorReceiver(error: RibaError) {
    val colorScheme = MaterialTheme.colorScheme
    val typography = MaterialTheme.typography

    Column(
        modifier = Modifier
            .fillMaxSize()
            .horizontalScroll(rememberScrollState())
            .verticalScroll(rememberScrollState()),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(text = error.human, style = typography.bodyLarge)

        if (error.additional != null) {
            Text(
                text = error.additional!!,
                style = typography.bodySmall.copy(color = colorScheme.onSurface.copy(alpha = 0.75F)),
            )
        }

        Box(Modifier.height(16.dp))
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceEvenly) {

            if (error is DexError) {
                val localCtx = LocalContext.current
                val intent =
                    remember { Intent(Intent.ACTION_VIEW, Uri.parse(DexConstants.STATUS_PAGE)) }

                FilledTonalButton(onClick = { localCtx.startActivity(intent) }) {
                    Text("Status Page")
                }
            }

        }
    }
}