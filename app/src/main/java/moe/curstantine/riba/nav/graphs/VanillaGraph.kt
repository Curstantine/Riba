package moe.curstantine.riba.nav.graphs

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.State
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.composable
import androidx.navigation.navigation
import moe.curstantine.riba.nav.MangoRoute
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.home.HomeScreen
import moe.curstantine.riba.ui.home.HomeViewModel
import moe.curstantine.riba.ui.library.LibraryScreen
import moe.curstantine.riba.ui.search.SearchScreen

fun NavGraphBuilder.vanillaGraph(ribaNavigator: RibaNavigator, paddingValues: State<PaddingValues>) {
    val homeViewModel = HomeViewModel();

    navigation(startDestination = MangoRoute.Vanilla.Home.path, route = MangoRoute.Vanilla.route) {
        composable(MangoRoute.Vanilla.Home.path) {
            HomeScreen(ribaNavigator, paddingValues, homeViewModel)
        }
        composable(MangoRoute.Vanilla.Library.path) {
            LibraryScreen(ribaNavigator, paddingValues)
        }
        composable(MangoRoute.Vanilla.Search.path) {
            SearchScreen(ribaNavigator, paddingValues)
        }
    }
}