package com.example.medsenser_gate.device
import java.time.Instant

// Her bir sinyal için veri yapısı
data class SignalData(
    val packetNumber: Int,
    val value: Int,
    val timestamp: Instant
)