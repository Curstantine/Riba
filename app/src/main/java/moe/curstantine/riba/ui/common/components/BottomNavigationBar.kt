package moe.curstantine.riba.ui.common.components

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Home
import androidx.compose.material.icons.rounded.LibraryBooks
import androidx.compose.material.icons.rounded.Search
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.stringResource
import moe.curstantine.riba.R
import moe.curstantine.riba.nav.RibaNavigator
import moe.curstantine.riba.nav.MangoRoute

@Composable
fun MangoNavigationBar(ribaNavigator: RibaNavigator) {
    NavigationBar {

        for (item in MangoNavigationBarItem.values()) {
            NavigationBarItem(
                icon = item.icon,
                label = item.label,
                selected = ribaNavigator.currentRoute() == item.route.path,
                onClick = { ribaNavigator.navigateTo(item.route) },
            )
        }
    }
}

sealed class MangoNavigationBarItem(
    val route: MangoRoute,
    val icon: @Composable () -> Unit,
    val label: @Composable () -> Unit,
) {
    object Home : MangoNavigationBarItem(
        route = MangoRoute.Home,
        icon = { Icon(Icons.Rounded.Home, contentDescription = "Home") },
        label = { Text(stringResource(R.string.home)) },
    )

    object Search : MangoNavigationBarItem(
        route = MangoRoute.Search,
        icon = { Icon(Icons.Rounded.Search, contentDescription = "Search") },
        label = { Text(stringResource(R.string.search)) },
    )

    object Library : MangoNavigationBarItem(
        route = MangoRoute.Library,
        icon = { Icon(Icons.Rounded.LibraryBooks, contentDescription = "Library") },
        label = { Text(stringResource(R.string.library)) },
    )

    companion object {
        fun values(): List<MangoNavigationBarItem> {
            return listOf(Home, Library, Search)
        }
    }
}