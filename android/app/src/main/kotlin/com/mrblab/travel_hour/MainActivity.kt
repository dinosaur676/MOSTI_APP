package com.mrblab.travel_hour

import androidx.annotation.NonNull
import com.example.opencv_test.ScanCardResult
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.OpenCVLoader

class MainActivity: FlutterActivity() {

    init {
        System.loadLibrary("TrustWalletCore")
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        OpenCVLoader.initDebug()
        val channel = MethodChannel(flutterEngine.getDartExecutor(), "com.example.mosti")
        channel.setMethodCallHandler(handler)
    }

    private val handler: MethodChannel.MethodCallHandler = MethodChannel.MethodCallHandler { methodCall, result ->
        if (methodCall.method.equals("scanCardResult")) {
            val scanCardResult = ScanCardResult(methodCall.argument("data")!!, methodCall.argument("width")!!, methodCall.argument("height")!!,
                    result, this)
            scanCardResult.start()
        } else {
            result.notImplemented()
        }
    }

}
