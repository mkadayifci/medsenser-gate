import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medsenser_gate/components/founded_device_bottom_sheet.dart';

class MedsenserAppBar extends AppBar {
  final BuildContext context;
  MedsenserAppBar({Key? key, required Widget title, required this.context})
      : super(
          key: key,
          title: title,
          elevation: 2,
          shadowColor: Colors.grey.shade500,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color.fromARGB(255, 9, 27, 186),
                    Color(0xFF2F80ED)
                  ]),
            ),
          ),

          centerTitle: true,
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.blue.shade500,
          //     Colors.blue.shade800,
          //     Colors.blue.shade500,
          //   ],
          // ),
        );
}
