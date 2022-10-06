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
import androidx.compose.runtime.getValue
import androidx.core.view.WindowCompat
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import moe.curstantine.riba.api.APIService
import moe.curstantine.riba.nav.MangoRoute
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
            val navHostController = rememberNavController()
            val ribaNavigator = RibaNavigator(navHostController)

            val navBackStackEntry by navHostController.currentBackStackEntryAsState()
            val route = MangoRoute.fromPath(
                navBackStackEntry?.destination?.route ?: MangoRoute.Vanilla.Home.path
            )

            RibaTheme {
                Scaffold(
                    bottomBar = {
                        AnimatedVisibility(
                            route.routeType == RouteType.Default,
                            exit = fadeOut() + shrinkVertically(),
                            enter = fadeIn() + expandVertically()
                        ) {
                            MangoNavigationBar(ribaNavigator)
                        }
                    },
                    content = { RibaNavHost(ribaNavigator, it) }
                )
            }
        }
    }
}



