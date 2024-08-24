package com.example.medsenser_gate.device
import java.time.Instant
import java.util.*

// Her bir cihaz için veri yapısı
class DeviceData(
    val deviceId: Int
) {
    @Volatile var lastSeen: Instant = Instant.now()
    val signalHistory: MutableList<SignalData> = Collections.synchronizedList(mutableListOf())

    // Paket numaralarını sıralamak için threadsafe bir yöntem
    fun addSignalData(packetNumber: Int, value: Int, timestamp: Instant) {
        synchronized(signalHistory) {
            signalHistory.add(SignalData(packetNumber, value, timestamp))
            signalHistory.sortBy { it.packetNumber }
        }
    }
}
