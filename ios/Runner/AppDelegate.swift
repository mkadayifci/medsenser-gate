import UIKit
import Flutter
import CoreLocation
import CoreBluetooth

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,CBCentralManagerDelegate,CLLocationManagerDelegate {
    var centralManager: CBCentralManager!
    
    @objc func centralManagerDidUpdateState(_ central: CBCentralManager) {
           if central.state == .poweredOn {
               let serviceUUID = CBUUID(string: "BA0FD034-9E5B-0D8B-534B-E22A6FAC6BFD")
               central.scanForPeripherals(withServices:  [serviceUUID], options: nil)
           } else {
               print("Bluetooth is not available.")
           }
       }
       
    @objc(centralManager:didDiscoverPeripheral:advertisementData:RSSI:) func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
           // Burada reklam verilerini kontrol edebilir ve özel reklam verilerinizi filtreleyebilirsiniz.
        print("discovered")
        if(1==1){
            print("Discovered peripheral")//: \(peripheral) with advertisementData: \(advertisementData)")
            let serviceUUID = CBUUID(string: "BA0FD034-9E5B-0D8B-534B-E22A6FAC6BFD")
            let scanOptions = [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            
            
            
            let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
            // For invoking flutter method from Swift
            let channel = FlutterMethodChannel(name: "ble_medsenser_channel", binaryMessenger: controller.binaryMessenger)
            
            let data = ["ManufData":advertisementData["kCBAdvDataManufacturerData"]]

            print("RSSI: \(RSSI)")
            channel.invokeMethod("ble_notification", arguments:data) { (result) in
                if let resultString = result as? String {
                    print(resultString)
                }
            }

            
            print(advertisementData)
            let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd|HH:mm:ss"
                let currentDateTimeString = formatter.string(from: Date())
               // dateTimeModel.dateTimeArray.append(currentDateTimeString)
             
            
            
            let urlstr="https://sumer-logger.com/custom-track/?date=" + currentDateTimeString
            let url = URL(string: urlstr)!

            // URL'den istek oluşturun
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            // URLSession kullanarak isteği gönderin
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // Hata kontrolü
                if let error = error {
                    print("Hata: \(error)")
                    return
                }

                // Başarılı bir şekilde istek yapıldığında bu kısım çalışır
                print("İstek başarıyla gönderildi")
            }

            // İsteği başlatın
            //task.resume()
            
            
//            let serviceUUID = CBUUID(string: "A148F2A0-F69E-8AF0-4AC8-B1DCBBFB256B")
        central.scanForPeripherals(withServices: [serviceUUID], options: nil)
        //central.scanForPeripherals(withServices: nil, options: nil)
        
        }
   
       }
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        print("willRestoreState")
    }
    
    
    
    var locationManager : CLLocationManager?

    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint)
    {
        print("found")
        // Beacon'lar bulunduğunda yapılacak işlemler
        for beacon in beacons
        {
            
            // Bulunan her beacon için gerekli işlemleri yapabilirsiniz.
            print("Bulunan beacon: \(beacon)")
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error)
    {
        print(error)
    }
    
    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      
      centralManager = CBCentralManager(delegate: self, queue: nil,options: [CBCentralManagerOptionRestoreIdentifierKey: "yourRestoreIdentifier"])
      //let contentView = ContentView().environmentObject(dateTimeModel)
      /*
      if let window = window {
               window.rootViewController = UIHostingController(rootView: contentView)
               self.window = window
          window.makeKeyAndVisible()
           }
       */
      
      let uuidString="BA0FD034-9E5B-0D8B-534B-E22A6FAC6BFD";
      let beaconUUID:UUID = UUID(uuidString: uuidString)!
      locationManager = CLLocationManager()

      locationManager!.requestAlwaysAuthorization();
      let beaconIdentity = CLBeaconIdentityConstraint(uuid: beaconUUID)
      print(beaconIdentity)
      locationManager!.delegate=self
      locationManager!.pausesLocationUpdatesAutomatically=false
      
      locationManager!.startRangingBeacons(satisfying: beaconIdentity)
      locationManager!.startUpdatingLocation()

      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
