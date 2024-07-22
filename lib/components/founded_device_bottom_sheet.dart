import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class FoundedDeviceBottomSheet extends StatelessWidget {
  const FoundedDeviceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330, // Pencerenin yüksekliği
      child: Padding(
        padding:
            const EdgeInsets.only(top: 30, left: 10, bottom: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
                textAlign: TextAlign.center,
                'Yakında bir ateş ölçer bulundu. Hesabınıza eklemek için dokunun.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            const SizedBox(
              height: 10,
            ),
            ZoomIn(
              child: SimpleShadow(
                opacity: 0.1,
                offset: Offset(0.1, 0.1),
                color: Colors.black,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/medsenser_logo.png",
                      width: 100,
                      color: const Color.fromARGB(255, 9, 27, 186),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'A4C35',
                      style: TextStyle(
                          color: Color.fromARGB(255, 9, 27, 186),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  onPressed: () {
                    // "Default" butonu tıklandığında yapılacaklar
                    print('Default butonuna tıklandı');
                  },
                  child: Text('Ekle'),
                ),
                const SizedBox(width: 20), // Butonlar arası boşluk
                TextButton(
                  onPressed: () {
                    // "İptal" butonu tıklandığında yapılacaklar
                    Navigator.pop(context); // Pencereyi kapat
                  },
                  child: Text('İptal'),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
