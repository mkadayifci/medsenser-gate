//
//  DeviceManager.swift
//  Runner
//
//  Created by Mehmet Kadayıfçı on 19.02.2025.
//

// DeviceManager.swift

import Foundation

class DeviceManager {
    // Shared instance for Singleton pattern
    static let shared = DeviceManager()
    
    // Array holding active devices
    private var devices: [MedsenserDevice] = []
    
    private init() {} // Private initializer for Singleton
    
    // Processes advertisement packet from BLE
    func processAdvertisementPacket(_ packet: AdvertisementPacket) {
        // First find or create the device
        let device = findOrCreateDevice(deviceId: packet.deviceId)
        
        // Process based on packet type
        switch packet.packageType {
        case AdvertisementPacket.packageTypeActiveTime:
            processActiveTimePacket(packet, for: device)
        case AdvertisementPacket.packageTypeHistory, AdvertisementPacket.packageTypeExtentedHistory:
            processHistoryPacket(packet, for: device)
        case AdvertisementPacket.packageTypeMEMS:
            processDefaultPacket(packet, for: device)
        default:
            print("Unknown package type: \(packet.packageType)")
        }
        
        // Update last seen time
        device.lastSeen = Date()
    }
    
    // Find or create device
    private func findOrCreateDevice(deviceId: Int) -> MedsenserDevice {
        if let existingDevice = devices.first(where: { $0.deviceId == deviceId }) {
            return existingDevice
        }
        
        let newDevice = MedsenserDevice(deviceId: deviceId)
        devices.append(newDevice)
        return newDevice
    }
    
    // Process Active Time packet
    private func processActiveTimePacket(_ packet: AdvertisementPacket, for device: MedsenserDevice) {
        guard let activeData = packet.subData as? ActiveTimePackageData else { return }
        
        // Convert temperature values and create measurement nodes
        let currentTemp = MeasurementNode.convertParcelableTemperature(activeData.currentTemp)
        let temp1 = MeasurementNode.convertParcelableTemperature(activeData.lastTemp1)
        let temp2 = MeasurementNode.convertParcelableTemperature(activeData.lastTemp2)
        let temp3 = MeasurementNode.convertParcelableTemperature(activeData.lastTemp3)
        
        // Current time
        let now = Date()
        
        let time1 = now.addingTimeInterval(-1 * 60)
        let time2 = now.addingTimeInterval(-3 * 60)
        let time3 = now.addingTimeInterval(-5 * 60)
        
        // Create measurement nodes and add to device
        let nodes = [
            MeasurementNode(timestamp: now, temperatureValue: currentTemp),
            MeasurementNode(timestamp: time1, temperatureValue: temp1),
            MeasurementNode(timestamp: time2, temperatureValue: temp2),
            MeasurementNode(timestamp: time3, temperatureValue: temp3)
        ]
        
        device.measurements.append(contentsOf: nodes)
    }
    
    // Process History packet
    private func processHistoryPacket(_ packet: AdvertisementPacket, for device: MedsenserDevice) {
        guard let historyData = packet.subData as? HistoryPackageData else { return }
        
        let now = Date()
        let temps = [
            historyData.previousTemp1,
            historyData.previousTemp2,
            historyData.previousTemp3,
            historyData.previousTemp4,
            historyData.previousTemp5
        ]
        
        let intervalMultiplier: Int
        switch packet.packageType {
        case AdvertisementPacket.packageTypeExtentedHistory:
            intervalMultiplier = 5 // 5-minute interval
        case AdvertisementPacket.packageTypeHistory:
            intervalMultiplier = 3 // 3-minute interval
        default:
            intervalMultiplier = 1000000000 // or some other default value
        }
        
        for (index, temp) in temps.enumerated() {
            let previousTempOrder = index + 1
            let timestamp = now.addingTimeInterval(-1 * previousTempOrder  * intervalMultiplier * 60)
            let convertedTemp = MeasurementNode.convertParcelableTemperature(temp)
            let node = MeasurementNode(timestamp: timestamp, temperatureValue: convertedTemp)
            device.measurements.append(node)
        }
    }
    
    // Process Default packet
    private func processDefaultPacket(_ packet: AdvertisementPacket, for device: MedsenserDevice) {
        guard let defaultData = packet.subData as? DefaultPackageData else { return }
        
        // Update battery level
        device.batteryLevel = defaultData.battery
        
        // Add current temperature measurement
        let convertedTemp = MeasurementNode.convertParcelableTemperature(defaultData.currentTemp)
        let node = MeasurementNode(timestamp: Date(), temperatureValue: convertedTemp)
        device.measurements.append(node)
    }
    
    // Get all devices
    func getAllDevices() -> [MedsenserDevice] {
        return devices
    }
    
    // Get a specific device
    func getDevice(withId deviceId: Int) -> MedsenserDevice? {
        return devices.first { $0.deviceId == deviceId }
    }
}


/*


// Example usage:

// When a packet comes from BLE:
let activeTimeData = ActiveTimePackageData(
    sequence: 1,
    currentTemp: 250,
    lastTemp1: 248,
    lastTemp2: 246,
    lastTemp3: 245
)

let packet = AdvertisementPacket(
    deviceId: 12345,
    packageType: AdvertisementPacket.packageTypeActiveTime,
    subData: activeTimeData
)

// Process the packet
DeviceManager.shared.processAdvertisementPacket(packet)

// Get device information
if let device = DeviceManager.shared.getDevice(withId: 12345) {
    print("Device ID: \(device.deviceId)")
    print("Measurement count: \(device.measurements.count)")
    print("Last seen: \(device.lastSeen ?? Date())")
    print("Battery level: \(device.batteryLevel)%")
    
    // Show recent measurements
    for measurement in device.measurements.suffix(5) {
        print("Time: \(measurement.timestamp), Temp: \(measurement.temperatureValue)°C")
    }
}
*/