package com.staht.connect
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat



class MainActivity: FlutterActivity() {




    private val CHANNEL = "samples.flutter.dev/battery"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else if (call.method == "getBatteryLevel2") {
                val batteryLevel = getBatteryLevel2()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            }else if (call.method == "changeIcon") {
                val batteryLevel = getBatteryLevel2()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
    private fun getBatteryLevel(): Int {

        if ( false && android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            if (ContextCompat.checkSelfPermission(this@MainActivity, "android.permission.BLUETOOTH_CONNECT") !== PackageManager.PERMISSION_GRANTED) {
                if (ActivityCompat.shouldShowRequestPermissionRationale(this@MainActivity, "android.permission.BLUETOOTH_CONNECT")) {
                    ActivityCompat.requestPermissions(this@MainActivity,
                            arrayOf("android.permission.BLUETOOTH_CONNECT"), 1)
                } else {
                    ActivityCompat.requestPermissions(this@MainActivity,
                            arrayOf("android.permission.BLUETOOTH_CONNECT"), 1)
                }
            }
        }



//        if (ContextCompat.checkSelfPermission(this@MainActivity, "android.permission.BLUETOOTH_CONNECT") !== PackageManager.PERMISSION_GRANTED) {
//            if (ActivityCompat.shouldShowRequestPermissionRationale(this@MainActivity, "android.permission.BLUETOOTH_CONNECT")) {
//                ActivityCompat.requestPermissions(this@MainActivity,
//                        arrayOf("android.permission.BLUETOOTH_CONNECT"), 1)
//            } else {
//                ActivityCompat.requestPermissions(this@MainActivity,
//                        arrayOf("android.permission.BLUETOOTH_CONNECT"), 1)
//            }
//        }
        return 1;

    }
    private fun changeIcon(): Int {


        return  1;

    }

    private fun getBatteryLevel2(): Int {

        if (false &&android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            if (ContextCompat.checkSelfPermission(this@MainActivity, "android.permission.BLUETOOTH_SCAN") !== PackageManager.PERMISSION_GRANTED) {
                if (ActivityCompat.shouldShowRequestPermissionRationale(this@MainActivity, "android.permission.BLUETOOTH_SCAN")) {
                    ActivityCompat.requestPermissions(this@MainActivity,
                            arrayOf("android.permission.BLUETOOTH_SCAN"), 1)
                } else {
                    ActivityCompat.requestPermissions(this@MainActivity,
                            arrayOf("android.permission.BLUETOOTH_SCAN"), 1)
                }
            }
        }

//        if (ContextCompat.checkSelfPermission(this@MainActivity, "android.permission.BLUETOOTH_SCAN") !== PackageManager.PERMISSION_GRANTED) {
//            if (ActivityCompat.shouldShowRequestPermissionRationale(this@MainActivity, "android.permission.BLUETOOTH_SCAN")) {
//                ActivityCompat.requestPermissions(this@MainActivity,
//                        arrayOf("android.permission.BLUETOOTH_SCAN"), 1)
//            } else {
//                ActivityCompat.requestPermissions(this@MainActivity,
//                        arrayOf("android.permission.BLUETOOTH_SCAN"), 1)
//            }
//        }

        return 1;

    }
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>,
                                            grantResults: IntArray) {
        when (requestCode) {
            1 -> {
                if (grantResults.isNotEmpty() && grantResults[0] ==
                        PackageManager.PERMISSION_GRANTED) {
                    if ((ContextCompat.checkSelfPermission(this@MainActivity, "android.permission.BLUETOOTH_SCAN") === PackageManager.PERMISSION_GRANTED)) {
                       // Toast.makeText(this, "Permission Granted", Toast.LENGTH_SHORT).show()

                    }
                    if ((ContextCompat.checkSelfPermission(this@MainActivity, "android.permission.BLUETOOTH_CONNECT") === PackageManager.PERMISSION_GRANTED)) {
                       // Toast.makeText(this, "Permission Granted", Toast.LENGTH_SHORT).show()
                    }
                } else {
                   // Toast.makeText(this, "Permission Denied", Toast.LENGTH_SHORT).show()
                }
                return
            }
        }
    }
}
