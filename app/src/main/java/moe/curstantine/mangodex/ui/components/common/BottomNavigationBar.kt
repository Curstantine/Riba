package moe.curstantine.mangodex.ui.components.common

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Home
import androidx.compose.material.icons.rounded.LibraryBooks
import androidx.compose.material.icons.rounded.Search
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import moe.curstantine.mangodex.nav.MangoNavigator
import moe.curstantine.mangodex.nav.MangoRoute

@Composable
fun MangoNavigationBar(mangoNavigator: MangoNavigator) {
    NavigationBar() {

        for (item in MangoNavigationBarItem.values()) {
            NavigationBarItem(
                icon = item.icon,
                label = item.label,
                selected = mangoNavigator.currentRoute() == item.route.path,
                onClick = { mangoNavigator.navigateTo(item.route) },
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
        label = { Text("Home") },
    )

    object Search : MangoNavigationBarItem(
        route = MangoRoute.Search,
        icon = { Icon(Icons.Rounded.Search, contentDescription = "Search") },
        label = { Text("Search") },
    )

    object Library : MangoNavigationBarItem(
        route = MangoRoute.Library,
        icon = { Icon(Icons.Rounded.LibraryBooks, contentDescription = "Library") },
        label = { Text("Library") },
    )


    companion object {
        fun values(): List<MangoNavigationBarItem> {
            return listOf(Home, Search, Library)
        }
    }
}