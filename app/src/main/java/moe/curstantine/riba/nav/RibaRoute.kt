package moe.curstantine.riba.nav

annotation class InternalNester(val path: String, val type: RibaRoute.Type)

/**
 * Internally used route to reference to different screens/pages.
 *
 * @property path Path of the route. DO NOT use this to navigate to different screens, check [route] instead.
 * @property route Route to navigate to. Use this to navigate to different screens.
 */
sealed class RibaRoute(internal val path: String) {
	object Manga : RibaRoute("manga/{id}")

	@InternalNester(path = "landing", type = Type.Default)
	object Landing {
		const val path = "landing"

		object Home : RibaRoute("home")
		object Library : RibaRoute("library")
		object Search : RibaRoute("search")
	}

	@InternalNester(path = "settings", type = Type.Empty)
	object Settings {
		const val path = "settings"

		object Screen : RibaRoute("screen")
		object General : RibaRoute("general")
		object Appearance : RibaRoute("appearance")
		object Language : RibaRoute("language")
		object About : RibaRoute("about")
	}

	val route: String
		get() {
			val annot = this.javaClass.enclosingClass.getAnnotation(InternalNester::class.java)
			return if (annot != null) annot.path + "/" + path else path
		}

	val type: Type
		get() {
			val annot = this.javaClass.enclosingClass.getAnnotation(InternalNester::class.java)
			return annot?.type ?: Type.Empty
		}

	enum class Type {
		Default,
		Empty,
	}

	companion object {
		/**
		 * Finds the route from the given [route].
		 */
		fun fromPath(route: String): RibaRoute {
			val parts = route.split("/").map { it.replace("\\{.*\\}".toRegex(), "") }

			return when (parts[0]) {
				"manga" -> Manga
				Landing.path -> when (parts[1]) {
					Landing.Home.path -> Landing.Home
					Landing.Library.path -> Landing.Library
					Landing.Search.path -> Landing.Search
					else -> throw IllegalArgumentException("Unknown route: $route")
				}
				Settings.path -> when (parts[1]) {
					Settings.Screen.path -> Settings.Screen
					Settings.General.path -> Settings.General
					Settings.Appearance.path -> Settings.Appearance
					Settings.Language.path -> Settings.Language
					Settings.About.path -> Settings.About
					else -> throw IllegalArgumentException("Unknown route: $route")
				}
				else -> throw IllegalArgumentException("Unknown route: $route")
			}
		}
	}
}