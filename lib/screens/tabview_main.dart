import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:medsenser_gate/components/medsenser_app_bar.dart';
import 'package:medsenser_gate/screens/devices/devices_screen.dart';

import 'package:medsenser_gate/screens/reports_main.dart';
import 'package:medsenser_gate/screens/settings_main.dart';
import 'package:medsenser_gate/services/global_keys.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:simple_shadow/simple_shadow.dart';

class TabViewMainScreen extends StatefulWidget {
  const TabViewMainScreen({Key? key}) : super(key: key);

  @override
  State<TabViewMainScreen> createState() => _TabViewMainScreenState();
}

class _TabViewMainScreenState extends State<TabViewMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKeysService.scaffoldKey,
      appBar: MedsenserAppBar(
        title: SimpleShadow(
          opacity: 0.5,
          color: Colors.black,
          offset: const Offset(0.2, 0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/medsenser_logo.png",
                width: 40,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                "Medsenser",
                style: (TextStyle(
                    color: Colors.white,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    letterSpacing: 1.0)),
              ),
            ],
          ),
        ),
        context: context,
      ),
      body: PersistentTabView(
        screenTransitionAnimation: const ScreenTransitionAnimation(
          curve: Curves.ease,
          duration: Duration(milliseconds: 300),
        ),
        tabs: [
          PersistentTabConfig(
            screen: const DevicesScreen(),
            item: ItemConfig(
              icon: const Icon(Icons.home_outlined),
              title: "Ana Sayfa",
            ),
          ),
          PersistentTabConfig(
            screen: const ReportsMainScreen(),
            item: ItemConfig(
              icon: const Icon(Icons.message),
              title: "Raporlar",
            ),
          ),
          PersistentTabConfig(
            screen: const SettingsMainScreen(),
            item: ItemConfig(
              icon: const Icon(Icons.person_outline),
              title: "Ayarlar",
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style6BottomNavBar(
          navBarDecoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(2.0),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.white],
            ),
          ),
          navBarConfig: navBarConfig,
        ),
      ),
    );
  }
}
