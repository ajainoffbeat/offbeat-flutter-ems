plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")   // Flutter Android embedding
    id("com.google.gms.google-services")      // Firebase / FCM
}

android {
    namespace = "com.offbeatsoftwaresolutions.ems"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // MUST match your real package name + Firebase config
        applicationId = "com.offbeatsoftwaresolutions.ems"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // For now use debug signing so `flutter run --release` works
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM – keeps versions aligned
    implementation(platform("com.google.firebase:firebase-bom:33.1.2"))

    // Firebase Cloud Messaging
    implementation("com.google.firebase:firebase-messaging")
}
