package moe.curstantine.riba.ui.home

import android.util.Log
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.api.mangadex.DexConstants
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderProperty
import moe.curstantine.riba.api.mangadex.models.DexQueryOrderValue
import moe.curstantine.riba.api.riba.RibaAPIService
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaFulFilledManga
import moe.curstantine.riba.api.riba.models.RibaManga
import moe.curstantine.riba.ui.common.components.AccountRow
import moe.curstantine.riba.ui.manga.MangaCardRow

@Composable
fun HomeScreen(state: RibaHostState, paddingValues: PaddingValues, viewModel: HomeViewModel) {
	Column(
		modifier = Modifier
			.padding(bottom = paddingValues.calculateBottomPadding())
			.verticalScroll(rememberScrollState()),
		verticalArrangement = Arrangement.spacedBy(8.dp)
	) {
		AccountRow(state, paddingValues)

		MangaCardRow(
			state.navigator,
			viewModel.getSeasonal(),
			stringResource(R.string.seasonal)
		)
		MangaCardRow(
			state.navigator,
			viewModel.getRecent(),
			stringResource(R.string.recently_added)
		)
	}
}


class HomeViewModel(private val service: RibaAPIService) : ViewModel() {
	fun getSeasonal(): LiveData<Result<List<RibaFulFilledManga>>> = seasonal
	fun getRecent(): LiveData<Result<List<RibaFulFilledManga>>> = recent

	private val seasonal: MutableLiveData<Result<List<RibaFulFilledManga>>> by lazy {
		MutableLiveData<Result<List<RibaFulFilledManga>>>().also { loadSeasonal() }
	}

	private val recent: MutableLiveData<Result<List<RibaFulFilledManga>>> by lazy {
		MutableLiveData<Result<List<RibaFulFilledManga>>>().also { loadRecent() }
	}

	private fun loadSeasonal() = viewModelScope.launch(Dispatchers.IO) {
		Log.i(DexLogTag.DEBUG.tagName, "Loading seasonal list.")

		val list = service.mangadex.mdList.runCatching {
			get(Dispatchers.IO, DexConstants.SEASONAL_LIST, tryDatabase = true)
		}
			.onFailure { return@launch seasonal.postValue(Result.failure(it)) }
			.getOrThrow()

		val titles = service.mangadex.manga.runCatching {
			getStrictCollection(Dispatchers.IO, ids = list.titles)
		}
			.onFailure { return@launch seasonal.postValue(Result.failure(it)) }
			.getOrThrow()


		val coverAssociates: Map<String, RibaCover?> = titles
			.filter { it.coverId != null }
			.associateBy<RibaManga, String, RibaCover?>({ it.coverId!! }, { null }).toMutableMap()
			.apply {
				service.mangadex.manga.runCatching {
					getCoverCollection(
						dispatcher = Dispatchers.IO,
						ids = this@apply.keys.toList(),
						limit = this@apply.size
					)
				}.onSuccess { it.forEach { cover -> this[cover.id] = cover } }
			}

		val fulfilledTitles = titles.map {
			RibaFulFilledManga.fromNullables(manga = it, cover = coverAssociates[it.coverId])
		}

		return@launch seasonal.postValue(Result.success(fulfilledTitles))
	}

	private fun loadRecent() = viewModelScope.launch(Dispatchers.IO) {
		Log.i(DexLogTag.DEBUG.tagName, "Loading recent list.")

		val titles = service.mangadex.manga.runCatching {
			getCollection(
				dispatcher = Dispatchers.IO,
				limit = 25,
				sort = Pair(DexQueryOrderProperty.CreatedAt, DexQueryOrderValue.Descending)
			)
		}
			.onFailure { return@launch recent.postValue(Result.failure(it)) }
			.getOrThrow()

		val coverAssociates: Map<String, RibaCover?> = titles
			.filter { it.coverId != null }
			.associateBy<RibaManga, String, RibaCover?>({ it.coverId!! }, { null }).toMutableMap()
			.apply {
				service.mangadex.manga.runCatching {
					getCoverCollection(
						dispatcher = Dispatchers.IO,
						ids = this@apply.keys.toList(),
						limit = this@apply.size
					)
				}.onSuccess { it.forEach { cover -> this[cover.id] = cover } }
			}

		val fulfilledTitles = titles.map {
			RibaFulFilledManga.fromNullables(manga = it, cover = coverAssociates[it.coverId])
		}

		return@launch recent.postValue(Result.success(fulfilledTitles))
	}
}