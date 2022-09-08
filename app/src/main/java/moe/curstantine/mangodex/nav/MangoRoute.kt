package moe.curstantine.mangodex.nav

sealed class MangoRoute(val path: String) {
    object Home : MangoRoute("home")
    object Search : MangoRoute("search")
    object Library : MangoRoute("library")
}