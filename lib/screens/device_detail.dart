import 'package:flutter/material.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:medsenser_gate/components/temperature_card.dart';
import 'package:medsenser_gate/models/medsenser_device.dart';
import 'package:medsenser_gate/services/device_service.dart';
import 'package:medsenser_gate/services/native_comm_channel.dart';

class DeviceDetailScreen extends StatefulWidget {
  final MedsenserDevice device;
  var currentTemperature= 36.2;
  DeviceDetailScreen({required this.device});

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DeviceService().newMeasurementStream.listen((event) {
      setState(() {
        print("deviceid: ${event.deviceId}");
        if(event.deviceId==1118754){
          widget.currentTemperature = event.temperatureValue;
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
  // Add a ListView to the drawer. This ensures the user can scroll
  // through the options in the drawer if there isn't enough vertical
  // space to fit everything.
  child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Text('Drawer Header'),
      ),
      ListTile(
        title: const Text('Yeni Cihaz Ekle'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: const Text('Item 2'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
    ],
  ),
),
      appBar: AppBar(
    title: const Text('AppBar with hamburger button'),
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    ),
  ),
      body: Center(
        child:  TemperatureCard(temperature:  widget.currentTemperature),
    ),
    );
    
  }
}

