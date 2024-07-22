import 'package:medsenser_gate/models/ble_beam_data.dart';
import 'package:medsenser_gate/services/state_manager_service.dart';

class BeamProcessorService {
  static final BeamProcessorService _singleton =
      BeamProcessorService._internal();

  final List<BleBeamData> _beamDataQueue = [];

  factory BeamProcessorService() {
    return _singleton;
  }

  BeamProcessorService._internal();

  void addNewBeamData(BleBeamData beamData) {
    _beamDataQueue.add(beamData);
    proecessQueue();
  }

  void proecessQueue() {
    while (_beamDataQueue.isNotEmpty) {
      BleBeamData currentBeamData = _beamDataQueue.removeAt(0);
      StateManagerService.state.upsertDevice(currentBeamData);
      //StateManagerService.state.newDeviceFound();
    }
  }
}
