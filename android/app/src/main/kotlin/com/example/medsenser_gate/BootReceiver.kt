package com.example.medsenser_gate

import android.Manifest
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat


class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (Intent.ACTION_BOOT_COMPLETED == intent.action) {
/*
            val serviceIntent = Intent(
                context,
                ForegroundService::class.java
            )
            serviceIntent.putExtra("inputExtra", "Foreground Service Example in Android")
            ContextCompat.startForegroundService(context, serviceIntent)

            */

        }
    }
}
