//
//  BLEManager.swift
//  Runner
//
//  Created by Mehmet Kadayıfçı on 19.02.2025.
//

import Foundation
import CoreBluetooth

// Delegate protocol for BLE events
protocol BLEManagerDelegate: AnyObject {
    func didDiscoverDevice(packet: AdvertisementPacket)
}

// Class for managing Bluetooth Low Energy scanning
class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // Shared instance for Singleton pattern
    static let shared = BLEManager()
    
    // Core Bluetooth central manager
    private var centralManager: CBCentralManager!
    
    // Delegate for BLE events
    weak var delegate: BLEManagerDelegate?
    
    // Medsenser service UUID
    private let medsenserServiceUUID = CBUUID(string: "FFF0")
    
    // Private initializer for Singleton
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // Start scanning for BLE devices
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on")
            return
        }
        
        // Start scanning with no service filter to catch all advertisements
        centralManager.scanForPeripherals(withServices: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: true
        ])
        
        print("Started scanning for BLE devices")
    }
    
    // Stop scanning for BLE devices
    func stopScanning() {
        centralManager.stopScan()
        print("Stopped scanning for BLE devices")
    }
    
    // MARK: - CBCentralManagerDelegate
    
    // Called when central manager state changes
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
            startScanning()
        case .poweredOff:
            print("Bluetooth is powered off")
        case .resetting:
            print("Bluetooth is resetting")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unsupported:
            print("Bluetooth is unsupported")
        case .unknown:
            print("Bluetooth state is unknown")
        @unknown default:
            print("Unknown Bluetooth state")
        }
    }
    
    // Called when a peripheral is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Check for manufacturer data
        guard let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data else {
            return
        }
        
        // Convert to array of bytes
        let bytes = [UInt8](manufacturerData)
        
        // Check if this is a Medsenser device (manufacturer ID check would go here)
        // For now, we're assuming all manufacturer data is from our devices
        
        // Create advertisement packet
        if let packet = AdvertisementPacket.fromManufacturerData(bytes) {
            // Process the packet
            DeviceManager.shared.processAdvertisementPacket(packet)
            
            // Notify delegate
            delegate?.didDiscoverDevice(packet: packet)
        }
    }
} 