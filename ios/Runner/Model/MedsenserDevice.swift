//
//  MedsenserDevice.swift
//  Runner
//
//  Created by Mehmet Kadayıfçı on 19.02.2025.
//

// MedsenserDevice.swift

import Foundation

class MedsenserDevice {
    let deviceId: Int
    var convertedDeviceId: String
    var measurements: [MeasurementNode] = []
    var batteryLevel: Int = 0
    var lastSeen: Date?
    
    init(deviceId: Int) {
        self.deviceId = deviceId
        self.convertedDeviceId = "A4C35"
    }
}
