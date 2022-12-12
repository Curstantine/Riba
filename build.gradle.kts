buildscript {
    dependencies {
        classpath("com.android.tools.build:gradle:7.3.1")
    }
}
//buildscript {
//	dependencies {
//		classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.7.10")
//	}
//}

// Related: https://youtrack.jetbrains.com/issue/KTIJ-19369
@Suppress("DSL_SCOPE_VIOLATION")
plugins {
	alias(androidx.plugins.application) apply false
	alias(androidx.plugins.library) apply false
	alias(kotlinx.plugins.android) apply false
}

tasks.register("clean", Delete::class) {
	delete(rootProject.buildDir)
}