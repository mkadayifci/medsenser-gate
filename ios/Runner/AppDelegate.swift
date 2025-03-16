import UIKit
import Flutter
import CoreLocation
import CoreBluetooth

@main
@objc class AppDelegate: FlutterAppDelegate, CBCentralManagerDelegate, CLLocationManagerDelegate {
    var centralManager: CBCentralManager!
    static var flutterViewController: FlutterViewController?
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
    

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
       
        GeneratedPluginRegistrant.register(with: self)
        BLEManager.shared.startScanning();
        AppDelegate.flutterViewController=window?.rootViewController as? FlutterViewController
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
