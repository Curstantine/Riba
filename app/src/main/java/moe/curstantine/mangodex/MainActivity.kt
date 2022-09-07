package moe.curstantine.mangodex

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.Scaffold
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
                    Column(modifier = Modifier.padding(paddingInsets)) {
                        // Texts with all the scales in typography as its type
                        Text("Body Small", style = MaterialTheme.typography.bodySmall)
                        Text("Body Medium", style = MaterialTheme.typography.bodyMedium)
                        Text("Body Large", style = MaterialTheme.typography.bodyLarge)

                        Text("Label Small", style = MaterialTheme.typography.labelSmall)
                        Text("Label Medium", style = MaterialTheme.typography.labelMedium)
                        Text("Label Large", style = MaterialTheme.typography.labelLarge)

                        Text("Title Small", style = MaterialTheme.typography.titleSmall)
                        Text("Title Medium", style = MaterialTheme.typography.titleMedium)
                        Text("Title Large", style = MaterialTheme.typography.titleLarge)

                        Text("Headline Small", style = MaterialTheme.typography.headlineSmall)
                        Text("Headline Medium", style = MaterialTheme.typography.headlineMedium)
                        Text("Headline Large", style = MaterialTheme.typography.headlineLarge)

                        Text("Display Small", style = MaterialTheme.typography.displaySmall)
                        Text("Display Medium", style = MaterialTheme.typography.displayMedium)
                        Text("Display Large", style = MaterialTheme.typography.displayLarge)
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