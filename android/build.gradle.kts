allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Force every Android application/library subproject to compile with API 36.
// Important on Flutter/Gradle: some plugins set compileSdk after plugin application,
// so we apply the value both immediately and again after evaluation.
subprojects {
    plugins.withId("com.android.application") {
        extensions.configure<com.android.build.api.dsl.ApplicationExtension>("android") {
            compileSdk = 36
        }
    }
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.api.dsl.LibraryExtension>("android") {
            compileSdk = 36
        }
    }

    afterEvaluate {
        plugins.withId("com.android.application") {
            extensions.configure<com.android.build.api.dsl.ApplicationExtension>("android") {
                compileSdk = 36
            }
        }
        plugins.withId("com.android.library") {
            extensions.configure<com.android.build.api.dsl.LibraryExtension>("android") {
                compileSdk = 36
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
