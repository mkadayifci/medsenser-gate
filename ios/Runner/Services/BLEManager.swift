//
//  BLEManager.swift
//  Runner
//
//  Created by Mehmet Kadayıfçı on 19.02.2025.
//

import Foundation
import CoreBluetooth

// MARK: - BLEManagerDelegate Protocol

/// Delegate protocol for BLE events
protocol BLEManagerDelegate: AnyObject {
    /// Called when a new device is discovered
    func didDiscoverDevice(packet: AdvertisementPacket)
}

// MARK: - BLEManager Class

/// Class for managing Bluetooth Low Energy scanning
class BLEManager: NSObject {
    
    // MARK: - Properties
    
    /// Shared instance for Singleton pattern
    static let shared = BLEManager()
    
    /// Core Bluetooth central manager
    private var centralManager: CBCentralManager!
    
    /// Delegate for BLE events
    weak var delegate: BLEManagerDelegate?
    
    /// Medsenser service UUID
    private var medsenserServiceUUID: CBUUID {
        if let uuidString = Bundle.main.object(forInfoDictionaryKey: "ServiceUUID") as? String {
            LogManager.shared.info("Service UUID: \(uuidString)", component: "BLEManager")
            return CBUUID(string: uuidString)
        }
        // Fallback UUID
        LogManager.shared.info("Using fallback Service UUID", component: "BLEManager")
        return CBUUID(string: "00000000-0000-0000-0000-000000000000")
    }
    // MARK: - Initialization
    
    /// Private initializer for Singleton
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // MARK: - Public Methods
    
    /// Start scanning for BLE devices
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            LogManager.shared.error("Bluetooth is not powered on", component: "BLEManager")
            return
        }
        
        // Start scanning with no service filter to catch all advertisements
        centralManager.scanForPeripherals(withServices: [medsenserServiceUUID], options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: false

        ])
        
        LogManager.shared.info("Started scanning for BLE devices", component: "BLEManager")
    }
    
    /// Stop scanning for BLE devices
    func stopScanning() {
        centralManager.stopScan()
        LogManager.shared.info("Stopped scanning for BLE devices", component: "BLEManager")
    }
}

// MARK: - CBCentralManagerDelegate

extension BLEManager: CBCentralManagerDelegate {
    
    /// Called when central manager state changes
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            LogManager.shared.info("Bluetooth is powered on", component: "BLEManager")
            startScanning()
        case .poweredOff:
            LogManager.shared.error("Bluetooth is powered off", component: "BLEManager")
        case .resetting:
            LogManager.shared.info("Bluetooth is resetting", component: "BLEManager")
        case .unauthorized:
            LogManager.shared.error("Bluetooth is unauthorized", component: "BLEManager")
        case .unsupported:
            LogManager.shared.error("Bluetooth is unsupported", component: "BLEManager")
        case .unknown:
            LogManager.shared.info("Bluetooth state is unknown", component: "BLEManager")
        @unknown default:
            LogManager.shared.error("Unknown Bluetooth state", component: "BLEManager")
        }
    }
    
    /// Called when a peripheral is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Check for manufacturer data
        guard let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data else {
            return
        }
        
        LogManager.shared.debug("Discovered peripheral with RSSI: \(RSSI)", component: "BLEManager")
        
        // Convert to array of bytes
        let bytes = Array([UInt8](manufacturerData).dropFirst(2))
        
        // Check if this is a Medsenser device (manufacturer ID check would go here)
        // For now, we're assuming all manufacturer data is from our devices
        
        // Create advertisement packet
        if let packet = AdvertisementPacket.fromManufacturerData(bytes) {
            LogManager.shared.debug("Created advertisement packet - Device ID: \(packet.deviceId), Type: \(packet.packageType)", component: "BLEManager")
            
            // Process the packet
            DeviceManager.shared.processAdvertisementPacket(packet)
            
            // Notify delegate
            delegate?.didDiscoverDevice(packet: packet)
        } else {
            LogManager.shared.debug("Failed to create advertisement packet from manufacturer data", component: "BLEManager")
        }
    }
}

// MARK: - CBPeripheralDelegate

extension BLEManager: CBPeripheralDelegate {
    // Peripheral delegate methods would go here if needed
} 
