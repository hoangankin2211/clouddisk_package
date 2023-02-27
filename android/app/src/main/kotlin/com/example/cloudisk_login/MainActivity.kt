package com.example.cloudisk_login

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "sample.flutter.dev/methodChannel";
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call,
                                 result ->
            when (call.method) {
                "openCloudDiskApp" -> {
                    result.success(startActivity(
                        FlutterActivity
                            .withNewEngine()
                            .initialRoute("/")
                            .build(this)
                    ));
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    private fun handleOpenCloudDiskApp(result:MethodChannel.Result){
//        val location = getCurrentLocation();
//        result.success(location);


//        flutterEngine = FlutterEngine(this)
//
//        // Start executing Dart code to pre-warm the FlutterEngine.
//        flutterEngine.dartExecutor.executeDartEntrypoint(
//            DartExecutor.DartEntrypoint.createDefault()
//        )
        startActivity(
            FlutterActivity
                .withNewEngine()
                .initialRoute("/")
                .build(this)
        )
    }
}
