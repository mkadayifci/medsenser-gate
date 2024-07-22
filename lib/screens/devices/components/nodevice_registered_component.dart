import 'dart:typed_data';

import 'package:flutter/material.dart';

class NoDeviceRegisteredComponent extends StatefulWidget {
  const NoDeviceRegisteredComponent({Key? key}) : super(key: key);

  @override
  State<NoDeviceRegisteredComponent> createState() =>
      _NoDeviceRegisteredComponentState();
}

class _NoDeviceRegisteredComponentState
    extends State<NoDeviceRegisteredComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
          child: Column(
        children: [
          Text("Hiç device kaydı yapılmamış."),
          Text(
              "Kullanıcı kaydı yaparak, bütün verileri saklayabilir. Başka telefonlardan erişebilirsiniz."),
        ],
      )),
    );
  }
}
