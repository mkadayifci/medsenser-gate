import 'dart:async';

import 'package:flutter/services.dart';
import 'package:medsenser_gate/models/mesurement_node.dart';


class NativeCommChannel {

  static final NativeCommChannel _singleton = NativeCommChannel._internal();
  
  final StreamController<int> _memsActivatedStreamController = StreamController<int>.broadcast();
  Stream<int> get memsActivatedStream => _memsActivatedStreamController.stream;
  
  final StreamController<MeasurementNode> _newMeasurementStreamController = StreamController<MeasurementNode>.broadcast();
  Stream<MeasurementNode> get newMeasurementStream => _newMeasurementStreamController.stream;

  final StreamController<MeasurementNode> _historicMeasurementStreamController = StreamController<MeasurementNode>.broadcast();
  Stream<MeasurementNode> get historicMeasurementStream => _historicMeasurementStreamController.stream; 

  static NativeCommChannel get instance => _singleton;


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
        
        return true;
      case 'new_measurement':
        if(call.arguments['isHistoricValue'] == true){  
          _historicMeasurementStreamController.add(
            MeasurementNode(
              deviceId: call.arguments['deviceId'], 
              timestamp: call.arguments['timestamp'], 
              temperatureValue: call.arguments['temperatureValue'])); 
        }else{
          _newMeasurementStreamController.add(
            MeasurementNode(
              deviceId: call.arguments['deviceId'], 
              timestamp: call.arguments['timestamp'], 
              temperatureValue: call.arguments['temperatureValue'])); 
        }



        return true;
      case 'mems_activated':
        _memsActivatedStreamController.add(call.arguments['deviceId']);
        return true;      

    }
    return true;
  }

  }

 
  
  


