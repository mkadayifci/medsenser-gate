import 'package:medsenser_gate/models/device/measurement_node.dart';

class MedsenserDevice {
  final int deviceId;
  late String convertedDeviceId;
  final List<MeasurementNode> measurements = [];
  int batteryLevel = 0;
  DateTime? lastSeen;

  MedsenserDevice({required this.deviceId}) {
    convertedDeviceId = "A4C35";
  }
}
