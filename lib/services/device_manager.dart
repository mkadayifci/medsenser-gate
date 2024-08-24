import 'dart:async';

import 'package:medsenser_gate/models/advertisement_packages.dart';
import 'package:medsenser_gate/models/device/measurement_node.dart';
import 'package:medsenser_gate/models/device/medsenser_device.dart';

class DeviceManager 
{
  static final DeviceManager _singleton = DeviceManager._internal();
  List<MedsenserDevice> activeDevices = List.empty(growable: true);

  factory DeviceManager() 
  {
    return _singleton;
  }

  DeviceManager._internal();

  void addMeasurementData(AdvertisementPacket advertisementData) 
  {
    MedsenserDevice? activeDeviceInArray = getActiveDeviceById(advertisementData.deviceId);
    if (activeDeviceInArray == null) 
    {
      activeDeviceInArray = MedsenserDevice(deviceId: advertisementData.deviceId);
      activeDevices.add(activeDeviceInArray);
    }

    if (advertisementData.packageType == AdvertisementPacket.packageTypeActiveTime) 
    {
      ActiveTimePackageData activeTimePackageData = advertisementData.subData as ActiveTimePackageData;
      addMeasurementNodeToDevice(activeDeviceInArray, 0, activeTimePackageData.currentTemp);
      addMeasurementNodeToDevice(activeDeviceInArray, 1, activeTimePackageData.lastTemp1);
      addMeasurementNodeToDevice(activeDeviceInArray, 2, activeTimePackageData.lastTemp2);
      addMeasurementNodeToDevice(activeDeviceInArray, 5, activeTimePackageData.lastTemp3);
    } 
    else if (advertisementData.packageType == AdvertisementPacket.packageTypeHistory) 
    {
      HistoryPackageData historyPackageData = advertisementData.subData as HistoryPackageData;
      addMeasurementNodeToDevice(activeDeviceInArray, 5, historyPackageData.previousTemp1);
      addMeasurementNodeToDevice(activeDeviceInArray, 10, historyPackageData.previousTemp2);
      addMeasurementNodeToDevice(activeDeviceInArray, 15, historyPackageData.previousTemp3);
      addMeasurementNodeToDevice(activeDeviceInArray, 20, historyPackageData.previousTemp4);
      addMeasurementNodeToDevice(activeDeviceInArray, 25, historyPackageData.previousTemp5);
    }
        else if (advertisementData.packageType == AdvertisementPacket.packageTypeExtentedHistory) 
    {
      HistoryPackageData historyPackageData = advertisementData.subData as HistoryPackageData;
      addMeasurementNodeToDevice(activeDeviceInArray, 10, historyPackageData.previousTemp1);
      addMeasurementNodeToDevice(activeDeviceInArray, 20, historyPackageData.previousTemp2);
      addMeasurementNodeToDevice(activeDeviceInArray, 30, historyPackageData.previousTemp3);
      addMeasurementNodeToDevice(activeDeviceInArray, 40, historyPackageData.previousTemp4);
      addMeasurementNodeToDevice(activeDeviceInArray, 50, historyPackageData.previousTemp5);
    }

  }

  void addMeasurementNodeToDevice(MedsenserDevice device, int minutesBefore, int parcelableTemperature) 
  {
    device.measurements.add(
        MeasurementNode(
            timestamp: DateTime.now().toUtc().subtract(Duration(minutes: minutesBefore)),
            temperatureValue: MeasurementNode.convertParcelableTemperature(parcelableTemperature)
            )
        );
  }

  MedsenserDevice? getActiveDeviceById(int deviceId) {
    try {
      return activeDevices.firstWhere((device) => device.deviceId == deviceId);
    } catch (e) {
      // Eğer liste içinde id'ye sahip bir device bulunamazsa null döndür
      return null;
    }
  }
}
