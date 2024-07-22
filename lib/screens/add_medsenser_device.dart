import 'dart:typed_data';

import 'package:flutter/material.dart';

class AddMedSenserDeviceScreen extends StatefulWidget {
  const AddMedSenserDeviceScreen({Key? key}) : super(key: key);

  @override
  State<AddMedSenserDeviceScreen> createState() =>
      _AddMedSenserDeviceScreenState();
}

class _AddMedSenserDeviceScreenState extends State<AddMedSenserDeviceScreen> {
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12.0), // Kenar yuvarlatma
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Text(
                        "QR Code Tarayın",
                        style: TextStyle(
                          fontSize: 18.0, // Metin boyutunu ayarlayabilirsiniz
                          fontWeight: FontWeight.bold, // Metni kalın yapar
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text("Ürün üzerindeki QR Kodunu taratın."),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12.0), // Kenar yuvarlatma
                ),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Container(),
                ),
              ),
              Text("veya"),
              Text("Ürün üzerindeki kodu kutuya yazın."),
              SizedBox(
                width: 200,
                child: TextFormField(
                  keyboardType: TextInputType.number, // Sadece rakam klavyesi
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white, // Beyaz arka plan
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // Çerçeve rengi
                        width: 2.0, // Çerçeve kalınlığı
                      ),
                    ),
                    hintText: 'Ürün Numarası', // İpucu metni
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Butona basıldığında yapılacak işlemler
                  Navigator.of(context).pop();
                },
                child: Text('İptal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
