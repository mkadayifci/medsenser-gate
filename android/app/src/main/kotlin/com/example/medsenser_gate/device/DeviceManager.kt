package com.example.medsenser_gate.device
import java.time.Instant
import java.util.*
import java.util.concurrent.ConcurrentHashMap
object DeviceManager {
    private val deviceMap: ConcurrentHashMap<Int, DeviceData> = ConcurrentHashMap()

    // Yeni bir sinyal alındığında çağrılacak fonksiyon
    fun onNewSignal(deviceId: Int, packetNumber: Int, value: Int) {
        val currentTime = Instant.now() // UTC zaman

        // Cihazın veri yapısına threadsafe erişim
        val deviceData = deviceMap.computeIfAbsent(deviceId) {
            DeviceData(deviceId)
        }

        deviceData.lastSeen = currentTime
        deviceData.addSignalData(packetNumber, value, currentTime)
    }

    // Cihaz geçmiş verilerini almak için
    fun getDeviceHistory(deviceId: Int): List<SignalData>? {
        return deviceMap[deviceId]?.signalHistory?.toList() // threadsafe
    }

    // Cihazın en son ne zaman görüldüğünü almak için
    fun getLastSeenTime(deviceId: Int): Instant? {
        return deviceMap[deviceId]?.lastSeen
    }

    // Bir cihazı haritadan kaldırmak için
    fun removeDevice(deviceId: Int): Boolean {
        return deviceMap.remove(deviceId) != null
    }

    // Tüm cihazları temizlemek için
    fun clearAllDevices() {
        deviceMap.clear()
    }

    // Tüm kayıtlı cihazların ID'lerini almak için
    fun getAllDeviceIds(): Set<Int> {
        return deviceMap.keys
    }
}
