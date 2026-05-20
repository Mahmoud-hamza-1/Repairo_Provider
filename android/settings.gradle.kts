pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// Flutter 3.44+ warns when plugin build.gradle files declare kotlin-android / KGP.
// Strip those lines before evaluation; the Flutter Gradle plugin applies KGP when needed.
fun stripLegacyKgpFromGradleScript(text: String): String {
    var result = text
    result = result.replace(
        Regex("(?m)^[ \\t]*apply plugin: ['\"](?:kotlin-android|org\\.jetbrains\\.kotlin\\.android)['\"][ \\t]*\\r?\\n"),
        "",
    )
    result = result.replace(
        Regex("(?m)^[ \\t]*id\\([\"'](?:kotlin-android|org\\.jetbrains\\.kotlin\\.android)[\"']\\)[ \\t]*\\r?\\n"),
        "",
    )
    result = result.replace(
        Regex("(?m)^[ \\t]*classpath[^\\n]*kotlin-gradle-plugin[^\\n]*\\r?\\n"),
        "",
    )
    result = result.replace(
        Regex("(?m)^def isAgp9OrAbove[^\n]*\n"),
        "",
    )
    result = result.replace(
        Regex("(?ms)[ \\t]*if \\(!isAgp9OrAbove\\) \\{[^}]*\\}\\s*"),
        "",
    )
    return result
}

val legacyKgpFlutterPlugins =
    setOf(
        "audioplayers_android",
        "file_picker",
        "image_picker_android",
        "location",
        "pusher_channels_flutter",
        "record_android",
        "shared_preferences_android",
    )

fun patchLegacyKgpPluginBuildFiles(flutterProjectRoot: java.io.File) {
    val depsFile = java.io.File(flutterProjectRoot, ".flutter-plugins-dependencies")
    if (!depsFile.exists()) return
    val json = depsFile.readText()
    for (pluginName in legacyKgpFlutterPlugins) {
        val pathMatch =
            Regex(""""name":"$pluginName","path":"((?:\\.|[^"\\])+)"""")
                .find(json) ?: continue
        val pluginRoot = java.io.File(pathMatch.groupValues[1])
        val androidDir = java.io.File(pluginRoot, "android")
        if (!androidDir.isDirectory) continue
        androidDir.listFiles()?.filter { it.name.startsWith("build.gradle") }?.forEach { buildFile ->
                val text = buildFile.readText()
                if (!text.contains("kotlin-android") &&
                    !text.contains("org.jetbrains.kotlin.android")
                ) {
                    return@forEach
                }
                val stripped = stripLegacyKgpFromGradleScript(text)
                if (stripped != text) {
                    buildFile.writeText(stripped)
                }
            }
    }
}

patchLegacyKgpPluginBuildFiles(settings.rootDir.parentFile)

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
