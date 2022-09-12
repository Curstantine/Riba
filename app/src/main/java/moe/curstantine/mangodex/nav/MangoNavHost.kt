package moe.curstantine.mangodex.nav

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import moe.curstantine.mangodex.ui.home.HomeScreen
import moe.curstantine.mangodex.ui.library.LibraryScreen
import moe.curstantine.mangodex.ui.manga.MangaDetails
import moe.curstantine.mangodex.ui.search.SearchScreen

@Composable
fun MangoNavHost(mangoNavigator: MangoNavigator, modifier: Modifier) {
    NavHost(mangoNavigator.navController, startDestination = MangoRoute.Home.path, modifier) {
        composable(MangoRoute.Home.path) {
            HomeScreen(mangoNavigator)
        }
        composable(MangoRoute.Library.path) {
            LibraryScreen(mangoNavigator)
        }
        composable(MangoRoute.Search.path) {
            SearchScreen(mangoNavigator)
        }
        composable(MangoRoute.Manga.path) {
            MangaDetails(mangoNavigator)
        }
    }
}

class MangoNavigator(navController: NavHostController) {
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
