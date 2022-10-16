package moe.curstantine.riba.nav.graphs

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.material3.Text
import androidx.compose.runtime.State
import androidx.compose.runtime.remember
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.composable
import androidx.navigation.navigation
import moe.curstantine.riba.RibaHostState
import moe.curstantine.riba.nav.RibaRoute
import moe.curstantine.riba.ui.manga.MangaDetailScreen
import moe.curstantine.riba.ui.manga.MangaDetailsViewModel

fun NavGraphBuilder.baseGraph(state: RibaHostState, paddingValues: State<PaddingValues>) {
    navigation(startDestination = RibaRoute.Base.Manga.path, route = RibaRoute.Base.route) {
        composable(RibaRoute.Base.Manga.path) {
            val viewModel = remember {
                MangaDetailsViewModel(
                    state.service,
                    state.navigator.getArgument("id")
                        ?: throw IllegalArgumentException("id parameter is missing!")
                )
            }

            MangaDetailScreen(state, viewModel)
        }

        composable(RibaRoute.Base.Settings.path) {
            Text("Settings")
        }
    }
}