package moe.curstantine.riba.nav.graphs

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.runtime.State
import androidx.compose.runtime.remember
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.composable
import androidx.navigation.navigation
import moe.curstantine.riba.RibaHostState
import moe.curstantine.riba.nav.MangoRoute
import moe.curstantine.riba.ui.manga.MangaDetailScreen
import moe.curstantine.riba.ui.manga.MangaDetailsViewModel

fun NavGraphBuilder.baseGraph(state: RibaHostState, paddingValues: State<PaddingValues>) {
    navigation(startDestination = MangoRoute.Base.Manga.path, route = MangoRoute.Base.route) {
        composable(MangoRoute.Base.Manga.path) {
            val viewModel = remember {
                MangaDetailsViewModel(
                    state.service,
                    state.navigator.getArgument("id")
                        ?: throw IllegalArgumentException("id parameter is missing!")
                )
            }

            MangaDetailScreen(state, viewModel)
        }
        composable(MangoRoute.Vanilla.Library.path) {
            throw NotImplementedError()
        }
    }
}