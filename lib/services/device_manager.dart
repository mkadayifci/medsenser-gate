import 'dart:async';

import 'package:medsenser_gate/models/advertisement_packages.dart';
import 'package:medsenser_gate/models/device/measurement_node.dart';
import 'package:medsenser_gate/models/device/medsenser_device.dart';
import 'package:medsenser_gate/services/database_service.dart';
import 'package:medsenser_gate/services/state_manager_service.dart';

class DeviceManager 
{
  static final DeviceManager _singleton = DeviceManager._internal();
  List<MedsenserDevice> activeDevices = List.empty(growable: true);
  
  // StreamController for notifications when a new device is detected
  final StreamController<MedsenserDevice> newDeviceDetected = StreamController<MedsenserDevice>.broadcast();

  factory DeviceManager() 
  {
    return _singleton;
  }

  DeviceManager._internal();

  Future<void> addMeasurementData(AdvertisementPacket advertisementData) async
  {
    MedsenserDevice? activeDeviceInArray = getActiveDeviceById(advertisementData.deviceId);
    bool isNewDevice = false;
    
    if (activeDeviceInArray == null) 
    {
      // A new device has been detected
      isNewDevice = true;
      DateTime now = DateTime.now();
      activeDeviceInArray = MedsenserDevice(
        deviceId: advertisementData.deviceId,
        lastSeen: now,
        isNewDevice: true
      );
      activeDevices.add(activeDeviceInArray);
      
      // Generate new device alert
      newDeviceDetected.sink.add(activeDeviceInArray);
      
      // Send notification through StateManager
      StateManagerService.state.newDeviceFound();
    }
    else {
      // Update the last seen time of the existing device
      activeDeviceInArray.lastSeen = DateTime.now();
      
      // Also update the last seen time in the database
      await DatabaseService.db.updateDeviceLastSeen(
        activeDeviceInArray.deviceId, 
        activeDeviceInArray.lastSeen
      );
    }

    if (advertisementData.packageType == AdvertisementPacket.packageTypeActiveTime) 
    {
      ActiveTimePackageData activeTimePackageData = advertisementData.subData as ActiveTimePackageData;
      await addMeasurementNodeToDevice(activeDeviceInArray, 0, activeTimePackageData.currentTemp);
      await addMeasurementNodeToDevice(activeDeviceInArray, 1, activeTimePackageData.lastTemp1);
      await addMeasurementNodeToDevice(activeDeviceInArray, 2, activeTimePackageData.lastTemp2);
      await addMeasurementNodeToDevice(activeDeviceInArray, 5, activeTimePackageData.lastTemp3);
    } 
    else if (advertisementData.packageType == AdvertisementPacket.packageTypeHistory) 
    {
      HistoryPackageData historyPackageData = advertisementData.subData as HistoryPackageData;
      await addMeasurementNodeToDevice(activeDeviceInArray, 5, historyPackageData.previousTemp1);
      await addMeasurementNodeToDevice(activeDeviceInArray, 10, historyPackageData.previousTemp2);
      await addMeasurementNodeToDevice(activeDeviceInArray, 15, historyPackageData.previousTemp3);
      await addMeasurementNodeToDevice(activeDeviceInArray, 20, historyPackageData.previousTemp4);
      await addMeasurementNodeToDevice(activeDeviceInArray, 25, historyPackageData.previousTemp5);
    }
    else if (advertisementData.packageType == AdvertisementPacket.packageTypeExtentedHistory) 
    {
      HistoryPackageData historyPackageData = advertisementData.subData as HistoryPackageData;
      await addMeasurementNodeToDevice(activeDeviceInArray, 10, historyPackageData.previousTemp1);
      await addMeasurementNodeToDevice(activeDeviceInArray, 20, historyPackageData.previousTemp2);
      await addMeasurementNodeToDevice(activeDeviceInArray, 30, historyPackageData.previousTemp3);
      await addMeasurementNodeToDevice(activeDeviceInArray, 40, historyPackageData.previousTemp4);
      await addMeasurementNodeToDevice(activeDeviceInArray, 50, historyPackageData.previousTemp5);
    }
  }

