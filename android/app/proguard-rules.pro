# llamadart talks to llama.cpp through Dart FFI; keep any JNI-facing classes
# and native method signatures in case a plugin adds them.
-keepclasseswithmembernames class * {
    native <methods>;
}
-keep class dev.llamadart.** { *; }
-dontwarn dev.llamadart.**
