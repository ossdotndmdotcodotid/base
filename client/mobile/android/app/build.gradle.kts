plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.compose.compiler)
}

repositories {
    google()
    mavenCentral()
}

dependencyLocking {
    lockAllConfigurations()
}

kotlin {
    jvmToolchain(providers.gradleProperty("ndm.jdkToolchain").get().toInt())
}

android {
    namespace = "id.co.ndm.base.android"
    compileSdk = 37
    buildToolsVersion = "37.0.0"

    defaultConfig {
        applicationId = "id.co.ndm.base.android"
        minSdk = 24
        targetSdk = 37
        versionCode = 1
        versionName = "0.0.1"
    }

    buildFeatures {
        compose = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.toVersion(providers.gradleProperty("ndm.javaSourceTarget").get())
        targetCompatibility = JavaVersion.toVersion(providers.gradleProperty("ndm.javaSourceTarget").get())
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"))
        }
    }
}

dependencies {
    implementation(libs.compose.ui)
    implementation(libs.compose.foundation)
    implementation(libs.compose.material3)
    implementation(libs.activity.compose)

    constraints {
        implementation(libs.coroutines.core)
        implementation(libs.coroutines.android)
        implementation(libs.lifecycle.runtime)
        implementation(libs.core)
        implementation(libs.annotation)
        implementation(libs.collection)
        implementation(libs.savedstate)
        implementation(libs.navigationevent)
        implementation(libs.profileinstaller)
        implementation(libs.emoji2)
        implementation(libs.tracing)
        implementation(libs.window)
        implementation(libs.graphics.path)
    }
}
