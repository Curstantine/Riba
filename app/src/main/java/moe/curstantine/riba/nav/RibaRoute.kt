package moe.curstantine.riba.nav

enum class RouteType {
    Default,
    Empty,
}

sealed class RibaRoute(val path: String, val routeType: RouteType) {
    object Base {
        const val route = "base"

        object Settings : RibaRoute("settings", RouteType.Empty)
        object Manga : RibaRoute("manga/{id}", RouteType.Empty)

        /**
         * **ROUTE DOES NOT EXIST**
         *
         * Used as a utility to filter an action.
         */
        object SignIn : RibaRoute("sign_in", RouteType.Empty)

        /**
         * **ROUTE DOES NOT EXIST**
         *
         * Used as a utility to filter an action.
         */
        object SignUp : RibaRoute("sign_up", RouteType.Empty)

        /**
         * **ROUTE DOES NOT EXIST**
         *
         * Used as a utility to filter an action.
         */
        object SignOut : RibaRoute("sign_out", RouteType.Empty)
    }

    object Vanilla {
        const val route = "vanilla"

        object Home : RibaRoute("home", RouteType.Default)
        object Search : RibaRoute("search", RouteType.Default)
        object Library : RibaRoute("library", RouteType.Default)
    }

    companion object {
        const val route = "root"

        fun fromPath(path: String): RibaRoute {
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