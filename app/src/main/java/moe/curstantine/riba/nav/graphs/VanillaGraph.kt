package moe.curstantine.riba.nav.graphs

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.State
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.composable
import androidx.navigation.navigation
import moe.curstantine.riba.RibaHostState
import moe.curstantine.riba.nav.RibaRoute
import moe.curstantine.riba.ui.home.HomeScreen
import moe.curstantine.riba.ui.home.HomeViewModel
import moe.curstantine.riba.ui.library.LibraryScreen
import moe.curstantine.riba.ui.search.SearchScreen

fun NavGraphBuilder.vanillaGraph(state: RibaHostState, paddingValues: State<PaddingValues>) {
    val homeViewModel = HomeViewModel(state.service);

    navigation(startDestination = RibaRoute.Vanilla.Home.path, route = RibaRoute.Vanilla.route) {
        composable(RibaRoute.Vanilla.Home.path) {
            HomeScreen(state, paddingValues, homeViewModel)
        }
        composable(RibaRoute.Vanilla.Library.path) {
            LibraryScreen(state, paddingValues)
        }
        composable(RibaRoute.Vanilla.Search.path) {
            SearchScreen(state, paddingValues)
        }
    }
}