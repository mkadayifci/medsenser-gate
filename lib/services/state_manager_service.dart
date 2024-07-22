import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:medsenser_gate/components/founded_device_bottom_sheet.dart';
import 'package:medsenser_gate/models/ble_beam_data.dart';
import 'package:medsenser_gate/models/device/measurement_node.dart';
import 'package:medsenser_gate/models/device/medsenser_device.dart';
import 'package:medsenser_gate/services/database_service.dart';
import 'package:medsenser_gate/services/global_keys.dart';

class StateManagerService {
  static final StateManagerService state = StateManagerService._();
  var needsToShowLanding = true;
  StateManagerService._();

  final List<MedsenserDevice> devicesInRange = [];

  StreamController<List<MedsenserDevice>> devicesInRangeChanged =
      StreamController<List<MedsenserDevice>>();

  StreamController<List<MedsenserDevice>> registeredDevicesChanged =
      StreamController<List<MedsenserDevice>>();

  StreamController<bool> needLandingScreenChanged = StreamController<bool>();

  void initState() {
    needLandingScreenChanged.sink.add(true);
  }

  void changeNeedsToShowLanding(bool newVal) {
    needsToShowLanding = newVal;
    needLandingScreenChanged.sink.add(newVal);
  }

  void newDeviceFound() {
    showModalBottomSheet(
      context: GlobalKeysService.scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return const FoundedDeviceBottomSheet();
      },
    );
  }

  void upsertDevice(BleBeamData beamData) {
    MedsenserDevice? deviceInArray;

    for (MedsenserDevice device in devicesInRange) {
      if (device.deviceId == beamData.deviceId) {
        deviceInArray = device;
        break;
      }
    }

    if (deviceInArray == null) {
      var newDevice = MedsenserDevice(deviceId: beamData.deviceId);
      devicesInRange.add(newDevice);
      deviceInArray = newDevice;
    }

    deviceInArray.lastSeen = DateTime.now();
    deviceInArray.batteryLevel = beamData.batteryLevel;
    deviceInArray.measurements.add(MeasurementNode(
        timestamp: DateTime.now(),
        temperatureValue: beamData.measuredTemperature));

    devicesInRangeChanged.sink.add(devicesInRange.toList());
  }

  Future<List<MedsenserDevice>> getRegisteredDevices() async {
    List<MedsenserDevice> registeredDevices = [];
    var registeredRawDevices = await DatabaseService.db.getAllDevices();
    for (var rawDevice in registeredRawDevices) {
      var deviceToAdd = MedsenserDevice(deviceId: rawDevice["deviceId"]);
      deviceToAdd.lastSeen =
          DateTime.fromMillisecondsSinceEpoch(rawDevice["lastSeen"]);

      registeredDevices.add(deviceToAdd);
    }
    return registeredDevices;
  }

  void addAsRegisteredDevice(int deviceId, String convertedDeviceId,
      DateTime lastSeen, String phoneIdentifier, int batteryLevel) {
    DatabaseService.db.insertRegisteredDevice(
        deviceId, convertedDeviceId, lastSeen, phoneIdentifier, batteryLevel);

    getRegisteredDevices().then((data) {
      registeredDevicesChanged.sink.add(data);
    });
  }
}
