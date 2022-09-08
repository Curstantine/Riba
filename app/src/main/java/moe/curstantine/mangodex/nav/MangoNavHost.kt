package moe.curstantine.mangodex.nav

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import moe.curstantine.mangodex.ui.screens.home.HomeScreen
import moe.curstantine.mangodex.ui.screens.library.LibraryScreen
import moe.curstantine.mangodex.ui.screens.search.SearchScreen

@Composable
fun MangoNavHost(hostController: NavHostController) {
    NavHost(hostController, startDestination = MangoRoute.Home.path) {
        val mangoNavigator = MangoNavigator(hostController)

        composable(MangoRoute.Home.path) { HomeScreen(mangoNavigator) }
        composable(MangoRoute.Search.path) { SearchScreen(mangoNavigator) }
        composable(MangoRoute.Library.path) { LibraryScreen(mangoNavigator) }
    }
}

class MangoNavigator(navController: NavHostController) {
    private var navController: NavHostController

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
