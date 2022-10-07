package moe.curstantine.riba

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.shrinkVertically
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.runtime.getValue
import androidx.core.view.WindowCompat
import androidx.navigation.compose.rememberNavController
import moe.curstantine.riba.api.APIService
import moe.curstantine.riba.nav.RibaNavHost
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.nav.RouteType
import moe.curstantine.riba.ui.common.components.MangoNavigationBar
import moe.curstantine.riba.ui.theme.RibaTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        APIService.initialize(applicationContext)
        WindowCompat.setDecorFitsSystemWindows(window, false)

        setContent {
            val ribaHostState = RibaHostState(
                RibaNavigator(rememberNavController()),
                SnackbarHostState(),
            )

            val currentRoute by ribaHostState.navigator.currentRouteAsState()

            RibaTheme {
                Scaffold(
                    content = { RibaNavHost(ribaHostState, it) },
                    snackbarHost = { SnackbarHost(ribaHostState.snackbarHost) },
                    bottomBar = {
                        AnimatedVisibility(
                            currentRoute.routeType == RouteType.Default,
                            exit = fadeOut() + shrinkVertically(),
                            enter = fadeIn() + expandVertically(),
                            content = { MangoNavigationBar(ribaHostState.navigator) }
                        )
                    },
                )
            }
        }
    }
}



