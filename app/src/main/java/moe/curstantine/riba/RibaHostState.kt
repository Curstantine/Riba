package moe.curstantine.riba

import androidx.compose.material3.SnackbarHostState
import moe.curstantine.riba.nav.RibaNavigator

data class RibaHostState(
    val navigator: RibaNavigator,
    val snackbarHost: SnackbarHostState,
)