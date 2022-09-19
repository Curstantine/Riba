package moe.curstantine.riba.nav.graphs

import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.composable
import androidx.navigation.navigation
import moe.curstantine.riba.nav.MangoRoute
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.manga.MangaDetailScreen

fun NavGraphBuilder.baseGraph(ribaNavigator: RibaNavigator) {
    navigation(startDestination = MangoRoute.Base.Manga.path, route = MangoRoute.Base.route) {
        composable(MangoRoute.Base.Manga.path) {
            MangaDetailScreen(ribaNavigator)
        }
        composable(MangoRoute.Vanilla.Library.path) {
            throw NotImplementedError()
        }
    }
}