  Future<void> addMeasurementNodeToDevice(MedsenserDevice device, int minutesBefore, int parcelableTemperature) async
  {
    // Create measurement object
    MeasurementNode measurement = MeasurementNode(
      timestamp: DateTime.now().toUtc().subtract(Duration(minutes: minutesBefore)),
      temperatureValue: MeasurementNode.convertParcelableTemperature(parcelableTemperature)
    );
    
    // Add to memory
    device.measurements.add(measurement);
    
    // Save to database
    await DatabaseService.db.insertMeasurement(device.deviceId, measurement);
  }

  MedsenserDevice? getActiveDeviceById(int deviceId) {
    try {
      return activeDevices.firstWhere((device) => device.deviceId == deviceId);
    } catch (e) {
      // If no device with the given id is found in the list, return null
      return null;
    }
  }
  
  // Returns all active devices with their last seen timestamps
  List<MedsenserDevice> getAllDevicesWithLastSeen() {
    // Sort by last seen time (most recently seen first)
    activeDevices.sort((a, b) => b.lastSeen.compareTo(a.lastSeen));
    return activeDevices;
  }
  
  // Returns measurements that have not been synchronized with the server
  Future<List<MeasurementNode>> getUnsyncedMeasurements() async {
    List<MeasurementNode> unsyncedMeasurements = [];
    
    // Get unsynchronized measurements from the database
    final dbMeasurements = await DatabaseService.db.getUnsyncedMeasurements();
    
    for (var dbMeasurement in dbMeasurements) {
      unsyncedMeasurements.add(
        MeasurementNode(
          timestamp: DateTime.fromMillisecondsSinceEpoch(dbMeasurement['timestamp'] as int),
          temperatureValue: dbMeasurement['temperatureValue'] as double,
          isSyncedWithServer: false
        )
      );
    }
    
    return unsyncedMeasurements;
  }
  
  // Marks measurements as synchronized with the server
  Future<void> markMeasurementsAsSynced(List<MeasurementNode> syncedMeasurements) async {
    // Update measurements in memory
    for (var measurement in syncedMeasurements) {
      measurement.isSyncedWithServer = true;
    }
    
    // Update measurements in the database
    // Note: In this example, we don't know the measurement IDs, so we can't update the database
    // In a real application, the server response should include measurement IDs
    // For now, we're marking all unsynchronized measurements (for example purposes)
    final dbMeasurements = await DatabaseService.db.getUnsyncedMeasurements();
    List<int> measurementIds = dbMeasurements.map((m) => m['id'] as int).toList();
    
    if (measurementIds.isNotEmpty) {
      await DatabaseService.db.markMeasurementsAsSynced(measurementIds);
    }
  }
  
  // Load devices from database at application startup
  Future<void> loadDevicesFromDatabase() async {
    final devices = await DatabaseService.db.getAllDevices();
    
    for (var device in devices) {
      int deviceId = device['deviceId'] as int;
      
      // If the device is already in memory, don't update
      if (getActiveDeviceById(deviceId) != null) continue;
      
      // Create new device
      MedsenserDevice newDevice = MedsenserDevice(
        deviceId: deviceId,
        lastSeen: DateTime.fromMillisecondsSinceEpoch(device['lastSeen'] as int),
        firstSeen: device['firstSeen'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(device['firstSeen'] as int)
          : DateTime.fromMillisecondsSinceEpoch(device['lastSeen'] as int)
      );
      
      newDevice.convertedDeviceId = device['convertedDeviceId'] as String;
      newDevice.batteryLevel = device['batteryLevel'] as int;
      
      // Add to memory
      activeDevices.add(newDevice);
    }
  }
}
