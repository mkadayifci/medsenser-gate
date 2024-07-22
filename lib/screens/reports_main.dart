import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:medsenser_gate/models/device/medsenser_device.dart';
import 'package:medsenser_gate/services/state_manager_service.dart';

class ReportsMainScreen extends StatefulWidget {
  const ReportsMainScreen({Key? key}) : super(key: key);

  @override
  State<ReportsMainScreen> createState() => _ReportsMainScreenState();
}

class _ReportsMainScreenState extends State<ReportsMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: StreamBuilder<List<MedsenserDevice>>(
            stream: StateManagerService.state.devicesInRangeChanged.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                List<MedsenserDevice>? devices = snapshot.data;

                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return FlipInX(
                          child: ListTile(
                        title: Column(
                          children: [
                            Text(
                                "Last Seen: ${snapshot.data![index].lastSeen!.toLocal()}"),
                            Text(
                                "Temp: ${snapshot.data![index].measurements.last.temperatureValue}"),
                            Text(
                                "Device Id: ${snapshot.data![index].deviceId.toRadixString(16)}"),
                            Text(
                                "Batt Level: ${snapshot.data![index].batteryLevel}"),
                          ],
                        ),
                      ));
                    });
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
