package moe.curstantine.mangodex.nav

enum class RouteType {
    Default,
    Empty,
}

sealed class MangoRoute(val path: String, val routeType: RouteType) {
    object Home : MangoRoute("home", RouteType.Default)
    object Search : MangoRoute("search", RouteType.Default)
    object Library : MangoRoute("library", RouteType.Default)
    object Settings : MangoRoute("settings", RouteType.Empty)

    companion object {
        fun fromPath(path: String): MangoRoute {
            return when (path) {
                Home.path -> Home
                Search.path -> Search
                Library.path -> Library
                Settings.path -> Settings
                else -> Home
            }
        }
    }
}