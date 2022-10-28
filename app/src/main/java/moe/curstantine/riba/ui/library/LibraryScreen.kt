package moe.curstantine.riba.ui.library

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.ui.Modifier
import moe.curstantine.riba.RibaHostState

@Composable
fun LibraryScreen(state: RibaHostState, paddingValues: State<PaddingValues>) {
	Column(Modifier.padding(paddingValues.value)) {
		Text("Library")
	}
}