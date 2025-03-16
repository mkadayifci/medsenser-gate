import 'dart:async';

import 'package:medsenser_gate/models/medsenser_device.dart';
import 'package:medsenser_gate/models/mesurement_node.dart';
import 'package:medsenser_gate/services/database_service.dart';
import 'package:medsenser_gate/services/native_comm_channel.dart';

class DeviceService {
  static final DeviceService _singleton = DeviceService._internal();
  final DatabaseService _databaseService = DatabaseService.db;
  
  final StreamController<int> _newDeviceStreamController = StreamController<int>.broadcast();
  Stream<int> get newDeviceStream => _newDeviceStreamController.stream;

  final StreamController<MeasurementNode> _newMeasurementStreamController = StreamController<MeasurementNode>.broadcast();
  Stream<MeasurementNode> get newMeasurementStream => _newMeasurementStreamController.stream;

  // In-memory device list
  final List<MedsenserDevice> _devices = [];
  bool _isInitialized = false;
  
  // Getter for devices
  List<MedsenserDevice> get devices => List.unmodifiable(_devices);

  factory DeviceService() {
    return _singleton;
  }

  DeviceService._internal() {
    // We'll initialize lazily when needed
    NativeCommChannel.instance.newMeasurementStream.listen((event) {
      _newMeasurementStreamController.add(event);
      addDeviceMeasurement(event.deviceId, event.timestamp, event.temperatureValue);
    });
    
NativeCommChannel.instance.historicMeasurementStream.listen((event) {
  addDeviceMeasurement(event.deviceId, event.timestamp, event.temperatureValue);
});

    NativeCommChannel.instance.memsActivatedStream.listen((deviceId) async {
      if(!await isDeviceActive(deviceId)){
        _newDeviceStreamController.add(deviceId);
      }      
        
    });
  }
  
  // Initialize the service
  Future<void> initialize() async {
    if (!_isInitialized) {
      await _loadDevicesFromDatabase();
      _isInitialized = true;
      var data = await fetchDeviceMeasurements(1118754);
      data.forEach((measurement) => print("Device ID: ${measurement.deviceId}, Temperature Value: ${measurement.temperatureValue}"));
    }
  }
  
  // Load devices from database into memory
  Future<void> _loadDevicesFromDatabase() async {
    final dbDevices = await _fetchDevicesFromDatabase();
    _devices.clear();
    _devices.addAll(dbDevices);
  }
  
  // Fetch devices from database
  Future<List<MedsenserDevice>> _fetchDevicesFromDatabase() async {
    List<Map<String, dynamic>> devices = await _databaseService.getAllDevices();
    return devices.map((device) => MedsenserDevice(
      deviceId: device['deviceId'],
      convertedDeviceId: device['convertedDeviceId'],
      lastSeen: DateTime.fromMillisecondsSinceEpoch(device['lastSeen']),
      batteryLevel: device['batteryLevel'],
    )).toList();
  }

  // Fetch measurements for a specific device from database
  Future<List<MeasurementNode>> fetchDeviceMeasurements(int deviceId) async {
    final dbMeasurements = await _databaseService.getDeviceMeasurements(deviceId);
    return dbMeasurements.map((measurement) => MeasurementNode(
      deviceId: deviceId,
      timestamp: measurement['timestamp'],
      temperatureValue: measurement['temperatureValue']
  
    )).toList();
  }

  // Get all devices (from memory)
  Future<List<MedsenserDevice>> getAllDevices() async {
    await initialize();
    return devices;
  }
  
  // Get all devices (from database)
  Future<List<MedsenserDevice>> refreshDevices() async {
    await _loadDevicesFromDatabase();
    return devices;
  }
  
  // Check if a device with the given ID exists in active devices
  Future<bool> isDeviceActive(int deviceId) async {
    await initialize();
    return _devices.any((device) => device.deviceId == deviceId);
  }
  
  // Find a device by ID
  Future<MedsenserDevice?> findDeviceById(int deviceId) async {
    await initialize();
    try {
      return _devices.firstWhere((device) => device.deviceId == deviceId);
    } catch (e) {
      // Device not found
      return null;
    }
  }
  
  // Add or update a device
  Future<void> addOrUpdateDevice(MedsenserDevice device) async {
    await initialize();
    
    // Update in database
    await _databaseService.insertDevice(device.deviceId, device.convertedDeviceId, 
        device.lastSeen.millisecondsSinceEpoch, device.batteryLevel);
    
    // Update in memory
    final index = _devices.indexWhere((d) => d.deviceId == device.deviceId);
    if (index >= 0) {
      _devices[index] = device;
    } else {
      _devices.add(device);
    }
  }

  // Add a new measurement for a device
  Future<void> addDeviceMeasurement(int deviceId, int timestamp, double temperatureValue) async {
    await initialize();
    // Check if the device exists
    final deviceExists = _devices.any((device) => device.deviceId == deviceId);
    if (!deviceExists) {
      // Device not found
      return;
    }
    // Add measurement to database
    await _databaseService.insertMeasurement(
      deviceId, 
      timestamp, 
      temperatureValue);
    // Update device's last measurement in memory
    _devices.firstWhere((device) => device.deviceId == deviceId).lastMeasurement = temperatureValue;
  }
}







