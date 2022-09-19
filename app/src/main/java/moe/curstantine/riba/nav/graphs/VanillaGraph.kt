package moe.curstantine.riba.nav.graphs

import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.composable
import androidx.navigation.navigation
import moe.curstantine.riba.nav.MangoRoute
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.home.HomeScreen
import moe.curstantine.riba.ui.library.LibraryScreen
import moe.curstantine.riba.ui.search.SearchScreen

fun NavGraphBuilder.vanillaGraph(ribaNavigator: RibaNavigator) {
    navigation(startDestination = MangoRoute.Vanilla.Home.path, route = MangoRoute.Vanilla.route) {
        composable(MangoRoute.Vanilla.Home.path) {
            HomeScreen(ribaNavigator)
        }
        composable(MangoRoute.Vanilla.Library.path) {
            LibraryScreen(ribaNavigator)
        }
        composable(MangoRoute.Vanilla.Search.path) {
            SearchScreen(ribaNavigator)
        }
    }
}