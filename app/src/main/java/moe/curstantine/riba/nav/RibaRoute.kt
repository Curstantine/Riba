package moe.curstantine.riba.nav

sealed class RibaRoute(val path: String, val type: Type) {
	object Settings : RibaRoute("settings", Type.Empty)
	object Manga : RibaRoute("manga/{id}", Type.Empty)
	object Home : RibaRoute("home", Type.Default)
	object Search : RibaRoute("search", Type.Default)
	object Library : RibaRoute("library", Type.Default)

	enum class Type {
		Default,
		Empty,
	}

	companion object {
		const val route = "root"
		const val baseRoute = "base"
		const val vanillaRoute = "vanilla"

		/**
		 * @throws [NoSuchElementException] if route doesn't exist.
		 */
		fun fromPath(path: String): RibaRoute = when (path) {
			Home.path -> Home
			Settings.path -> Settings
			Manga.path -> Manga
			Search.path -> Search
			Library.path -> Library
			else -> throw NoSuchElementException("Route $path doesn't exist!")
		}
	}
}