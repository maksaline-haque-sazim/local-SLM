# R8/ProGuard only rewrites code (dex), never files under assets/, so the
# bundled .gguf model is not shrunk by it. Asset compression is turned off for
# *.gguf via `androidResources.noCompress` in build.gradle.

# llamadart talks to llama.cpp through Dart FFI; keep any JNI-facing classes
# and native method signatures in case a plugin adds them.
-keepclasseswithmembernames class * {
    native <methods>;
}
-keep class dev.llamadart.** { *; }
-dontwarn dev.llamadart.**
