object AppConfig {
    const val applicationId = "moe.curstantine.riba"
    const val versionCode = 1
    const val versionName = "1.0"

    const val compileSdk = 33
    const val minSdk = 26
    const val targetSdk = 33
}

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.devtools.ksp") version "1.7.10-1.0.6"
}

android {
    compileSdk = AppConfig.compileSdk

    defaultConfig {
        applicationId = AppConfig.applicationId
        versionCode = AppConfig.versionCode
        versionName = AppConfig.versionName

        minSdk = AppConfig.minSdk
        targetSdk = AppConfig.targetSdk

        vectorDrawables {
            useSupportLibrary = true
        }
    }

    buildTypes {
        getByName("debug") {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
        }
        getByName("release") {
            isDebuggable = false
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles("proguard-android-optimize.txt", "proguard-rules.pro")
            signingConfig  = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_16
        targetCompatibility = JavaVersion.VERSION_16
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_16.toString()
    }

    buildFeatures {
        compose = true
    }

    composeOptions {
        kotlinCompilerExtensionVersion = compose.versions.compiler.version.get()
    }

    packagingOptions {
        resources {
            excludes.add("/META-INF/{AL2.0,LGPL2.1}")
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }

    namespace = "moe.curstantine.riba"
}

dependencies {
    implementation(androidx.bundles.androidx)

    implementation(compose.bundles.accompanist)
    implementation(compose.bundles.activity)
    implementation(compose.bundles.livedata)
    implementation(compose.bundles.material)
    implementation(compose.bundles.navigation)
    implementation(compose.bundles.ui)
    implementation(compose.bundles.room)

    implementation(external.coil)
    implementation(external.markdown)
    implementation(external.bundles.moshi)
    implementation(external.bundles.retrofit)

    ksp(compose.bundles.ksps)
    ksp(external.bundles.ksps)
}

tasks {
    withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
        kotlinOptions.freeCompilerArgs += listOf(
            "-opt-in=androidx.compose.material3.ExperimentalMaterial3Api",
        )
    }
}