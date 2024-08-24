import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsenser_gate/screens/debug_chart.dart';
import 'package:medsenser_gate/screens/tabview_main.dart';
import 'package:medsenser_gate/services/beam_processor.dart';
import 'package:medsenser_gate/services/native_comm_channel.dart';
import 'package:medsenser_gate/services/state_manager_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _checkPermissions();
  if (Platform.isAndroid) {
    //initAndroidBLE();
  } else {}

  runApp(const MedsenserGateApp());

  NativeCommChannel().registerChannel();
  NativeCommChannel().advertisementReceived.stream.listen((receivedPackage) {


    BeamProcessor().addNewBeamData(receivedPackage);
  });
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
                  //return DebugScreen(); // LandingScreen();
                 
                  return DebugChart();
     
    
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
