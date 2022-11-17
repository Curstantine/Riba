package moe.curstantine.riba.ui.common.components

import android.content.Intent
import android.net.Uri
import androidx.compose.foundation.layout.*
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
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import moe.curstantine.riba.R
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.riba.RibaConstants
import moe.curstantine.riba.api.riba.RibaError

@Composable
fun FlexibleErrorReceiver(error: RibaError) {
	val context = LocalContext.current
	val colorScheme = MaterialTheme.colorScheme
	val typography = MaterialTheme.typography

	val issueIntent = remember { Intent(Intent.ACTION_VIEW, Uri.parse(RibaConstants.ISSUES_URL)) }
	val statusIntent = remember { Intent(Intent.ACTION_VIEW, Uri.parse(DexConstants.STATUS_PAGE)) }

	val additional = remember(error) { error.getAdditional() }

	Column(
		modifier = Modifier
			.fillMaxSize()
			.verticalScroll(rememberScrollState()),
		verticalArrangement = Arrangement.Center,
		horizontalAlignment = Alignment.CenterHorizontally
	) {
		Text(
			text = error.message,
			style = typography.bodyLarge.copy(fontWeight = FontWeight.SemiBold)
		)

		if (additional != null) {
			Text(
				text = additional,
				style = typography.bodySmall.copy(color = colorScheme.onSurface.copy(alpha = 0.75F)),
				textAlign = TextAlign.Center
			)
		}

		Box(Modifier.height(16.dp))
		Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceEvenly) {
			if (error is DexError) {
				FilledTonalButton(onClick = { context.startActivity(statusIntent) }) {
					Text(stringResource(R.string.status_page))
				}
			}

			FilledTonalButton(onClick = { context.startActivity(issueIntent) }) {
				Text(stringResource(R.string.create_issue))
			}
		}
	}
}