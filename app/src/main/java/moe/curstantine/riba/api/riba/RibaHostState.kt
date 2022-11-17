package moe.curstantine.riba.api.riba

import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.platform.LocalContext
import androidx.navigation.compose.rememberNavController
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import moe.curstantine.riba.nav.RibaNavigator

data class RibaHostState(
	val applicationScope: CoroutineScope,
	val navigator: RibaNavigator,
	val snackbarHost: SnackbarHostState,
	val service: RibaAPIService,
	val settings: RibaSettings,
) {
	companion object {
		@Composable
		fun create(): RibaHostState {
			val context = LocalContext.current
			val applicationScope = CoroutineScope(SupervisorJob())

			return RibaHostState(
				applicationScope,
				RibaNavigator(rememberNavController()),
				remember { SnackbarHostState() },
				remember { RibaAPIService(context, applicationScope) },
				remember { RibaSettings(context) },
			)
		}


		@Composable
		fun createDummy() = RibaHostState(
			CoroutineScope(SupervisorJob()),
			RibaNavigator.createDummy(),
			SnackbarHostState(),
			RibaAPIService.createDummy(),
			RibaSettings.createDummy(),
		)
	}
}