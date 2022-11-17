package moe.curstantine.riba.ui.settings

import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.scrollable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.api.riba.RibaHostState

@Composable
fun SettingsAppearanceScreen(state: RibaHostState) {
	val coroutineScope = rememberCoroutineScope()
	val scrollState = rememberScrollState()
	val scrollBehavior = TopAppBarDefaults.exitUntilCollapsedScrollBehavior()

	Scaffold(
		topBar = {
			SubTopBar(
				text = stringResource(R.string.appearance),
				scrollBehavior = scrollBehavior,
				onBack = { state.navigator.popBackStack() })
		}
	) {
		Column(
			modifier = Modifier
				.padding(it)
				.scrollable(scrollState, Orientation.Vertical)
				.nestedScroll(scrollBehavior.nestedScrollConnection),
			verticalArrangement = Arrangement.spacedBy(16.dp),
		) {

			Spacer(Modifier.weight(1f))
			OutlinedButton(
				modifier = Modifier
					.padding(horizontal = 16.dp, vertical = 8.dp)
					.fillMaxWidth(),
				onClick = { coroutineScope.launch { state.settings.reset() } },
				content = { Text(stringResource(R.string.reset_to_defaults)) }
			)
		}
	}
}

