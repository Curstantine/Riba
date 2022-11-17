package moe.curstantine.riba.nav

import androidx.compose.runtime.*
import androidx.navigation.NavHostController
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController

class RibaNavigator(val navController: NavHostController) {
	fun currentRoute(): String? {
		return navController.currentDestination?.route
	}

	fun navigateTo(route: RibaRoute) {
		this.navController.navigate(route.route)
	}

	fun navigateTo(route: RibaRoute, vararg args: Pair<String, String>) {
		val path = route.route.let {
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
	fun currentRouteAsState(): State<RibaRoute> {
		val navBackStackEntry by navController.currentBackStackEntryAsState()
		val route = navBackStackEntry?.destination?.route
			?: RibaRoute.Landing.Home.route

		return remember(route) { mutableStateOf(RibaRoute.fromPath(route)) }
	}

	companion object {
		@Composable
		fun createDummy(): RibaNavigator {
			return RibaNavigator(rememberNavController())
		}
	}
}