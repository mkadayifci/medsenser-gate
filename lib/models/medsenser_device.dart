
class MedsenserDevice {
  final int deviceId;
  String convertedDeviceId;
  int batteryLevel = 0;
  double? lastMeasurement;
  DateTime lastSeen;
  bool isNewDevice; // Flag indicating whether this is a new device

  MedsenserDevice({
    required  this.deviceId, 
    required this.lastSeen,
    this.lastMeasurement,
    this.isNewDevice = false,
    this.convertedDeviceId = "",
    this.batteryLevel = 0,
  });


  
  @override
  String toString() {
    return 'MedsenserDevice(deviceId: $deviceId, convertedDeviceId: $convertedDeviceId, batteryLevel: $batteryLevel, lastSeen: $lastSeen';
  }
}
