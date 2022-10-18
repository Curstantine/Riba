package moe.curstantine.riba.ui.common.dialogs

import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import moe.curstantine.riba.RibaHostState

@Composable
fun SignInDialog(hostState: RibaHostState) {
    AlertDialog(
        onDismissRequest = {
            // Dismiss the dialog when the user clicks outside the dialog or on the back
            // button. If you want to disable that functionality, simply use an empty
            // onDismissRequest.
            hostState.navigator.popBackStack()
        },
        title = {
            Text(text = "Title")
        },
        text = {
            Text(text = "Turned on by default")
        },
        confirmButton = {
            TextButton(
                onClick = {
                    hostState.navigator.popBackStack()
                }
            ) {
                Text("Confirm")
            }
        },
        dismissButton = {
            TextButton(
                onClick = {
                    hostState.navigator.popBackStack()
                }
            ) {
                Text("Dismiss")
            }
        }
    )
}