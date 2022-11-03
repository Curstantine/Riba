package moe.curstantine.riba.ui.common.dialogs

import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.MutableState
import androidx.compose.ui.res.stringResource
import moe.curstantine.riba.R

@Composable
fun SortableItemDialog(
	isOpen: MutableState<Boolean>,
	title: String,
	description: String,
	items: Map<String, String>,
	onConfirm: (Map<String, String>) -> Unit
) {
	AlertDialog(
		title = { Text(title) },
		onDismissRequest = { isOpen.value = false },
		confirmButton = {
			TextButton(
				onClick = {
					onConfirm(items)
					isOpen.value = false
				},
				content = { Text(stringResource(R.string.confirm)) }
			)
		},
	)
}