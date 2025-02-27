//
//  AdvertisementPacket.swift
//  Runner
//
//  Created by Mehmet Kadayıfçı on 19.02.2025.
//

import Foundation

// Protocol for advertisement sub-data types
protocol AdvertisementSubData {}

// Class representing a BLE advertisement packet
class AdvertisementPacket {
    // Package type constants
    static let packageTypeActiveTime = 1
    static let packageTypeHistory = 2
    static let packageTypeExtentedHistory = 3
    static let packageTypeMEMS = 4
    
    // Device identifier
    let deviceId: Int
    
    // Type of package (1=ActiveTime, 2=History, 3=MEMS, 4=ExtendedHistory)
    let packageType: Int
    
    // Specific data for this package type
    let subData: AdvertisementSubData
    
    init(deviceId: Int, packageType: Int, subData: AdvertisementSubData) {
        self.deviceId = deviceId
        self.packageType = packageType
        self.subData = subData
    }
    
    // Create an advertisement packet from raw manufacturer data
    static func fromManufacturerData(_ data: [UInt8]) -> AdvertisementPacket? {
        guard data.count >= 4 else { return nil }
        
        // Extract device ID from first 3 bytes
        let deviceId = Int(data[0]) << 16 | Int(data[1]) << 8 | Int(data[2])
        
        // Extract package type from 4th byte
        let packageType = Int(data[3])
        
        var subData: AdvertisementSubData
        
        // Create appropriate sub-data based on package type
        switch packageType {
        case packageTypeActiveTime:
            guard data.count >= 9 else { return nil }
            subData = ActiveTimePackageData(
                sequence: Int(data[4]),
                currentTemp: Int(data[5]),
                lastTemp1: Int(data[6]),
                lastTemp2: Int(data[7]),
                lastTemp3: Int(data[8])
            )
            
        case packageTypeHistory, packageTypeExtentedHistory:
            guard data.count >= 9 else { return nil }
            subData = HistoryPackageData(
                previousTemp1: Int(data[4]),
                previousTemp2: Int(data[5]),
                previousTemp3: Int(data[6]),
                previousTemp4: Int(data[7]),
                previousTemp5: Int(data[8])
            )
            
        default:
            guard data.count >= 7 else { return nil }
            subData = DefaultPackageData(
                currentTemp: Int(data[5]),
                battery: Int(data[6])
            )
        }
        
        return AdvertisementPacket(deviceId: deviceId, packageType: packageType, subData: subData)
    }
}

// Active Time package data (real-time measurements)
struct ActiveTimePackageData: AdvertisementSubData {
    let sequence: Int
    let currentTemp: Int
    let lastTemp1: Int
    let lastTemp2: Int
    let lastTemp3: Int
}

// History package data (past measurements)
struct HistoryPackageData: AdvertisementSubData {
    let previousTemp1: Int
    let previousTemp2: Int
    let previousTemp3: Int
    let previousTemp4: Int
    let previousTemp5: Int
}

// Default package data
struct DefaultPackageData: AdvertisementSubData {
    let currentTemp: Int
    let battery: Int
} 