package moe.curstantine.riba.nav.graphs

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.State
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.composable
import androidx.navigation.navigation
import moe.curstantine.riba.RibaHostState
import moe.curstantine.riba.nav.MangoRoute
import moe.curstantine.riba.ui.manga.MangaDetailScreen

fun NavGraphBuilder.baseGraph(state: RibaHostState, paddingValues: State<PaddingValues>) {
    navigation(startDestination = MangoRoute.Base.Manga.path, route = MangoRoute.Base.route) {
        composable(MangoRoute.Base.Manga.path) {
            MangaDetailScreen(state, paddingValues)
        }
        composable(MangoRoute.Vanilla.Library.path) {
            throw NotImplementedError()
        }
    }
}