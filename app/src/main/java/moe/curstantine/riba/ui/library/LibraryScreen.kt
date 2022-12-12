package moe.curstantine.riba.ui.library

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.material3.MaterialTheme.typography
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.lifecycle.*
import androidx.lifecycle.viewmodel.compose.viewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import moe.curstantine.riba.R
import moe.curstantine.riba.api.riba.RibaAPIService
import moe.curstantine.riba.api.riba.RibaHostState
import moe.curstantine.riba.api.riba.models.RibaMangaList
import moe.curstantine.riba.ui.common.components.RibaBottomNavigationBarPreview
import moe.curstantine.riba.ui.mdlist.MDListCard
import moe.curstantine.riba.ui.mdlist.MDListCardData
import moe.curstantine.riba.ui.theme.RibaTheme

@Composable
fun LibraryScreen(state: RibaHostState, paddingValues: PaddingValues, viewModel: LibraryViewModel) {
	Column(
		Modifier
			.padding(paddingValues)
			.padding(top = 16.dp)
	) {
		MDListRow()
	}
}

@Composable
private fun MDListRow() {
	Column(
		modifier = Modifier
			.padding(horizontal = 12.dp)
			.height(250.dp),
		verticalArrangement = Arrangement.spacedBy(8.dp)
	) {
		Text(stringResource(R.string.md_lists), style = typography.titleMedium)

		LazyRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
			items(10) {
				val rb = RibaMangaList.getDefault()
				MDListCard(
					MDListCardData(
						id = rb.id,
						name = rb.name,
						user = "Default"
					)
				)
			}
		}
	}
}

class LibraryViewModel(private val service: RibaAPIService) : ViewModel() {
	private val mdLists: MutableLiveData<Result<List<RibaMangaList>>> by lazy {
		MutableLiveData<Result<List<RibaMangaList>>>().also { loadPersonalMDLists() }
	}

	fun loadPersonalMDLists() = viewModelScope.launch(Dispatchers.IO) {
		service.mangadex.mdList.database
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