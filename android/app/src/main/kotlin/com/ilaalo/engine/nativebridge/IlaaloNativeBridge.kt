package com.ilaalo.engine.nativebridge

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class IlaaloNativeBridge(
    private val context: Context
) {

    fun handleMethod(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "getPlatformStatus" -> {
                result.success(
                    mapOf(
                        "platform" to "Android",
                        "nativeBridge" to "ready"
                    )
                )
            }

            else -> {
                result.notImplemented()
            }
        }
    }
}
