package moe.curstantine.mangodex

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.navigation.compose.rememberNavController
import com.google.accompanist.systemuicontroller.rememberSystemUiController
import moe.curstantine.mangodex.nav.MangoNavHost
import moe.curstantine.mangodex.ui.theme.MangoDexTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val systemUiController = rememberSystemUiController()
            val navHostController = rememberNavController()

            MangoDexTheme(systemUiController) {
                MangoNavHost(navHostController)
            }
        }
    }
}



