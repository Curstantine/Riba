package moe.curstantine.riba.ui.library

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.MaterialTheme.typography
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.*
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.riba.RibaAPIService
import moe.curstantine.riba.api.riba.RibaError
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.api.riba.models.RibaMangaList
import moe.curstantine.riba.ui.common.components.FlexibleErrorReceiver
import moe.curstantine.riba.ui.common.components.FlexibleIndicator
import moe.curstantine.riba.ui.common.components.RibaBottomNavigationBarPreview
import moe.curstantine.riba.ui.mdlist.MDListCard
import moe.curstantine.riba.ui.mdlist.MDListCardData
import moe.curstantine.riba.ui.theme.RibaTheme

@Composable
fun LibraryScreen(state: RibaHostState, paddingValues: PaddingValues, viewModel: LibraryViewModel) {
	Column(
		modifier = Modifier
			.padding(paddingValues)
			.padding(top = 16.dp),
		content = { MDListRow(state, viewModel) },
	)
}

@Composable
private fun MDListRow(state: RibaHostState, viewModel: LibraryViewModel) {
	val list = viewModel.getMDLists().collectAsState()
	val currentUser = state.service.mangadex.user.currentUser.collectAsState()

	Column(
		modifier = Modifier
			.padding(horizontal = 12.dp)
			.height(250.dp),
		verticalArrangement = Arrangement.spacedBy(8.dp)
	) {
		Text(stringResource(R.string.md_lists), style = typography.titleMedium)

		if (list.value == null) {
			FlexibleIndicator()
		} else if (list.value!!.isFailure) {
			FlexibleErrorReceiver(error = list.value!!.exceptionOrNull()!! as RibaError)
		} else {
			LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
				items(list.value!!.getOrThrow()) {
					MDListCard(
						MDListCardData(
							list = it,
							user = currentUser.value!!.username,
							local = true
						)
					)
				}
			}
		}
	}
}

class LibraryViewModel(private val service: RibaAPIService) : ViewModel() {
	private val mdListOffset = MutableStateFlow<Int?>(0)

	fun getMDLists(): StateFlow<Result<List<RibaMangaList>>?> = _mdLists.asStateFlow()
	private val _mdLists: MutableStateFlow<Result<List<RibaMangaList>>?> by lazy {
		MutableStateFlow<Result<List<RibaMangaList>>?>(null).also { loadPersonalMDLists() }
	}


	private fun loadPersonalMDLists() = viewModelScope.launch(Dispatchers.IO) {
		service.mangadex.mdList.runCatching {
			getUserLists(dispatcher = Dispatchers.IO, limit = 50, offset = mdListOffset.value)
		}
			.onFailure { e -> _mdLists.emit(Result.failure(DexError.tryHandle(e))) }
			.onSuccess { response ->
				launch {
					val size = response.data.size
					val total = response.total

					if (size < total) mdListOffset.value = mdListOffset.value?.plus(size)
					else mdListOffset.value = null
				}

				val flattened = response.data.let {
					if (_mdLists.value?.isSuccess == true) _mdLists.value!!.getOrThrow() + it
					else it
				}

				_mdLists.emit(Result.success(flattened))
			}
	}

	companion object {
		fun Factory(service: RibaAPIService) = object : ViewModelProvider.Factory {
			@Suppress("UNCHECKED_CAST")
			override fun <T : ViewModel> create(modelClass: Class<T>): T {
				return LibraryViewModel(service) as T
			}
		}
	}
}

@Composable
@Preview(showBackground = true)
private fun LibraryScreenPreview() {
	val state = RibaHostState.createDummy()

	RibaTheme {
		Scaffold(bottomBar = { RibaBottomNavigationBarPreview(shouldSandbox = false) }) {
			LibraryScreen(
				state = state,
				paddingValues = it,
				viewModel = viewModel(factory = LibraryViewModel.Factory(state.service))
			)
		}
	}
}