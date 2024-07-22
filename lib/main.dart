import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:medsenser_gate/models/ble_beam_data.dart';
import 'package:medsenser_gate/screens/landing/landing_screen.dart';
import 'package:medsenser_gate/screens/tabview_main.dart';
import 'package:medsenser_gate/services/beam_processor_service.dart';
import 'package:medsenser_gate/services/state_manager_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _checkPermissions();
  if (Platform.isAndroid) {
    //initAndroidBLE();
  } else {
    MethodChannel channel = const MethodChannel('ble_medsenser_channel');
    channel.setMethodCallHandler(_swiftSignal);
  }

  runApp(const MedsenserGateApp());
}

Future<void> _checkPermissions() async {
  if (Platform.isAndroid) {
    if (await Permission.bluetooth.isDenied) {
      await Permission.bluetooth.request();
    }

    //FOREGROUND_SERVICE_DATA_SYNC

    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothAdvertise.isDenied) {
      await Permission.bluetoothAdvertise.request();
    }

    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
    if (await Permission.backgroundRefresh.isDenied) {
      await Permission.backgroundRefresh.request();
    }
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // İzinlerin durumunu kontrol edin ve kullanıcıyı bilgilendirin
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.location,
      Permission.backgroundRefresh,
      Permission.notification,
    ].request();

    statuses.forEach((permission, status) {
      if (status.isDenied) {
        print('$permission denied');
      } else if (status.isGranted) {
        print('$permission granted');
      }
    });
  }
}

void initAndroidBLE() async {
  try {
    // if you want to manage manual checking about the required permissions
    //await flutterBeacon.initializeScanning;

    // or if you want to include automatic checking permission
    //await flutterBeacon.initializeAndCheckScanning;
  } on PlatformException catch (e) {
    // library failed to initialize, check code and message
  }
}

class MedsenserGateApp extends StatefulWidget {
  const MedsenserGateApp({super.key});

  @override
  State<MedsenserGateApp> createState() => _MedsenserGateAppState();
}

class _MedsenserGateAppState extends State<MedsenserGateApp> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
    StateManagerService.state.initState();

    // final regions = <Region>[];

    // // Android platform, it can ranging out of beacon that filter all of Proximity UUID
    // regions.add(Region(identifier: 'BA0FD034-9E5B-0D8B-534B-E22A6FAC6BFD'));
    // // to start monitoring beacons
    // _streamMonitoring =
    //     flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
    //   print("MAJORRRRR: " + result.region.major.toString());
    // });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Open Sans',
          primaryColor: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: StreamBuilder<bool>(
            stream: StateManagerService.state.needLandingScreenChanged.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                bool needsLandingPage = snapshot.data ?? true;
                if (needsLandingPage) {
                  return LandingScreen();
                } else {
                  return TabViewMainScreen();
                }
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }));
  }
}

Future<dynamic> _swiftSignal(MethodCall call) async {
  switch (call.method) {
    case 'ble_notification':
      final Map arguments = call.arguments;
      int deviceId = ((arguments['ManufData'][4] as int) << 16) |
          ((arguments['ManufData'][3] as int) << 8) |
          (arguments['ManufData'][2] as int);
      int measuredTemperature = ((arguments['ManufData'][6] as int) << 8) |
          (arguments['ManufData'][5] as int);
      int batteryLevel = ((arguments['ManufData'][7] as int));

      BleBeamData beamData = BleBeamData(
          deviceId: deviceId,
          measuredTemperature: (measuredTemperature * 0.0078125),
          batteryLevel: batteryLevel);
      BeamProcessorService().addNewBeamData(beamData);

      return true;
    default:
      throw PlatformException(
        code: 'Unimplemented',
        details: 'Method ${call.method} not implemented',
      );
  }
}
