//
//  MedsenserDevice.swift
//  Runner
//
//  Created by Mehmet Kadayıfçı on 19.02.2025.
//

import Foundation

// Model class for Medsenser temperature measurement device
class MedsenserDevice {
    // Device identifier
    let deviceId: Int
    
    // Converted device ID (for display)
    var convertedDeviceId: String
    
    // Battery level (percentage)
    var batteryLevel: Int = 0
    
    // Last time the device was seen
    var lastSeen: Date?
    
    // First time the device was seen
    var firstSeen: Date?
    
    // Temperature measurements from this device
    var measurements: [MeasurementNode] = []
    
    // Initialize with device ID
    init(deviceId: Int) {
        self.deviceId = deviceId
        self.convertedDeviceId = String(format: "A%X", deviceId)
        self.lastSeen = Date()
        self.firstSeen = Date()
    }
    
    // Get the most recent temperature measurement
    func getLatestMeasurement() -> MeasurementNode? {
        return measurements.max(by: { $0.timestamp < $1.timestamp })
    }
    
    // Get all measurements sorted by time
    func getAllMeasurementsSorted() -> [MeasurementNode] {
        return measurements.sorted(by: { $0.timestamp < $1.timestamp })
    }
}
