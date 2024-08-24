import 'package:flutter/material.dart';
import 'package:medsenser_gate/models/advertisement_packages.dart';
import 'package:medsenser_gate/services/native_comm_channel.dart';
import 'package:pulsator/pulsator.dart';
import 'package:simple_shadow/simple_shadow.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
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
              SizedBox(
                width: 250,
                height: 250,
                child: Pulsator(
                  style: const PulseStyle(
                      color: Colors.purple,
                      gradientStyle: PulseGradientStyle(
                          startColor: Colors.red, radius: 0.7)),
                  count: 6,
                  duration: const Duration(seconds: 10),
                  repeat: 0,
                  startFromScratch: false,
                  autoStart: true,
                  fit: PulseFit.contain,
                  child: SimpleShadow(
                    offset: const Offset(0.3, 0.3),
                    child: const Text(
                      "39,3",
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              StreamBuilder<AdvertisementPacket>(
                stream: NativeCommChannel().advertisementReceived.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    AdvertisementPacket? packet = snapshot.data;
                    if (packet == null) {
                      return Container();
                    }

                    return Column(children: [
                      Text("Id: ${packet.deviceId}"),
                      //Text("Sequence: ${packet.subData}"),
                      // Text(
                      //     "Temp: ${(packet.subData as ActiveTimePackageData).currentTemp}"),
                    ]);
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
