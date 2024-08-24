package com.example.medsenser_gate

import java.util.Collections
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

object RegisteredDevices {
    private val lock = ReentrantLock()
    private val deviceIds: MutableList<Int> = Collections.synchronizedList(mutableListOf())

    // Değer ekleme
    fun addDeviceId(deviceId: Int) {
        lock.withLock {
            deviceIds.add(deviceId)
        }
    }

    // Değer çıkarma
    fun removeDeviceId(deviceId: Int): Boolean {
        lock.withLock {
            return deviceIds.remove(deviceId)
        }
    }

    // Değerin mevcut olup olmadığını kontrol etme
    fun containsDeviceId(deviceId: Int): Boolean {
        lock.withLock {
            return deviceIds.contains(deviceId)
        }
    }

    // Tüm değerleri alma
    fun getAllDeviceIds(): List<Int> {
        lock.withLock {
            return deviceIds.toList()
        }
    }
}

