import 'dart:async';

import 'package:medsenser_gate/models/advertisement_packages.dart';
import 'package:medsenser_gate/models/device/measurement_node.dart';
import 'package:medsenser_gate/models/device/medsenser_device.dart';
import 'package:medsenser_gate/services/device_manager.dart';

class BeamProcessor {
  static final BeamProcessor _singleton = BeamProcessor._internal();

  final List<AdvertisementPacket> _beamDataQueue = [];
  
  // StreamController for notifications when a new device is detected
  final StreamController<MedsenserDevice> newDeviceDetected = StreamController<MedsenserDevice>.broadcast();

  factory BeamProcessor() {
    return _singleton;
  }

  BeamProcessor._internal() {
    // Listen for new device notifications from DeviceManager
    DeviceManager().newDeviceDetected.stream.listen((device) {
      // Forward the new device notification
      newDeviceDetected.sink.add(device);
      print("New device detected: ${device.deviceId}");
    });
    
    // Load devices from database at application startup
    _loadDevicesFromDatabase();
  }
  
  Future<void> _loadDevicesFromDatabase() async {
    await DeviceManager().loadDevicesFromDatabase();
    print("Devices loaded from database: ${DeviceManager().activeDevices.length} devices");
  }

  Future<void> addNewBeamData(AdvertisementPacket beamData) async {
    _beamDataQueue.add(beamData);
    await proecessQueue();
  }

  Future<void> proecessQueue() async {
    while (_beamDataQueue.isNotEmpty) {
      AdvertisementPacket currentBeamData = _beamDataQueue.removeAt(0);

      if (currentBeamData.packageType == AdvertisementPacket.packageTypeActiveTime ||
          currentBeamData.packageType == AdvertisementPacket.packageTypeHistory ||           
          currentBeamData.packageType == AdvertisementPacket.packageTypeExtentedHistory) {
        await DeviceManager().addMeasurementData(currentBeamData);
      } else if (currentBeamData.packageType == 4) {
        print("Beam Processor: ${currentBeamData.deviceId}");
      }
    }
  }
  
  // Returns measurements that have not been synchronized with the server
  Future<List<Map<String, dynamic>>> getUnsyncedMeasurementsForSync() async {
    List<MeasurementNode> unsyncedMeasurements = await DeviceManager().getUnsyncedMeasurements();
    
    return unsyncedMeasurements.map((measurement) {
      return {
        'timestamp': measurement.timestamp.millisecondsSinceEpoch,
        'temperatureValue': measurement.temperatureValue,
      };
    }).toList();
  }
  
  // Marks measurements as synchronized with the server
  Future<void> markMeasurementsAsSynced(List<dynamic> syncedMeasurements) async {
    // You can mark measurements returned from the server as synchronized here
    // For now, we're marking all unsynchronized measurements
    List<MeasurementNode> unsyncedMeasurements = await DeviceManager().getUnsyncedMeasurements();
    await DeviceManager().markMeasurementsAsSynced(unsyncedMeasurements);
  }
  
  // Returns all active devices with their last seen timestamps
  List<MedsenserDevice> getAllDevicesWithLastSeen() {
    return DeviceManager().getAllDevicesWithLastSeen();
  }
}
