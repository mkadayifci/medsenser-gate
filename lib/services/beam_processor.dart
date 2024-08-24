import 'dart:async';

import 'package:medsenser_gate/models/advertisement_packages.dart';
import 'package:medsenser_gate/services/device_manager.dart';

class BeamProcessor {
  static final BeamProcessor _singleton = BeamProcessor._internal();

  final List<AdvertisementPacket> _beamDataQueue = [];

  factory BeamProcessor() {
    return _singleton;
  }

  BeamProcessor._internal();

  void addNewBeamData(AdvertisementPacket beamData) async {
    _beamDataQueue.add(beamData);
    proecessQueue();
  }

  Future<void> proecessQueue() async {
    while (_beamDataQueue.isNotEmpty) {
      AdvertisementPacket currentBeamData = _beamDataQueue.removeAt(0);

      if (currentBeamData.packageType ==
              AdvertisementPacket.packageTypeActiveTime ||
          currentBeamData.packageType ==
              AdvertisementPacket.packageTypeHistory ||           
          currentBeamData.packageType ==
              AdvertisementPacket.packageTypeExtentedHistory) {
        DeviceManager().addMeasurementData(currentBeamData);
      } else if (currentBeamData.packageType == 4) {
        print("Beam Processor: ${currentBeamData.deviceId}");
      }

      //StateManagerService.state.upsertDevice(currentBeamData);
      //StateManagerService.state.newDeviceFound();
    }
  }
}
