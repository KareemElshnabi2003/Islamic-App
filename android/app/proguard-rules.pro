# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep public class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# JustAudio & AudioService
-keep class com.ryanheise.** { *; }
-dontwarn com.ryanheise.**

# Android Alarm Manager Plus
-keep class dev.fluttercommunity.plus.androidalarmmanager.** { *; }

# Geolocator
-keep class com.baseflow.geolocator.** { *; }

# Keep models and entities for JSON serialization / reflection
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
