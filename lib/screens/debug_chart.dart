import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:medsenser_gate/models/device/measurement_node.dart';
import 'package:medsenser_gate/services/device_manager.dart';


class DebugChart extends StatefulWidget {
  @override
  _DebugChartState createState() => _DebugChartState();
}

class _DebugChartState extends State<DebugChart> {
  List<MeasurementNode> data= List.empty();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      if(DeviceManager().activeDevices.length>0){
      data = DeviceManager().activeDevices[0].measurements;
      data.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      }

    });
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Temperature Line Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: data.isEmpty
            ? Center(
                child: Text('No data available to display'),
              )
            : LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                              value.toInt());
                          return Text(
                            '${date.hour}:${date.minute}',
                            style: TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 32,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                        color: const Color(0xff37434d), width: 1),
                  ),
                  minX: data.first.timestamp.millisecondsSinceEpoch.toDouble(),
                  maxX: data.last.timestamp.millisecondsSinceEpoch.toDouble(),
                  minY: data
                      .map((e) => e.temperatureValue)
                      .reduce((a, b) => a < b ? a : b),
                  maxY: data
                      .map((e) => e.temperatureValue)
                      .reduce((a, b) => a > b ? a : b),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .map((e) => FlSpot(
                                e.timestamp.millisecondsSinceEpoch.toDouble(),
                                e.temperatureValue,
                              ))
                          .toList(),
                      //isCurved: true,
                      //colors: [Colors.blue],
                      barWidth: 2,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _loadData(); // Tazeleme işlemini burada tetikleyin
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

