import 'package:flutter/material.dart';
import 'package:medsenser_gate/models/device/medsenser_device.dart';

class MultipleDeviceRegisteredComponent extends StatefulWidget {
  final List<MedsenserDevice> devices;
  const MultipleDeviceRegisteredComponent({super.key, required this.devices});

  @override
  State<MultipleDeviceRegisteredComponent> createState() =>
      _MultipleDeviceRegisteredComponentState();
}

class _MultipleDeviceRegisteredComponentState
    extends State<MultipleDeviceRegisteredComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SafeArea(
          child: Column(
        children: [
          Text("Multiple Device Kaydı Yapılmış."),
          Text(" "),
        ],
      )),
    );
  }
}
