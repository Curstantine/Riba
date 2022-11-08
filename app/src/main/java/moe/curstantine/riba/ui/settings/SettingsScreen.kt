package moe.curstantine.riba.ui.settings

import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.scrollable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.*
import androidx.compose.material.icons.rounded.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.input.key.onKeyEvent
import androidx.compose.ui.input.nestedscroll.nestedScroll
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import moe.curstantine.riba.R
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.nav.RibaRoute
import moe.curstantine.riba.ui.theme.RibaTheme
import moe.curstantine.riba.ui.theme.Rubik

@Composable
fun SettingsScreen(state: RibaHostState) {
	Scaffold(
		topBar = { ScreenTopBar(state) },
	) {
		Column(modifier = Modifier.padding(it)) {
			ListItem(
				modifier = Modifier.clickable { state.navigator.navigateTo(RibaRoute.Settings.General) },
				headlineText = { Text(text = stringResource(R.string.general)) },
				leadingContent = { Icon(Icons.Outlined.Tune, contentDescription = null) },
			)
			ListItem(
				modifier = Modifier.clickable { state.navigator.navigateTo(RibaRoute.Settings.Appearance) },
				headlineText = { Text(text = stringResource(R.string.appearance)) },
				leadingContent = { Icon(Icons.Outlined.Palette, contentDescription = null) },
			)
			ListItem(
				modifier = Modifier.clickable { state.navigator.navigateTo(RibaRoute.Settings.About) },
				headlineText = { Text(text = stringResource(R.string.about)) },
				leadingContent = { Icon(Icons.Outlined.ErrorOutline, contentDescription = null) },
			)
		}
	}
}

@Composable
private fun ScreenTopBar(state: RibaHostState) =
	MediumTopAppBar(
		title = { Text(stringResource(R.string.settings)) },
		navigationIcon = {
			IconButton(onClick = { state.navigator.popBackStack() }) {
				Icon(Icons.Rounded.ArrowBack, contentDescription = null)
			}
		},
	)

@Composable
fun CategoryHeader(text: String) = Text(
	text = text,
	modifier = Modifier
		.padding(horizontal = 8.dp)
		.padding(bottom = 6.dp),
	style = MaterialTheme.typography.labelLarge.copy(
		fontFamily = Rubik,
		fontWeight = FontWeight.Medium,
		color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.5F)
	)
)

@Preview
@Composable
private fun SettingsScreenPreview() {
	RibaTheme {
		SettingsScreen(RibaHostState.createDummy())
	}
}