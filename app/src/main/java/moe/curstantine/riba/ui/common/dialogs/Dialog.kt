package moe.curstantine.riba.ui.common.dialogs

import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.MaterialTheme.colorScheme
import androidx.compose.material3.MaterialTheme.typography
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import moe.curstantine.riba.R

@Composable
fun SimpleDialog(
	isOpen: MutableState<Boolean>,
	properties: DialogProperties = DialogProperties(dismissOnClickOutside = false, usePlatformDefaultWidth = false),
	content: @Composable ColumnScope.() -> Unit
) {
	Dialog(
		onDismissRequest = { isOpen.value = false },
		properties = properties,
	) {
		Surface(
			modifier = Modifier.padding(horizontal = 24.dp),
			tonalElevation = 4.dp,
			shadowElevation = 4.dp,
			shape = MaterialTheme.shapes.extraLarge,
		) {
			Column(modifier = Modifier.padding(vertical = 24.dp), content = content)
		}
	}
}

@Composable
fun SimpleDialogHeader(
	title: String,
	description: String,
) = Column(
	modifier = Modifier.padding(horizontal = 24.dp),
	verticalArrangement = Arrangement.spacedBy(8.dp)
) {
	Text(title, style = typography.headlineSmall)
	Text(description, style = typography.bodyMedium.copy(color = colorScheme.onSurfaceVariant))
}

@Composable
fun SimpleDialogFooter(
	onConfirm: () -> Unit,
	onCancel: () -> Unit,
) = Row(
	modifier = Modifier
		.padding(horizontal = 24.dp)
		.fillMaxWidth(),
	horizontalArrangement = Arrangement.End,
) {
	TextButton(content = { Text(stringResource(R.string.cancel)) }, onClick = onCancel)
	TextButton(content = { Text(stringResource(R.string.confirm)) }, onClick = onConfirm)
}