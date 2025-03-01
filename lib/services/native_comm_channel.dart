import 'dart:async';

import 'package:flutter/services.dart';
import 'package:medsenser_gate/models/advertisement_packages.dart';

class NativeCommChannel {
  StreamController<AdvertisementPacket> advertisementReceived =
      StreamController<AdvertisementPacket>.broadcast();

  static final NativeCommChannel _singleton = NativeCommChannel._internal();

  final List<AdvertisementPacket> _beamDataQueue = [];
  MethodChannel? _channel;

  factory NativeCommChannel() {
    return _singleton;
  }

  NativeCommChannel._internal();

  void registerChannel() {
    _channel = const MethodChannel('ble_medsenser_channel');
    _channel?.setMethodCallHandler(_channelSignal);
  }

  Future<dynamic> _channelSignal(MethodCall call) async {
    switch (call.method) {
      case 'advertisement_received':
        final Map arguments = call.arguments;
        // Print incoming data

        List<int> manufData = arguments['ManufData'] as List<int>;
        print(manufData);
        int deviceId =
            (manufData[0] << 16) | (manufData[1] << 8) | (manufData[2]);

        int packageType = manufData[3];

        AdvertisementSubData subData;
        if (packageType == 1) {
          subData = createActiveTimeSubData(manufData);
        } else if (packageType == 2) {
          subData = createHistorySubData(manufData);
        } else {
          subData = DefaultPackageData(
              currentTemp: manufData[5], battery: manufData[6]);
        }

        AdvertisementPacket advertisementPacket = AdvertisementPacket(
            deviceId: deviceId, packageType: packageType, subData: subData);

        advertisementReceived.sink.add(advertisementPacket);

        return true;
    }
    return true;
  }

  AdvertisementSubData createActiveTimeSubData(List<int> manufData) {
    AdvertisementSubData subData;
    int lastTemp3 = manufData[5];
    int lastTemp2 = manufData[6];
    int lastTemp1 = manufData[7];
    int currentTemp = manufData[8];
    subData = ActiveTimePackageData(
        sequence: manufData[4],
        currentTemp: currentTemp,
        lastTemp1: lastTemp1,
        lastTemp2: lastTemp2,
        lastTemp3: lastTemp3);
    return subData;
  }

  HistoryPackageData createHistorySubData(List<int> manufData) {
    HistoryPackageData subData;
    int previousTemp5 = manufData[4];
    int previousTemp4 = manufData[5];
    int previousTemp3 = manufData[6];
    int previousTemp2 = manufData[7];
    int previousTemp1 = manufData[8];
    subData = HistoryPackageData(
      previousTemp1: previousTemp1,
      previousTemp2: previousTemp2,
      previousTemp3: previousTemp3,
      previousTemp4: previousTemp4,
      previousTemp5: previousTemp5,
    );
    return subData;
  }
  
  /// Enable or disable debug logging in the native DeviceManager
  /// 
  /// When enabled, detailed logs about device processing will be printed to the console
  Future<bool> setDebugLogging(bool enabled) async {
    print("Setting debug logging to: $enabled");
    
    try {
      final result = await _channel?.invokeMethod<bool>('setDebugLogging', {'enabled': enabled});
      return result ?? false;
    } catch (e) {
      print("Error setting debug logging: $e");
      return false;
    }
  }
}
