package moe.curstantine.mangodex.ui.manga

import androidx.compose.runtime.*
import androidx.lifecycle.*
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import moe.curstantine.mangodex.api.APIService
import moe.curstantine.mangodex.api.mangadex.models.DexEntityType
import moe.curstantine.mangodex.api.mangodex.models.MangoFulfilledManga
import moe.curstantine.mangodex.nav.MangoNavigator

@Composable
fun MangaDetails(
    mangoNavigator: MangoNavigator,
    viewModel: MangaDetailsViewModel = viewModel(factory = MangaDetailsViewModel.Companion.Factory)
) {
    val mangaId = remember { mangoNavigator.getArgument("id") }
    viewModel.mangaId = mangaId ?: throw IllegalArgumentException("id parameter is missing!")
}

class MangaDetailsViewModel() : ViewModel() {
    var mangaId by mutableStateOf("")
    fun getDetails(): LiveData<Result<MangoFulfilledManga>> = details

    private val details: MutableLiveData<Result<MangoFulfilledManga>> by lazy {
        MutableLiveData<Result<MangoFulfilledManga>>().also {
            loadDetails()
        }
    }

    private fun loadDetails() {
        viewModelScope.launch(Dispatchers.IO) {
            // Manga is already fetched by the time we get here
            val localManga = APIService.database.manga().get(mangaId)!!

            val artist = async {
                val local = APIService.database.artist().get(localManga.artistIds)

                local.map { it.name == null }


            }

        }
    }

    private fun fullRefresh() {
        viewModelScope.launch(Dispatchers.IO) {
            APIService.mangadex.getManga(
                mangaId,
                listOf(
                    DexEntityType.CoverArt,
                    DexEntityType.Artist,
                    DexEntityType.Author,
                ),
            )
        }
    }

    companion object {
        object Factory : ViewModelProvider.Factory {
            @Suppress("UNCHECKED_CAST")
            override fun <T : ViewModel> create(modelClass: Class<T>): T {
                return MangaDetailsViewModel() as T
            }
        }
    }
}