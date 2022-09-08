package moe.curstantine.mangodex.ui.components.common

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import moe.curstantine.mangodex.nav.MangoNavigator

@Composable
fun MangoScaffold(mangoNavigator: MangoNavigator, content: @Composable (PaddingValues) -> Unit) {
    Scaffold(bottomBar = { MangoNavigationBar(mangoNavigator) }) {
        content(it)
    }
}