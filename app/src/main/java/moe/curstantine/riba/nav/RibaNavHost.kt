package moe.curstantine.riba.nav

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import moe.curstantine.riba.nav.graphs.baseGraph
import moe.curstantine.riba.nav.graphs.vanillaGraph


@Composable
fun RibaNavHost(ribaNavigator: RibaNavigator, paddingValues: PaddingValues) {
    val paddingValue = remember { mutableStateOf(paddingValues) }

    DisposableEffect(paddingValues) {
        paddingValue.value = paddingValues
        onDispose { }
    }

    NavHost(
        navController = ribaNavigator.navController,
        startDestination = MangoRoute.Vanilla.route,
        route = MangoRoute.route,
    ) {
        vanillaGraph(ribaNavigator, paddingValue)
        baseGraph(ribaNavigator, paddingValue)
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
