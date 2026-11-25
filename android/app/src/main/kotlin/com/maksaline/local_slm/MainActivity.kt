package com.maksaline.local_slm

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.FlutterInjector
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "local_slm/asset_copier",
        )
        val mainHandler = Handler(Looper.getMainLooper())


        channel.setMethodCallHandler { call, result ->
            if (call.method != "copyAsset") {
                result.notImplemented()
                return@setMethodCallHandler
            }
            val asset = call.argument<String>("asset")
            val destination = call.argument<String>("destination")
            if (asset == null || destination == null) {
                result.error("bad_args", "asset and destination are required", null)
                return@setMethodCallHandler
            }

            Thread {
                try {
                    val key = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(asset)
                    val total = try {
                        assets.openFd(key).use { it.length }
                    } catch (_: Exception) {
                        -1L
                    }
                    File(destination).parentFile?.mkdirs()
                    var copied = 0L
                    var lastReported = -1
                    assets.open(key).use { input ->
                        File(destination).outputStream().use { output ->
                            val buffer = ByteArray(1024 * 1024)
                            while (true) {
                                val read = input.read(buffer)
                                if (read < 0) break
                                output.write(buffer, 0, read)
                                copied += read
                                if (total > 0) {
                                    val percent = (copied * 100 / total).toInt()
                                    if (percent != lastReported) {
                                        lastReported = percent
                                        mainHandler.post {
                                            channel.invokeMethod(
                                                "progress",
                                                mapOf("fraction" to copied.toDouble() / total),
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                    mainHandler.post { result.success(null) }
                } catch (e: Exception) {
                    mainHandler.post { result.error("copy_failed", e.toString(), null) }
                }
            }.start()
        }
    }
}
