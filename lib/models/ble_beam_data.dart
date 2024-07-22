class BleBeamData {
  final int deviceId;
  final double measuredTemperature;
  final int batteryLevel;

  BleBeamData(
      {required this.deviceId,
      required this.measuredTemperature,
      required this.batteryLevel});
}
