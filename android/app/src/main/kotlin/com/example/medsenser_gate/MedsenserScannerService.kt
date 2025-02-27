package com.example.medsenser_gate

import android.Manifest
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.IBinder
import android.os.ParcelUuid
import android.util.Log
import android.util.SparseArray
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.workDataOf
import com.example.medsenser_gate.device.DeviceManager
import io.flutter.plugin.common.MethodChannel.Result
import java.util.UUID


class MedsenserScannerService : Service() {
    private val beaconUuid = UUID.fromString("ba0fd034-9e5b-0d8b-534b-e22a6fac6bfd") // Buraya beacon UUID'sini ekleyin

    private lateinit var bluetoothAdapter: BluetoothAdapter
    private lateinit var bleScanner: BluetoothLeScanner
    var scanCallbackObject:ScanCallback? = null
    override fun onCreate() {
        super.onCreate()

        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothAdapter = bluetoothManager.adapter
        bleScanner = bluetoothAdapter.bluetoothLeScanner

        startForegroundService()
        startBleScan()
    }

    private fun startForegroundService() {
        val channelId = "BLE_SCAN_SERVICE_CHANNEL"
        val channelName = "BLE Scan Service"
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val channel = NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_LOW)
            notificationManager.createNotificationChannel(channel)
        }

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)

        val notification: Notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle("BLE Taraması Yapılıyor")
            .setContentText("Uygulama BLE cihazlarını tarıyor...")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .build()

        startForeground(1, notification)
    }

    private fun startBleScan() {
        val scanCallback = object : ScanCallback() {

            override fun onBatchScanResults(results: List<ScanResult>) {
                super.onBatchScanResults(results)


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

                        //WorkManager.getInstance(context).enqueue(workRequest)

                        Log.e("medsenser", "Initialize edilmediddddddd")

                    }



                    /*
                                   */
                }

            }

            override fun onScanFailed(errorCode: Int) {
                super.onScanFailed(errorCode)
                // Tarama başarısız olduğunda işlem yapılabilir
            }
        }
        scanCallbackObject=scanCallback;
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
        val manufacturerId = 0xFFFF // Kontrol etmek istediğiniz Manufacturer ID

        val manufacturerData = byteArrayOf((manufacturerId shr 8).toByte(), manufacturerId.toByte())
        val manufacturerDataMask = byteArrayOf(0xFF.toByte(), 0xFF.toByte()) // Sadece Manufacturer ID'yi kontrol et

        val filters: MutableList<ScanFilter> = ArrayList()
        val filter = ScanFilter.Builder()
            .setServiceUuid(ParcelUuid(beaconUuid))
//            .setManufacturerData(manufacturerId, manufacturerData, manufacturerDataMask)
            .build()
        filters.add(filter)



        val scanSettings = ScanSettings.Builder()

            //.setLegacy(false)
            .setMatchMode(ScanSettings.MATCH_MODE_AGGRESSIVE)
            .setCallbackType(ScanSettings.CALLBACK_TYPE_ALL_MATCHES)
            .setScanMode(ScanSettings.SCAN_MODE_LOW_POWER)
            .setReportDelay(30000)
            .setPhy(ScanSettings.PHY_LE_ALL_SUPPORTED)
            .build()
        //bleScanner.startScan(scanCallback)
        bleScanner.startScan(filters, scanSettings, scanCallback)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId);
        return START_STICKY;
    }

    override fun onDestroy() {
        super.onDestroy()
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
        bleScanner.stopScan(scanCallbackObject) // Servis durdurulurken taramayı durdurur
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
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
