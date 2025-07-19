# Add project specific ProGuard rules here.

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Google Play Core classes are handled by Flutter - no need to keep explicitly

# Keep SMS Autofill classes
-keep class com.jaumard.smsautofill.** { *; }

# Keep Flutter related classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }

# Keep model classes (update with your actual model package)
-keep class com.legalnetwork.leagel.model.** { *; }

# Suppress warnings for optional dependencies
-dontwarn javax.annotation.**
-dontwarn javax.lang.model.** 