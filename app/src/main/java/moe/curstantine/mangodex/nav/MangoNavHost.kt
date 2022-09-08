package moe.curstantine.mangodex.nav

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import moe.curstantine.mangodex.ui.screens.home.HomeScreen
import moe.curstantine.mangodex.ui.screens.library.LibraryScreen
import moe.curstantine.mangodex.ui.screens.search.SearchScreen

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
}
