package moe.curstantine.riba.ui.search

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import moe.curstantine.riba.api.riba.RibaHostState

@Composable
fun SearchScreen(state: RibaHostState, paddingValues: PaddingValues) {
	Column(Modifier.padding(paddingValues)) {
		Text("Search")
	}
}