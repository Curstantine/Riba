package moe.curstantine.riba.nav

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.Composable
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.navigation
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.ui.home.HomeScreen
import moe.curstantine.riba.ui.home.HomeViewModel
import moe.curstantine.riba.ui.library.LibraryScreen
import moe.curstantine.riba.ui.manga.MangaDetailScreen
import moe.curstantine.riba.ui.manga.MangaDetailsViewModel
import moe.curstantine.riba.ui.search.SearchScreen
import moe.curstantine.riba.ui.settings.SettingsGeneralScreen
import moe.curstantine.riba.ui.settings.SettingsScreen


@Composable
fun RibaNavHost(state: RibaHostState, paddingValues: PaddingValues) {
	val paddingValue = remember(paddingValues) { mutableStateOf(paddingValues) }

	NavHost(
		navController = state.navigator.navController,
		startDestination = RibaRoute.Landing.path,
	) {
		landing(state, paddingValue)
		settings(state)

		composable(RibaRoute.Manga.route) {
			val viewModel = remember {
				MangaDetailsViewModel(
					state.service,
					state.navigator.getArgument("id")
						?: throw IllegalArgumentException("id parameter is missing!")
				)
			}

			MangaDetailScreen(state, viewModel)
		}
	}
}

fun NavGraphBuilder.settings(state: RibaHostState) {
	navigation(startDestination = RibaRoute.Settings.Screen.route, route = RibaRoute.Settings.path) {
		composable(RibaRoute.Settings.Screen.route) {
			SettingsScreen(state)
		}
		composable(RibaRoute.Settings.General.route) {
			SettingsGeneralScreen(state)
		}
	}
}

fun NavGraphBuilder.landing(state: RibaHostState, paddingValues: State<PaddingValues>) {
	val homeViewModel = HomeViewModel(state.service)

	navigation(startDestination = RibaRoute.Landing.Home.route, route = RibaRoute.Landing.path) {
		composable(RibaRoute.Landing.Home.route) {
			HomeScreen(state, paddingValues, homeViewModel)
		}
		composable(RibaRoute.Landing.Library.route) {
			LibraryScreen(state, paddingValues)
		}
		composable(RibaRoute.Landing.Search.route) {
			SearchScreen(state, paddingValues)
		}
	}
}