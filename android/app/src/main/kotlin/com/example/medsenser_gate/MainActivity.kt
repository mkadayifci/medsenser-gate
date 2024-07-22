package com.example.medsenser_gate


import android.Manifest
import android.app.PendingIntent
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.os.Handler
import android.os.ParcelUuid
import android.util.Log
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import java.nio.ByteBuffer
import java.util.UUID


val REQUIRED_PERMISSIONS = arrayOf(
    Manifest.permission.FOREGROUND_SERVICE,
    Manifest.permission.ACCESS_FINE_LOCATION
)

class MainActivity : FlutterActivity() {
    private lateinit var bluetoothAdapter: BluetoothAdapter
    private lateinit var bleScanner: BluetoothLeScanner
    private lateinit var scanResults: MutableList<ScanResult>
    private val beaconUuid = UUID.fromString("ba0fd034-9e5b-0d8b-534b-e22a6fac6bfd") // Buraya beacon UUID'sini ekleyin
    private val beaconUuid2 = UUID.fromString("fd6bac6f-2ae2-4b53-8b0d-5b9e34d00fba") // Buraya beacon UUID'sini ekleyin


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // BluetoothAdapter ve BluetoothLeScanner başlatma
        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothAdapter = bluetoothManager.adapter
        bleScanner = bluetoothAdapter.bluetoothLeScanner

        Log.d("START","Starting")

        //StartForegroundService()
        Log.d("Scanner","SSSTAARRRRTIIINNNNNGGGG")
        val intent = Intent(this, BleScanReceiver::class.java)
        intent.setAction("com.example.ACTION_SCAN_RESULT")
        val pendingIntent =
            PendingIntent.getBroadcast(this, 1, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE)


        scanResults = mutableListOf()


        val filters: MutableList<ScanFilter> = ArrayList()




        val filter = ScanFilter.Builder()
            .setServiceUuid(ParcelUuid(beaconUuid))
            //.setManufacturerData(0xFFFF, manufacturerData, manufacturerDataMask)
            .build()
        filters.add(filter)



        val scanSettings = ScanSettings.Builder()

            //.setLegacy(false)

            .setScanMode(ScanSettings.SCAN_MODE_LOW_POWER)
            .setReportDelay(20000)
            //.setPhy(ScanSettings.PHY_LE_ALL_SUPPORTED)
            .build()
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.BLUETOOTH_SCAN
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }
        bleScanner.startScan(filters, scanSettings, pendingIntent)
        Log.d("Scanner","SSSTAARRRRTEDDDDDD")
        // Tarama işlemini belirli bir süre sonra durdurma ve sonuçları gönderme
        /*        Handler(Looper.getMainLooper()).postDelayed({
                    bleScanner.stopScan(scanCallback)
                    intent.putParcelableArrayListExtra("BLE_SCAN_RESULTS", ArrayList(scanResults))
                    sendBroadcast(intent)
                }, 10000) // 10 saniye tarama süresi
            */

        /*
        Handler(mainLooper).postDelayed({
            bleScanner.stopScan(pendingIntent)
            //stopSelf()
        }, 10000)
        */
    }

    private fun StartForegroundService(): Boolean {
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.FOREGROUND_SERVICE
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(this, REQUIRED_PERMISSIONS, 1);
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return true
        }

        val serviceIntent = Intent(
            this,
            ForegroundService::class.java
        )
        serviceIntent.putExtra("inputExtra", "Foreground Service Example in Android")

        startForegroundService(serviceIntent)
        return false
    }


    override fun onDestroy() {
        super.onDestroy()
        // Tarama durdurma
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.BLUETOOTH_SCAN
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return
        }
        //bleScanner.stopScan()
        //bleScanner.stopScan(scanCallback)
    }
}


/*
import android.content.Intent
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import android.util.Log
import io.flutter.embedding.android.FlutterActivity


class MainActivity : FlutterActivity() {


    override fun onCreate(savedInstanceState: Bundle?) 
    {
        Log.d("MainActivity", "######### Service Starting #########")
        super.onCreate(savedInstanceState)

        val intent = Intent(this, BeaconService::class.java)
        startService(intent)

    }



}

*/
