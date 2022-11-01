package moe.curstantine.riba.api.riba

import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.LocalContext
import androidx.navigation.compose.rememberNavController
import moe.curstantine.riba.nav.RibaNavigator

data class RibaHostState(
	val navigator: RibaNavigator,
	val snackbarHost: SnackbarHostState,
	val service: RibaAPIService,
	val settings: RibaSettings,
) {
	companion object {
		@Composable
		fun create(): RibaHostState {
			val context = LocalContext.current

			return RibaHostState(
				RibaNavigator(rememberNavController()),
				remember { SnackbarHostState() },
				remember { RibaAPIService(context) },
				remember { RibaSettings(context) },
			)
		}


		@Composable
		fun createDummy() = RibaHostState(
			RibaNavigator.createDummy(),
			SnackbarHostState(),
			RibaAPIService.createDummy(),
			RibaSettings.createDummy(),
		)
	}
}