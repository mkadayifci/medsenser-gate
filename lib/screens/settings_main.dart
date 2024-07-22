import 'dart:typed_data';

import 'package:flutter/material.dart';

class SettingsMainScreen extends StatefulWidget {
  const SettingsMainScreen({Key? key}) : super(key: key);

  @override
  State<SettingsMainScreen> createState() => _SettingsMainScreenState();
}

class _SettingsMainScreenState extends State<SettingsMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
            child: Column(
          children: [
            Text("Ayarlar Ekranı"),
            Text(
                "Kullanıcı kaydı yaparak, bütün verileri saklayabilir. Başka telefonlardan erişebilirsiniz."),
          ],
        )),
      ),
    );
  }
}
