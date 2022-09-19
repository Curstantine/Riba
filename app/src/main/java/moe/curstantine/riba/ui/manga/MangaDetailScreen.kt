package moe.curstantine.riba.ui.manga

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.APIService
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.toMangoCover
import moe.curstantine.riba.api.riba.RibaError
import moe.curstantine.riba.api.riba.RibaResult
import moe.curstantine.riba.api.riba.models.RibaAuthor
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaResultManga
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.ui.common.components.FlexibleIndicator
import moe.curstantine.riba.ui.theme.RibaTheme

@Composable
fun MangaDetailScreen(
    ribaNavigator: RibaNavigator,
    viewModel: MangaDetailsViewModel = viewModel(factory = MangaDetailsViewModel.Companion.Factory)
) {
    viewModel.mangaId = remember {
        ribaNavigator.getArgument("id")
            ?: throw IllegalArgumentException("id parameter is missing!")
    }

    val manga = viewModel.getDetails().observeAsState()

    if (manga.value == null) {
        FlexibleIndicator()
    } else {
        MangaDetailBody(manga.value!!)
    }

}

@Composable
fun MangaDetailBody(details: RibaResultManga) {
    LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        val list = (0..75).map { it.toString() }
        items(count = list.size) {
            Text(
                text = list[it],
                style = MaterialTheme.typography.bodyLarge,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp)
            )
        }
    }

}

@Preview
@Composable
fun MangaDetailPreview() {
    RibaTheme {
        MangaDetailBody(RibaResultManga.getDefault())
    }
}

class MangaDetailsViewModel : ViewModel() {
    lateinit var mangaId: String

    fun getDetails(): LiveData<RibaResultManga> = details

    private val details: MutableLiveData<RibaResultManga> by lazy {
        MutableLiveData<RibaResultManga>().also { loadDetails() }
    }

    private fun loadDetails() {
        viewModelScope.launch(Dispatchers.IO) {
            // Manga is already fetched by the time we get here
            val localManga = APIService.database.manga().get(mangaId)!!

            val artists: Deferred<RibaResult<List<RibaAuthor>>> = async {
                conditionallyGetAuthorType(localManga.artistIds, Dispatchers.IO)
            }
            val authors: Deferred<RibaResult<List<RibaAuthor>>> = async {
                conditionallyGetAuthorType(localManga.authorIds, Dispatchers.IO)
            }
            val cover: Deferred<RibaResult<RibaCover?>> = async {
                if (localManga.coverId == null) {
                    return@async RibaResult.Success(null)
                }

                val local = APIService.database.cover().get(localManga.coverId)
                if (local?.fileName != null) {
                    return@async RibaResult.Success(local)
                }

                val remote = APIService.mangadex.getCover(localManga.coverId)
                if (remote is RibaResult.Success) {
                    return@async RibaResult.Success(remote.data.data.toMangoCover())
                } else return@async remote as RibaResult.Error

            }

            details.postValue(
                RibaResultManga(
                    manga = RibaResult.Success(localManga),
                    artists = artists.await(),
                    authors = authors.await(),
                    cover = cover.await(),
                )
            )

        }
    }

    private suspend fun conditionallyGetAuthorType(
        ids: List<String>,
        dispatcher: CoroutineDispatcher
    ): RibaResult<List<RibaAuthor>> {
        return withContext(dispatcher) {
            try {
                val local = APIService.database.author().get(ids)
                val missingArtistIds = local.filter { it.name == null }.map { it.id }

                if (missingArtistIds.isNotEmpty()) {
                    return@withContext when (
                        val missingArtists = APIService.mangadex.getAuthor(missingArtistIds)
                    ) {
                        is RibaResult.Error -> missingArtists
                        is RibaResult.Success -> {
                            RibaResult.Success(
                                APIService.database.author().get(ids)
                            )
                        }
                    }
                }

                return@withContext RibaResult.Success(local)
            } catch (e: Throwable) {
                return@withContext RibaResult.Error(RibaError.tryHandle(e))
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