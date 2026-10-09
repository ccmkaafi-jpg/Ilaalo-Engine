package com.ilaalo.engine.nativebridge

import android.content.Context
import com.ilaalo.engine.services.ZaadSmsReceiver
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

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
                        "nativeBridge" to "ready",
                        "smsDetection" to "receiver-installed"
                    )
                )
            }

            "getPendingZaadSms" -> {
                val prefs = context.getSharedPreferences(
                    ZaadSmsReceiver.PREFS_NAME,
                    Context.MODE_PRIVATE
                )

                val queue = try {
                    JSONArray(
                        prefs.getString(
                            ZaadSmsReceiver.QUEUE_KEY,
                            "[]"
                        ) ?: "[]"
                    )
                } catch (_: Exception) {
                    JSONArray()
                }

                val events = (0 until queue.length()).mapNotNull { index ->
                    val item = queue.optJSONObject(index) ?: return@mapNotNull null
                    mapOf(
                        "id" to item.optString("id"),
                        "sender" to item.optString("sender"),
                        "body" to item.optString("body"),
                        "timestamp" to item.optLong("timestamp")
                    )
                }

                result.success(events)
            }

            else -> result.notImplemented()
        }
    }
}
