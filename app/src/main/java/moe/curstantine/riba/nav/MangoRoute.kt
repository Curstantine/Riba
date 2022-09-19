package moe.curstantine.riba.nav

enum class RouteType {
    Default,
    Empty,
}

sealed class MangoRoute(val path: String, val routeType: RouteType) {
    object Base {
        const val route = "base"

        object Settings : MangoRoute("settings", RouteType.Empty)
        object Manga : MangoRoute("manga/{id}", RouteType.Empty)
    }

    object Vanilla {
        const val route = "vanilla"

        object Home : MangoRoute("home", RouteType.Default)
        object Search : MangoRoute("search", RouteType.Default)
        object Library : MangoRoute("library", RouteType.Default)
    }

    companion object {
        const val route = "root"

        fun fromPath(path: String): MangoRoute {
            return when (path) {
                Vanilla.Home.path -> Vanilla.Home
                Vanilla.Search.path -> Vanilla.Search
                Vanilla.Library.path -> Vanilla.Library
                Base.Settings.path -> Base.Settings
                Base.Manga.path -> Base.Manga
                else -> throw IllegalArgumentException("No route found for path: $path")
            }
        }
    }
}