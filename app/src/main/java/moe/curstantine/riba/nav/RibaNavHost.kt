package moe.curstantine.riba.nav

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import moe.curstantine.riba.nav.graphs.baseGraph
import moe.curstantine.riba.nav.graphs.vanillaGraph


@Composable
fun RibaNavHost(ribaNavigator: RibaNavigator, modifier: Modifier) {
    NavHost(
        navController = ribaNavigator.navController,
        startDestination = MangoRoute.Vanilla.route,
        route = MangoRoute.route,
        modifier = modifier
    ) {
        vanillaGraph(ribaNavigator)
        baseGraph(ribaNavigator)
    }
}


class RibaNavigator(val navController: NavHostController) {
    fun currentRoute(): String? {
        return navController.currentDestination?.route
    }

    fun navigateTo(route: MangoRoute) {
        this.navController.navigate(route.path)
    }

    fun navigateTo(route: MangoRoute, vararg args: Pair<String, String>) {
        val path = route.path.let {
            args.fold(it) { acc, pair ->
                acc.replace("{${pair.first}}", pair.second)
            }
        }

        this.navController.navigate(path)
    }

    fun popBackStack() {
        this.navController.popBackStack()
    }

    fun getArgument(key: String): String? {
        return navController.currentBackStackEntry?.arguments?.getString(key)
    }
}
