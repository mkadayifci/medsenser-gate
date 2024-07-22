package com.example.medsenser_gate

import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanResult
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi

class BleScanReceiver : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.TIRAMISU)
    override fun onReceive(context: Context?, intent: Intent?) {
        //Log.d("BleScanReceiver", "CALLLLLLLLL")
        //Log.d("BleScanReceiver",  intent?.action.toString())

        //logIntentExtras(intent)
        if (intent?.action == "com.example.ACTION_SCAN_RESULT") {
          //  logIntentExtras(intent)
            val results: List<ScanResult>? = intent.getParcelableArrayListExtra("android.bluetooth.le.extra.LIST_SCAN_RESULT" )
            results?.forEach {
                Log.d("BleScanReceiver", "BLE cihazı bulundu: ${it.device.address}")
            }
        }
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
