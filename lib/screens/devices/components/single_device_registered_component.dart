import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:medsenser_gate/components/founded_device_bottom_sheet.dart';
import 'package:medsenser_gate/components/medsenser_device_big_card.dart';
import 'package:medsenser_gate/models/device/medsenser_device.dart';

class SingleDeviceRegisteredComponent extends StatefulWidget {
  final MedsenserDevice device;
  const SingleDeviceRegisteredComponent({Key? key, required this.device})
      : super(key: key);

  @override
  State<SingleDeviceRegisteredComponent> createState() =>
      _SingleDeviceRegisteredComponentState();
}

class _SingleDeviceRegisteredComponentState
    extends State<SingleDeviceRegisteredComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          MedsenserDeviceBigCard(medSenserDevice: this.widget.device),
        ],
      ),
    );
  }
}
