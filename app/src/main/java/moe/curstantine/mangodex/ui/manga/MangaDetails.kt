package moe.curstantine.mangodex.ui.manga

import androidx.compose.runtime.Composable
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewmodel.compose.viewModel
import moe.curstantine.mangodex.nav.MangoNavigator

@Composable
fun MangaDetails(
    mangoNavigator: MangoNavigator,
    viewModel: MangaDetailsViewModel = viewModel(factory = MangaDetailsViewModel.Companion.Factory)
) {
    val mangaId = mangoNavigator.getArgument("mangaId")

}

class MangaDetailsViewModel : ViewModel() {

    companion object {
        object Factory : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return MangaDetailsViewModel() as T
            }
        }
    }
}