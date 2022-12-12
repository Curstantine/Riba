package moe.curstantine.riba.ui.common.components

import androidx.compose.animation.*
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Home
import androidx.compose.material.icons.rounded.LibraryBooks
import androidx.compose.material.icons.rounded.Search
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import moe.curstantine.riba.R
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.nav.RibaRoute

@Composable
fun RibaNavigationBar(state: RibaHostState) {
	NavigationBar {
		val currentUser by state.service.mangadex.user.currentUser.collectAsState()

		for (item in RibaNavigationBarItem.values()) {
			val isVisible = remember(currentUser) { if (item.requiresAuth) currentUser != null else true }

			AnimatedVisibility(
				visible = isVisible,
				modifier = Modifier.weight(1F),
				exit = fadeOut() + shrinkVertically(),
				enter = fadeIn() + expandVertically(),
			) {
				NavigationBarItem(
					icon = item.icon,
					label = item.label,
					selected = state.navigator.currentRoute() == item.route.route,
					onClick = { state.navigator.navigateTo(item.route) },
				)
			}
		}
	}
}

@Preview
@Composable
fun RibaBottomNavigationBarPreview(shouldSandbox: Boolean = true) {
	var activeIndex by remember { mutableStateOf(0) }
	var isSignedIn by remember { mutableStateOf(!shouldSandbox) }

	Column(
		modifier = if (shouldSandbox) Modifier.fillMaxSize() else Modifier,
		verticalArrangement = if (shouldSandbox) Arrangement.Bottom else Arrangement.Top,
	) {
		if (shouldSandbox) {
			FilledTonalButton(
				modifier = Modifier
					.padding(horizontal = 16.dp)
					.fillMaxWidth(),
				onClick = { isSignedIn = !isSignedIn }) {
				Text("Sign ${if (isSignedIn) "out" else "in"}")
			}

			Slider(
				modifier = Modifier.padding(horizontal = 16.dp),
				value = activeIndex.toFloat(),
				onValueChange = { activeIndex = it.toInt() },
				valueRange = 0F..RibaNavigationBarItem.values().size.minus(1).toFloat(),
				steps = RibaNavigationBarItem.values().size,
			)
		}

		NavigationBar {
			for (item in RibaNavigationBarItem.values()) {
				val isVisible = remember(isSignedIn) { if (item.requiresAuth) isSignedIn else true }
				val thisIndex = remember { RibaNavigationBarItem.values().indexOf(item) }

				AnimatedVisibility(
					visible = isVisible,
					modifier = Modifier.weight(1F),
					exit = fadeOut() + shrinkVertically(),
					enter = fadeIn() + expandVertically(),
				) {
					NavigationBarItem(
						icon = item.icon,
						label = item.label,
						selected = thisIndex == activeIndex,
						onClick = { activeIndex = thisIndex },
					)
				}
			}
		}
	}
}

sealed class RibaNavigationBarItem(
	val route: RibaRoute,
	val icon: @Composable () -> Unit,
	val label: @Composable () -> Unit,
	val requiresAuth: Boolean = false,
) {
	object Home : RibaNavigationBarItem(
		route = RibaRoute.Landing.Home,
		icon = { Icon(Icons.Rounded.Home, contentDescription = "Home") },
		label = { Text(stringResource(R.string.home)) },
	)

	object Library : RibaNavigationBarItem(
		route = RibaRoute.Landing.Library,
		icon = { Icon(Icons.Rounded.LibraryBooks, contentDescription = "Library") },
		label = { Text(stringResource(R.string.library)) },
		requiresAuth = true,
	)

	object Search : RibaNavigationBarItem(
		route = RibaRoute.Landing.Search,
		icon = { Icon(Icons.Rounded.Search, contentDescription = "Search") },
		label = { Text(stringResource(R.string.search)) },
	)

	companion object {
		fun values(): List<RibaNavigationBarItem> {
			return listOf(Home, Library, Search)
		}
	}
}