# Flutter-specific keep rules
-keep class io.flutter.** { *; }
-keep class com.google.firebase.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
-dontwarn com.google.firebase.**

# Add rules for any native libs or obfuscation issues if needed
