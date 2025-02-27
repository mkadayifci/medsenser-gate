import 'package:medsenser_gate/models/device/measurement_node.dart';

class MedsenserDevice {
  final int deviceId;
  late String convertedDeviceId;
  final List<MeasurementNode> measurements = [];
  int batteryLevel = 0;
  DateTime lastSeen;
  late DateTime firstSeen;
  bool isNewDevice; // Flag indicating whether this is a new device

  MedsenserDevice({
    required this.deviceId, 
    required this.lastSeen,
    DateTime? firstSeen,
    this.isNewDevice = false
  }) {
    convertedDeviceId = "A4C35";
    this.firstSeen = firstSeen ?? lastSeen; // Use lastSeen as firstSeen if not specified
  }
}
