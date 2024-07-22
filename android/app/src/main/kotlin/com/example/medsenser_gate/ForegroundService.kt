package com.example.medsenser_gate

import android.R
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat


class ForegroundService : Service() {
    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val input = intent.getStringExtra("inputExtra")
        createNotificationChannel()
        Log.d("FOREGROUND","ForeGroundService Staring")
        val pendingIntent = PendingIntent.getActivity(
            this, 0, Intent(
                this,
                MainActivity::class.java
            ), PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification: Notification = NotificationCompat.Builder(this, "dd")
            .setContentTitle("Foreground Service")
            .setContentText(input)
            .setSmallIcon(R.mipmap.sym_def_app_icon)
            .setContentIntent(pendingIntent)
            .build()

        startForeground(1, notification)

        val handler = Handler(Looper.getMainLooper())
        val runnable = object : Runnable {
            override fun run() {
                // Buraya yapılacak iş mantığını ekleyin
                // Örneğin, bir log yazdırabilirsiniz
                 Log.d("ForegroundService", "Service is running...");

                // 1 saniye bekle

                handler.postDelayed(this, 1000)
            }
        }
        handler.post(runnable)

        // here is the code you wanna run in background
        return START_NOT_STICKY
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onDestroy() {
        super.onDestroy()
    }
    override fun onBind(p0: Intent?): IBinder? {
       return null;
    }

    private fun createNotificationChannel() {
        val serviceChannel = NotificationChannel(
            "dd",
            "Foreground Service Channel",
            NotificationManager.IMPORTANCE_DEFAULT
        )

        getSystemService(NotificationManager::class.java).createNotificationChannel(serviceChannel)
    }
}