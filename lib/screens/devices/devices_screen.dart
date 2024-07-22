import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medsenser_gate/components/founded_device_bottom_sheet.dart';
import 'package:medsenser_gate/components/medsenser_device_big_card.dart';
import 'package:medsenser_gate/models/device/medsenser_device.dart';
import 'package:medsenser_gate/screens/devices/components/multiple_device_registered_component.dart';
import 'package:medsenser_gate/screens/devices/components/nodevice_registered_component.dart';
import 'package:medsenser_gate/screens/devices/components/single_device_registered_component.dart';
import 'package:medsenser_gate/screens/landing/landing_screen.dart';
import 'package:medsenser_gate/services/database_service.dart';
import 'package:medsenser_gate/services/global_keys.dart';
import 'package:medsenser_gate/services/state_manager_service.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    StateManagerService.state.getRegisteredDevices().then((data) {
      StateManagerService.state.registeredDevicesChanged.sink.add(data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 40),
          child: Column(
            children: [
              Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [],
                      ),
                      Expanded(
                        child: StreamBuilder<List<MedsenserDevice>>(
                            stream: StateManagerService
                                .state.registeredDevicesChanged.stream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                List<MedsenserDevice> registeredDevices =
                                    snapshot.data ??
                                        List<MedsenserDevice>.empty();

                                switch (registeredDevices.length) {
                                  case 0:
                                    return const NoDeviceRegisteredComponent();
                                  case 1:
                                    return SingleDeviceRegisteredComponent(
                                        device: registeredDevices[0]);

                                  default:
                                    return MultipleDeviceRegisteredComponent(
                                        devices: registeredDevices);
                                }
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                      ),
                    ],
                  )),
              // Expanded(
              //     flex: 1,
              //     child: Column(
              //       children: [
              //         const Text("Yakınlardaki Cihazlar",
              //             style: TextStyle(
              //                 fontWeight: FontWeight.bold, fontSize: 18)),
              //         StreamBuilder<List<MedsenserDevice>>(
              //             stream: StateManagerService
              //                 .state.devicesInRangeChanged.stream,
              //             builder: (context, snapshot) {
              //               if (snapshot.connectionState ==
              //                   ConnectionState.active) {
              //                 List<MedsenserDevice> devicesInRange =
              //                     snapshot.data ??
              //                         List<MedsenserDevice>.empty();

              //                 return Expanded(
              //                   child: ListView(
              //                     controller: _scrollController,
              //                     children: [
              //                       ListView.builder(
              //                         shrinkWrap: true,
              //                         physics: const ClampingScrollPhysics(),
              //                         // itemCount: ((courses?.length) ?? 0) + 1,
              //                         itemCount: devicesInRange.length,
              //                         itemBuilder: (context, index) {
              //                           return GestureDetector(
              //                             onTap: () {
              //                               StateManagerService.state
              //                                   .addAsRegisteredDevice(
              //                                       devicesInRange[index]
              //                                           .deviceId,
              //                                       devicesInRange[index]
              //                                           .convertedDeviceId,
              //                                       devicesInRange[index]
              //                                               .lastSeen ??
              //                                           DateTime.now(),
              //                                       "phone",
              //                                       devicesInRange[index]
              //                                           .batteryLevel);
              //                             },
              //                             child: Opacity(
              //                               opacity: 0.2,
              //                               child: Row(children: [
              //                                 Image.asset(
              //                                   'assets/device_logo.png',
              //                                   width: 100,
              //                                   height: 100,
              //                                 ),
              //                                 Text(devicesInRange[index]
              //                                     .convertedDeviceId),
              //                                 const Text(
              //                                     "(Eklemek için dokunun)")
              //                               ]),
              //                             ),
              //                           );
              //                         },
              //                       ),
              //                     ],
              //                   ),
              //                 );
              //               } else {
              //                 return const Text("s");
              //               }
              //             }),
              //       ],
              //     )),
              // ElevatedButton(
              //   onPressed: () {
              //     showModalBottomSheet(
              //       context: GlobalKeysService.scaffoldKey.currentContext!,
              //       builder: (BuildContext context) {
              //         return FoundedDeviceBottomSheet();
              //       },
              //     );
              //   },
              //   child: const Text('Pencereyi Göster'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
