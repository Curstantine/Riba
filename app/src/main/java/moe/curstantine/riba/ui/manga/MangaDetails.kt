package moe.curstantine.riba.ui.manga

import androidx.compose.foundation.layout.Column
import androidx.compose.runtime.*
import androidx.lifecycle.*
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import moe.curstantine.riba.api.APIService
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaFulfilledManga
import moe.curstantine.riba.nav.RibaNavigator

@Composable
fun MangaDetails(
    ribaNavigator: RibaNavigator,
    viewModel: MangaDetailsViewModel = viewModel(factory = MangaDetailsViewModel.Companion.Factory)
) {
    val mangaId = remember { ribaNavigator.getArgument("id") }
    viewModel.mangaId = mangaId ?: throw IllegalArgumentException("id parameter is missing!")

    Column {

    }
}

class MangaDetailsViewModel : ViewModel() {
    var mangaId by mutableStateOf("")
    fun getDetails(): LiveData<RibaResult<RibaFulfilledManga>> = details

    private val details: MutableLiveData<RibaResult<RibaFulfilledManga>> by lazy {
        MutableLiveData<RibaResult<RibaFulfilledManga>>().also { loadDetails() }
    }

    private fun loadDetails() {
        viewModelScope.launch(Dispatchers.IO) {
            // Manga is already fetched by the time we get here
            val localManga = APIService.database.manga().get(mangaId)!!

            val artist = async {
                try {
                    val local = APIService.database.author().get(localManga.artistIds)
                    val missingArtistIds = local.filter { it.name == null }.map { it.id }
                    val missingArtists = APIService.mangadex.getAuthor(missingArtistIds)
                } catch (e: Throwable) {

                }
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