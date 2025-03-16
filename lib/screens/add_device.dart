import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:medsenser_gate/models/medsenser_device.dart';
import 'package:medsenser_gate/services/device_service.dart';
import 'package:medsenser_gate/services/native_comm_channel.dart';

class AddDeviceScreen extends StatefulWidget {
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
   
}

class _AddDeviceScreenState extends State<AddDeviceScreen> with TickerProviderStateMixin{
  
  late GifController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = GifController(vsync: this);
    // Start searching for new devices when the screen is opened
    startSearching();
    DeviceService().getAllDevices().then((devices) {
      print(devices);
    });
  }

  void startSearching() {
DeviceService().newDeviceStream.listen((deviceId) {

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Gif(
                  image: AssetImage("assets/medsenser_rotating.gif"),
                  controller: _controller, // if duration and fps is null, original gif fps will be used.
                  //fps: 30,               
                  duration: const Duration(seconds: 3),
                  autostart: Autostart.loop,
                  placeholder: (context) => const Text('Loading...'),
                  onFetchCompleted: () {
                    _controller.reset();
                    print("completed");
                    _controller.forward();
                  },
                ),
                Text(
                  'Termometre Bulundu',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {

                  MedsenserDevice device = 
                  MedsenserDevice(deviceId: deviceId, 
                  convertedDeviceId: deviceId.toString(), 
                  lastSeen: DateTime.now(), 
                  batteryLevel: 100);
                  DeviceService().addOrUpdateDevice(device);

                    // Add device logic here
                    print("Device added successfully.");
                  },
                  child: Text('Add Device'),
                ),
              ],
            ),
          );
        },
      );
  print('New Device: Device ID: $deviceId');
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Device'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Searching for new devices...'),
            FloatingActionButton(
              onPressed: () {
                
              },
              tooltip: 'Show Bottom Sheet',
              child: Icon(Icons.add),
            ),
          ],
        ) 
       
      ),
      bottomSheet: Container(
        child: Text('New device found!'),
      ),
    );
  }
  
}

