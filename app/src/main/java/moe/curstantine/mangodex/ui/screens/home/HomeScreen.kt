package moe.curstantine.mangodex.ui.screens.home

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import moe.curstantine.mangodex.R
import moe.curstantine.mangodex.nav.MangoNavigator

@Composable
fun HomeScreen(mangoNavigator: MangoNavigator) {
    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Column(
            Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {

            Text(
                stringResource(R.string.recently_added),
                style = MaterialTheme.typography.titleMedium
            )
//            LazyRow(content = {})
        }


        Column(
            Modifier.padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {

            Text(stringResource(R.string.md_lists), style = MaterialTheme.typography.titleMedium)
//            LazyRow(content = {})
        }
    }
}