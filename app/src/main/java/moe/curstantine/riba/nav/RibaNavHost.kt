package moe.curstantine.riba.nav

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import moe.curstantine.riba.ui.home.HomeScreen
import moe.curstantine.riba.ui.library.LibraryScreen
import moe.curstantine.riba.ui.manga.MangaDetails
import moe.curstantine.riba.ui.search.SearchScreen

@Composable
fun RibaNavHost(ribaNavigator: RibaNavigator, modifier: Modifier) {
    NavHost(ribaNavigator.navController, startDestination = MangoRoute.Home.path, modifier) {
        composable(MangoRoute.Home.path) {
            HomeScreen(ribaNavigator)
        }
        composable(MangoRoute.Library.path) {
            LibraryScreen(ribaNavigator)
        }
        composable(MangoRoute.Search.path) {
            SearchScreen(ribaNavigator)
        }
        composable(MangoRoute.Manga.path) {
            MangaDetails(ribaNavigator)
        }
    }
}

class RibaNavigator(navController: NavHostController) {
    var navController: NavHostController

    init {
        this.navController = navController
    }

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
