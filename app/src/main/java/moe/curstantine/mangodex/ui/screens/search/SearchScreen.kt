package moe.curstantine.mangodex.ui.screens.search

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import moe.curstantine.mangodex.nav.MangoNavigator
import moe.curstantine.mangodex.ui.components.common.MangoScaffold

@Composable
fun SearchScreen(mangoNavigator: MangoNavigator) {
    MangoScaffold(mangoNavigator) { paddingInsets ->
        Column(modifier = Modifier.padding(paddingInsets)) {
            Text("Search")
        }
    }
}