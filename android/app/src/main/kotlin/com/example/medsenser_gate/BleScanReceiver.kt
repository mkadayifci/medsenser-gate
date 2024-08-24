package com.example.medsenser_gate

import android.bluetooth.BluetoothDevice
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanResult
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.util.SparseArray
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.MethodChannel.Result
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.workDataOf
import com.example.medsenser_gate.device.DeviceManager

class BleScanReceiver : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onReceive(context: Context, intent: Intent?) {

        if (intent?.action == "com.example.ACTION_SCAN_RESULT") {
            val results: List<ScanResult>? =
                intent.getParcelableArrayListExtra(
                    "android.bluetooth.le.extra.LIST_SCAN_RESULT",
                    ScanResult::class.java
                )
            results?.forEach {
                Log.d("Test PHY",it.rssi.toString());

                val primaryPhy = it.primaryPhy
                val secondaryPhy = it.secondaryPhy

                if (primaryPhy == BluetoothDevice.PHY_LE_CODED || secondaryPhy == BluetoothDevice.PHY_LE_CODED) {
                    Log.d("Test PHY", "Cihaz Coded PHY kullanıyor")
                } else {
                    Log.d("Test PHY", "Cihaz Coded PHY kullanmıyor")
                }


                val manufData = it.scanRecord?.manufacturerSpecificData?.valueAt(0);
                val packageType: Byte? = manufData?.getOrNull(3)

                val deviceId: Int = manufData?.let {
                    if (it.size >= 3) {
                        ((it[0].toInt() and 0xFF) shl 16) or
                                ((it[1].toInt() and 0xFF) shl 8) or
                                (it[2].toInt() and 0xFF)
                    } else {
                        0
                    }
                } ?: 0

                if (RegisteredDevices.containsDeviceId(deviceId)) {
                    if (packageType == 1.toByte()) {
                        DeviceManager.onNewSignal(deviceId = deviceId, packetNumber = 10, value = 100)
                        //TempData received
                    }

                }

                val mapData = convertSparseArrayToMap(it.scanRecord?.manufacturerSpecificData)
                if (MainActivity.checkInitialization()) {
                    MainActivity.channelProxy.invokeMethod(
                        "advertisement_received",
                        mapData,
                        object : Result {
                            override fun success(result: Any?) {
                                if (result is String) {
                                    println(result)
                                }
                            }


                            override fun error(
                                errorCode: String,
                                errorMessage: String?,
                                errorDetails: Any?
                            ) {
                                println("Error: $errorCode, $errorMessage")
                            }

                            override fun notImplemented() {
                                println("Not implemented")
                            }
                        })

                } else {

                    val workRequest = OneTimeWorkRequestBuilder<NotificationWorker>()
                        .setInputData(
                            workDataOf(
                                "deviceName" to "Device Name",
                                "deviceAddress" to "Device Address"
                            )
                        )
                        .build()

                    WorkManager.getInstance(context).enqueue(workRequest)

                    Log.e("medsenser", "Initialize edilmediddddddd")

                }



/*
               */
            }
        }
    }


    fun convertSparseArrayToMap(sparseArray: SparseArray<ByteArray>?): Map<String, Any> {
        val map = mutableMapOf<String, Any>()
        if (sparseArray != null) {
            for (i in 0 until sparseArray.size()) {
                map["ManufData"] = sparseArray.valueAt(i)
            }
        }
        return map
    }

    fun logIntentExtras(intent: Intent?) {
        val extras = intent?.extras
        if (extras != null) {
            val keys = extras.keySet()
            val stringBuilder = StringBuilder()
            for (key in keys) {
                stringBuilder.append(key).append(": ").append(extras.get(key)).append("\n")
            }
            Log.d("IntentExtras", stringBuilder.toString())
        } else {
            Log.d("IntentExtras", "No extras found in the intent")
        }
    }

}

