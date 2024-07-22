import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class TemperatureCard extends StatelessWidget {
  final double temperature;

  const TemperatureCard({Key? key, required this.temperature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String tempAsString = temperature.toString().replaceAll(',', '.');
    List<String> parts = tempAsString.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '0';

    return SimpleShadow(
      opacity: 1,
      offset: const Offset(1.2, 1.2),
      color: const Color(0xFFB71C1C),
      child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: <Color>[
                Colors.red,
                Colors.redAccent
              ], // Burada gradyanınızın renklerini ayarlayın
              begin: Alignment.topLeft, // Gradyanın başlangıç noktası
              end: Alignment.bottomRight, // Gradyanın bitiş noktası
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn, // Metin rengini gradyan ile karıştır
          child: RichText(
            text: TextSpan(
              style:
                  DefaultTextStyle.of(context).style, // Varsayılan metin stili
              children: <TextSpan>[
                TextSpan(
                  text: integerPart, // Sıcaklığın tam sayı kısmı
                  style: TextStyle(
                      fontSize: 70,
                      fontWeight:
                          FontWeight.bold), // Ana kısım için font boyutu
                ),
                TextSpan(
                  text: '.' + decimalPart, // Sıcaklığın ondalık kısmı
                  style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight
                          .bold), // Ondalık kısmın font boyutu, ana kısımın 2/3'ü
                ),
                TextSpan(
                  text: '°C', // Sıcaklığın ondalık kısmı
                  style: TextStyle(
                      fontSize: 70,
                      fontWeight: FontWeight
                          .bold), // Ondalık kısmın font boyutu, ana kısımın 2/3'ü
                ),
              ],
            ),
          )

          // Text(
          //   '${temperature}°C',
          //   style: TextStyle(
          //     fontSize: 70, // Metin boyutunu ayarlayın
          //     fontWeight: FontWeight.bold, // Metin kalınlığını ayarlayın
          //     // Metin rengi artık burada değil, ShaderMask tarafından belirlenecek
          //   ),
          // ),
          ),
    );

    // return Card(
    //   elevation: 1.0,
    //   shape: RoundedRectangleBorder(
    //       borderRadius:
    //           BorderRadius.circular(45)), // Daha yuvarlak köşeler için
    //   child: Container(
    //     width: 250, // Boyutları güncellendi
    //     height: 120, // Yuvarlak bir görünüm için genişlik ve yükseklik eşit
    //     decoration: BoxDecoration(
    //       borderRadius:
    //           BorderRadius.circular(45), // Container için de yuvarlak köşeler
    //       gradient: LinearGradient(
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //         colors: [Colors.red, Colors.redAccent],
    //       ),
    //     ),
    //     child: Center(
    //       // İkon kaldırıldı, sadece sıcaklık değeri
    //       child: SimpleShadow(
    //         opacity: 0.5,
    //         offset: Offset(0.1, 0.1),
    //         color: Colors.black,
    //         child: Text(
    //           '${temperature}°C',
    //           style: TextStyle(
    //             fontSize: 48,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
