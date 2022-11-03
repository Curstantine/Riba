package moe.curstantine.riba.ui.settings

import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.scrollable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Error
import androidx.compose.material.icons.outlined.Language
import androidx.compose.material.icons.outlined.Palette
import androidx.compose.material.icons.outlined.Tune
import androidx.compose.material.icons.rounded.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.key.onKeyEvent
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import moe.curstantine.riba.R
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.nav.RibaRoute
import moe.curstantine.riba.ui.theme.RibaTheme

@Composable
fun SettingsScreen(state: RibaHostState) {
	val scrollBehavior = TopAppBarDefaults.enterAlwaysScrollBehavior()

	Scaffold(
		topBar = { ScreenTopBar(state, scrollBehavior) },
		content = { SettingsContent(state, it, scrollBehavior) },
	)
}

@Composable
private fun SettingsContent(
	state: RibaHostState,
	padding: PaddingValues,
	scrollBehavior: TopAppBarScrollBehavior
) {
	Column(
		modifier = Modifier
			.padding(padding)
			.fillMaxHeight()
			.nestedScroll(scrollBehavior.nestedScrollConnection)
			.scrollable(rememberScrollState(), orientation = Orientation.Vertical)
	) {
		ListItem(
			modifier = Modifier.clickable { },
			headlineText = { Text(text = stringResource(R.string.general)) },
			leadingContent = { Icon(Icons.Outlined.Tune, contentDescription = null) },
		)
		ListItem(
			headlineText = { Text(text = stringResource(R.string.appearance)) },
			leadingContent = { Icon(Icons.Outlined.Palette, contentDescription = null) },
		)
		ListItem(
			headlineText = { Text(text = stringResource(R.string.language)) },
			leadingContent = { Icon(Icons.Outlined.Language, contentDescription = null) },
		)
		ListItem(
			headlineText = { Text(text = stringResource(R.string.about)) },
			leadingContent = { Icon(Icons.Outlined.Error, contentDescription = null) },
		)
	}
}

@Composable
private fun ScreenTopBar(state: RibaHostState, scrollBehavior: TopAppBarScrollBehavior) =
	LargeTopAppBar(
		scrollBehavior = scrollBehavior,
		title = { Text(stringResource(R.string.settings)) },
		navigationIcon = {
			IconButton(onClick = { state.navigator.popBackStack() }) {
				Icon(Icons.Rounded.ArrowBack, contentDescription = null)
			}
		},
	)


@Preview
@Composable
private fun SettingsScreenPreview() {
	RibaTheme {
		SettingsScreen(RibaHostState.createDummy())
	}
}