enableFeaturePreview("VERSION_CATALOGS")

pluginManagement {
    resolutionStrategy {
        eachPlugin {
            val regex = "com.android.(library|application)".toRegex()
            if (regex matches requested.id.id) {
                useModule("com.android.tools.build:gradle:${requested.version}")
            }
        }
    }
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
    }
}
rootProject.name = "MangoDex"
include(":app")
