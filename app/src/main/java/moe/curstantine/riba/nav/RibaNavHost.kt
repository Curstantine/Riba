package moe.curstantine.riba.nav

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.material3.Text
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


@Composable
fun RibaNavHost(state: RibaHostState, paddingValues: PaddingValues) {
	val paddingValue = remember(paddingValues) { mutableStateOf(paddingValues) }

//    DisposableEffect(paddingValues) {
//        paddingValue.value = paddingValues
//        onDispose { }
//    }

	NavHost(
		navController = state.navigator.navController,
		startDestination = RibaRoute.vanillaRoute,
		route = RibaRoute.route,
	) {
		vanillaGraph(state, paddingValue)
		baseGraph(state)
	}
}

fun NavGraphBuilder.baseGraph(state: RibaHostState) {
	navigation(startDestination = RibaRoute.Manga.path, route = RibaRoute.baseRoute) {
		composable(RibaRoute.Manga.path) {
			val viewModel = remember {
				MangaDetailsViewModel(
					state.service,
					state.navigator.getArgument("id")
						?: throw IllegalArgumentException("id parameter is missing!")
				)
			}

			MangaDetailScreen(state, viewModel)
		}

		composable(RibaRoute.Settings.path) {
			Text("Settings")
		}
	}
}

fun NavGraphBuilder.vanillaGraph(state: RibaHostState, paddingValues: State<PaddingValues>) {
	val homeViewModel = HomeViewModel(state.service)

	navigation(startDestination = RibaRoute.Home.path, route = RibaRoute.vanillaRoute) {
		composable(RibaRoute.Home.path) {
			HomeScreen(state, paddingValues, homeViewModel)
		}
		composable(RibaRoute.Library.path) {
			LibraryScreen(state, paddingValues)
		}
		composable(RibaRoute.Search.path) {
			SearchScreen(state, paddingValues)
		}
	}
}