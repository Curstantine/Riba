package moe.curstantine.riba

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.compose.rememberNavController
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import moe.curstantine.riba.api.APIService
import moe.curstantine.riba.nav.MangoRoute
import moe.curstantine.riba.nav.RibaNavHost
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.nav.RouteType
import moe.curstantine.riba.ui.common.components.MangoNavigationBar
import moe.curstantine.riba.ui.theme.MangoDexTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        APIService.initialize(applicationContext)

        setContent {
            val systemUiController = rememberSystemUiController()
            val navHostController = rememberNavController()
            val ribaNavigator = RibaNavigator(navHostController)

            MangoDexTheme(systemUiController) {
                Scaffold(
                    bottomBar = {
                        val navBackStackEntry by navHostController.currentBackStackEntryAsState()
                        val currentRoute = navBackStackEntry?.destination?.route

                        if (currentRoute != null) {
                            val route = MangoRoute.fromPath(currentRoute)
                            if (route.routeType == RouteType.Default) {
                                MangoNavigationBar(ribaNavigator)
                            }
                        }
                    },
                    content = { padding ->
                        RibaNavHost(ribaNavigator, Modifier.padding(padding))
                    },
                )
            }
        }
    }
}



