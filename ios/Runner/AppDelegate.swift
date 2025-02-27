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
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: [serviceUUID], options: nil)
        } else {
            print("Bluetooth is not available.")
        }
    }
    
    @objc(centralManager:didDiscoverPeripheral:advertisementData:RSSI:) func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Here you can check the advertisement data and filter your specific advertisement data.
        
        print("Discovered peripheral") //: \(peripheral) with advertisementData: \(advertisementData)")
        let scanOptions = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        // For invoking Flutter method from Swift
        let channel = FlutterMethodChannel(name: "ble_medsenser_channel", binaryMessenger: controller.binaryMessenger)
        
        let manufacturerData = advertisementData["kCBAdvDataManufacturerData"] as? Data
        
        let data = ["ManufData": manufacturerData?.dropFirst(2)]
        // You can use the 'data' variable here
        
        channel.invokeMethod("advertisement_received", arguments: data) { (result) in
            if let resultString = result as? String {
                print(resultString)
            }
        }
        
        print(advertisementData)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd|HH:mm:ss"
        let currentDateTimeString = formatter.string(from: Date())
        // dateTimeModel.dateTimeArray.append(currentDateTimeString)
        
        let urlstr = "https://sumer-logger.com/custom-track/?date=" + currentDateTimeString
        let url = URL(string: urlstr)!
        
        // Create a request from the URL
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Send the request using URLSession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Error handling
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            // This part runs when the request is successfully made
            print("Request successfully sent")
        }
        
        // Start the request
        // task.resume()
        
        central.scanForPeripherals(withServices: [serviceUUID], options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("willRestoreState")
    }
    
    var locationManager: CLLocationManager?

    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        print("found")
        // Actions to take when beacons are found
        for beacon in beacons {
            // You can perform necessary actions for each found beacon.
            print("Found beacon: \(beacon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        print(error)
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "yourRestoreIdentifier"])
        // let contentView = ContentView().environmentObject(dateTimeModel)
        /*
        if let window = window {
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
        */
        
        if let uuidString = Bundle.main.object(forInfoDictionaryKey: "ServiceUUID") as? String,
           let beaconUUID = UUID(uuidString: uuidString) {
            locationManager = CLLocationManager()
            locationManager!.requestAlwaysAuthorization()
            let beaconIdentity = CLBeaconIdentityConstraint(uuid: beaconUUID)
            print(beaconIdentity)
            locationManager!.delegate = self
            locationManager!.pausesLocationUpdatesAutomatically = false
            
            locationManager!.startRangingBeacons(satisfying: beaconIdentity)
            locationManager!.startUpdatingLocation()
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
