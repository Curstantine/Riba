package moe.curstantine.riba.nav

/**
 * Internally used route to reference to different screens/pages.
 *
 * @property nestedPath Nested part of this path. **DO NOT** use this to navigate to different screens, check [route] instead.
 * @property route Route to navigate to. Use this to navigate to different screens.
 * @property type Which [Type] this route belongs to.
 */
sealed class RibaRoute(protected val nestedPath: String) {
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
		object About : RibaRoute("about")
	}

	val route: String
		get() {
			val annot = this.javaClass.enclosingClass.getAnnotation(InternalNester::class.java)
			return if (annot != null) annot.path + "/" + nestedPath else nestedPath
		}

	val type: Type
		get() {
			val annot = this.javaClass.enclosingClass.getAnnotation(InternalNester::class.java)
			return annot?.type ?: Type.Empty
		}

	/**
	 * Route type for different screens.
	 *
	 * - [Default] is used for landing pages, where the users have access to the bottom navigation bar.
	 * - [Empty] for routes without system insets/padding or nothing (except for the surface color provided by the main scaffold.
	 */
	enum class Type {
		Default,
		Empty,
	}

	companion object {
		private annotation class InternalNester(val path: String, val type: Type)

		/**
		 * Finds the [RibaRoute] from the given [route].
		 *
		 * @throws IllegalArgumentException if the given [route] is not a valid [RibaRoute].
		 */
		fun fromPath(route: String): RibaRoute {
			val parts = route.split("/").map { it.replace("\\{.*\\}".toRegex(), "") }

			return when (parts[0]) {
				"manga" -> Manga
				Landing.path -> when (parts[1]) {
					Landing.Home.nestedPath -> Landing.Home
					Landing.Library.nestedPath -> Landing.Library
					Landing.Search.nestedPath -> Landing.Search
					else -> throw IllegalArgumentException("Unknown route: $route")
				}
				Settings.path -> when (parts[1]) {
					Settings.Screen.nestedPath -> Settings.Screen
					Settings.General.nestedPath -> Settings.General
					Settings.Appearance.nestedPath -> Settings.Appearance
					Settings.About.nestedPath -> Settings.About
					else -> throw IllegalArgumentException("Unknown route: $route")
				}
				else -> throw IllegalArgumentException("Unknown route: $route")
			}
		}
	}
}