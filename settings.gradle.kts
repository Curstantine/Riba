enableFeaturePreview("VERSION_CATALOGS")

pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven("https://jitpack.io")
    }
    versionCatalogs {
        create("kotlinx") {
            from(files("gradle/kotlinx.toml"))
        }
        create("androidx") {
            from(files("gradle/androidx.toml"))
        }
        create("compose") {
            from(files("gradle/compose.toml"))
        }
        create("external") {
            from(files("gradle/external.toml"))
        }
    }
}
rootProject.name = "MangoDex"
include(":app")
