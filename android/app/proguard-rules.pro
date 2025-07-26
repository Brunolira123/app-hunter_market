# KEEP WindowManager (Jetpack WindowManager library)
-keep class androidx.window.** { *; }
-dontwarn androidx.window.**

# KEEP Sidecar (for foldable support)
-keep class androidx.window.sidecar.** { *; }
-dontwarn androidx.window.sidecar.**

# KEEP Extensions (for foldables/dual-screen)
-keep class androidx.window.extensions.** { *; }
-dontwarn androidx.window.extensions.**

# KEEP Google Maps dependencies
-keep class com.google.android.gms.maps.** { *; }
-dontwarn com.google.android.gms.maps.**

# Optional: keep location stuff
-keep class com.google.android.gms.location.** { *; }
-dontwarn com.google.android.gms.location.**
