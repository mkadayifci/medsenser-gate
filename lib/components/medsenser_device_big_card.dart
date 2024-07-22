import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medsenser_gate/components/temperature_card.dart';
import 'package:medsenser_gate/models/device/medsenser_device.dart';

class MedsenserDeviceBigCard extends StatelessWidget {
  final MedsenserDevice medSenserDevice;

  MedsenserDeviceBigCard({Key? key, required this.medSenserDevice})
      : super(key: key);

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => const FlTitlesData(
      show: true,
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ));

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blueGrey,
          Colors.grey,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
  LinearGradient get _redGradient => const LinearGradient(
        colors: [Colors.red, Colors.redAccent],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _greenGradient => const LinearGradient(
        colors: [
          Colors.green,
          Colors.greenAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 8,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 14,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 15,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: 13,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: 10,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: 36.5,
              width: 13,
              gradient: _greenGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(
              toY: 38.4,
              width: 13,
              gradient: _redGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
              toY: 38.6,
              width: 13,
              gradient: _redGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(
              toY: 16,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(
              toY: 16,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(
              toY: 16,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 12,
          barRods: [
            BarChartRodData(
              toY: 16,
              width: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 100),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(medSenserDevice.lastSeen.toString(),
              //     style: const TextStyle(
              //       fontSize: 23,
              //       fontWeight: FontWeight.bold,
              //     )),

              ZoomIn(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context)
                                .style, // Varsayılan metin stili
                            children: <TextSpan>[
                              const TextSpan(
                                text: "İpek", // Sıcaklığın tam sayı kısmı
                                style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight
                                        .w500), // Ana kısım için font boyutu
                              ),
                              TextSpan(
                                text: " (${medSenserDevice.convertedDeviceId})",
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight
                                        .bold), // Ondalık kısmın font boyutu, ana kısımın 2/3'ü
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.edit),
                      ],
                    ),
                    ZoomIn(child: const TemperatureCard(temperature: 37.3)),
                  ],
                ),
              ),
              // Divider(
              //   color: Colors.grey,
              //   thickness: 1,
              // ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Son 1 saatteki ölçümler",
                    textAlign: TextAlign.left,
                  ),
                  ZoomIn(
                    child: SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width - 10,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BarChart(
                          BarChartData(
                            barTouchData: barTouchData,
                            titlesData: titlesData,
                            borderData: borderData,
                            barGroups: barGroups,
                            gridData: const FlGridData(show: false),
                            alignment: BarChartAlignment.spaceBetween,
                            maxY: 45,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ZoomIn(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Elemanları başlangıç ve bitişe yasla
                        children: <Widget>[
                          Text("5dk önce"), // Sol taraftaki metin
                          Expanded(
                            child: Container(
                              height: 1.0, // Çizginin kalınlığı
                              color: Colors.grey, // Çizginin rengi
                              margin: const EdgeInsets.only(
                                  left:
                                      10), // Metinlerle çizgi arasındaki boşluk
                            ),
                          ),
                          Icon(Icons.arrow_right,
                              color: Colors.grey), // Sağa doğru ok ikonu
                          Text("60dk önce"), // Sağ taraftaki metin
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
