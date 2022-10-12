package moe.curstantine.riba

import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.Composable
import moe.curstantine.riba.api.riba.RibaAPIService
import moe.curstantine.riba.nav.RibaNavigator

data class RibaHostState(
    val navigator: RibaNavigator,
    val snackbarHost: SnackbarHostState,
    val service: RibaAPIService,
) {
    companion object {
        @Composable
        fun createDummy() = RibaHostState(
            navigator = RibaNavigator.createDummy(),
            snackbarHost = SnackbarHostState(),
            service = RibaAPIService.createDummy(),
        )
    }
}