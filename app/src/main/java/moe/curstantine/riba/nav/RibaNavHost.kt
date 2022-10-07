package moe.curstantine.riba.nav

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.State
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.currentBackStackEntryAsState
import moe.curstantine.riba.RibaHostState
import moe.curstantine.riba.nav.graphs.baseGraph
import moe.curstantine.riba.nav.graphs.vanillaGraph


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

    @Composable
    fun currentRouteAsState(): State<MangoRoute> {
        val navBackStackEntry by navController.currentBackStackEntryAsState()
        val route = navBackStackEntry?.destination?.route
            ?: MangoRoute.Vanilla.Home.path

        return remember(route) { mutableStateOf(MangoRoute.fromPath(route)) }
    }
}

@Composable
fun RibaNavHost(state: RibaHostState, paddingValues: PaddingValues) {
    val paddingValue = remember { mutableStateOf(paddingValues) }

    DisposableEffect(paddingValues) {
        paddingValue.value = paddingValues
        onDispose { }
    }

    NavHost(
        navController = state.navigator.navController,
        startDestination = MangoRoute.Vanilla.route,
        route = MangoRoute.route,
    ) {
        vanillaGraph(state, paddingValue)
        baseGraph(state, paddingValue)
    }
}