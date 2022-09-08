package moe.curstantine.mangodex

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
import moe.curstantine.mangodex.nav.MangoNavHost
import moe.curstantine.mangodex.nav.MangoNavigator
import moe.curstantine.mangodex.nav.MangoRoute
import moe.curstantine.mangodex.nav.RouteType
import moe.curstantine.mangodex.ui.components.common.MangoNavigationBar
import moe.curstantine.mangodex.ui.theme.MangoDexTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val systemUiController = rememberSystemUiController()
            val navHostController = rememberNavController()
            val mangoNavigator = MangoNavigator(navHostController)

            MangoDexTheme(systemUiController) {
                Scaffold(
                    bottomBar = {
                        val navBackStackEntry by navHostController.currentBackStackEntryAsState()
                        val currentRoute = navBackStackEntry?.destination?.route

                        if (currentRoute != null) {
                            val mangoRoute = MangoRoute.fromPath(currentRoute)

                            if (mangoRoute.routeType == RouteType.Default) {
                                MangoNavigationBar(mangoNavigator)
                            }
                        }
                    },
                    content = { padding ->
                        MangoNavHost(mangoNavigator, Modifier.padding(padding))
                    },
                )
            }
        }
    }
}



