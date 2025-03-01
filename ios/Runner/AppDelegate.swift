import UIKit
import Flutter
import CoreLocation
import CoreBluetooth

@main
@objc class AppDelegate: FlutterAppDelegate, CBCentralManagerDelegate, CLLocationManagerDelegate {
    var centralManager: CBCentralManager!
    
    private var serviceUUID: CBUUID {
        if let uuidString = Bundle.main.object(forInfoDictionaryKey: "ServiceUUID") as? String {
            return CBUUID(string: uuidString)
        }
        // Fallback UUID
        return CBUUID(string: "00000000-0000-0000-0000-000000000000")
    }
    
    @objc func centralManagerDidUpdateState(_ central: CBCentralManager) {
     BLEManager.shared.startScanning();
    }
    
   
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        LogManager.shared.debug("willRestoreState", component: "AppDelegate")
    }
    
    var locationManager: CLLocationManager?

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        LogManager.shared.debug("found", component: "AppDelegate")
        // Actions to take when beacons are found
        for beacon in beacons {
            // You can perform necessary actions for each found beacon.
            LogManager.shared.debug("Found beacon: \(beacon)", component: "AppDelegate")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        LogManager.shared.error("\(error)", component: "AppDelegate")
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
       
        GeneratedPluginRegistrant.register(with: self)
        BLEManager.shared.startScanning();
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
