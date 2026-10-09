package com.ilaalo.engine

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import com.ilaalo.engine.nativebridge.IlaaloNativeBridge
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "com.ilaalo.engine/native"
    private val smsPermissionRequestCode = 7001
    private var pendingPermissionResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val nativeBridge = IlaaloNativeBridge(this)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "requestSmsPermission" -> {
                    if (checkSelfPermission(Manifest.permission.RECEIVE_SMS) ==
                        PackageManager.PERMISSION_GRANTED
                    ) {
                        result.success(true)
                    } else if (pendingPermissionResult != null) {
                        result.error(
                            "PERMISSION_PENDING",
                            "Codsiga rukhsadda SMS hore ayuu u socdaa.",
                            null
                        )
                    } else {
                        pendingPermissionResult = result
                        requestPermissions(
                            arrayOf(Manifest.permission.RECEIVE_SMS),
                            smsPermissionRequestCode
                        )
                    }
                }

                else -> nativeBridge.handleMethod(call, result)
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode == smsPermissionRequestCode) {
            val granted = grantResults.isNotEmpty() &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED

            pendingPermissionResult?.success(granted)
            pendingPermissionResult = null
        }
    }
}
