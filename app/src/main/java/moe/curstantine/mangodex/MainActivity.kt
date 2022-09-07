package moe.curstantine.mangodex

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import moe.curstantine.mangodex.ui.theme.MangoDexTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            MangoDexTheme {

                Scaffold(bottomBar = { MainBottomNav() }) { paddingInsets ->
                    Surface(modifier = Modifier.padding(paddingInsets)) {
                        Text(text = "Hello World")
                    }
                }
            }
        }
    }
}

@Composable
fun MainBottomNav() {
    NavigationBar() {

    }
}