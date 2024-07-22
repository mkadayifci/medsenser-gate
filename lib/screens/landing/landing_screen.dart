import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medsenser_gate/screens/add_medsenser_device.dart';

import 'package:medsenser_gate/services/state_manager_service.dart';
import 'package:simple_shadow/simple_shadow.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen();
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Column(
          children: [
            SimpleShadow(
              opacity: 0.5,
              color: Colors.grey,
              offset: const Offset(0.3, 0.3),
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/medsenser_logo.png', // Logonuzun yolu
                      color: Colors.white,
                      height: 60, // Logo boyutu, ihtiyacınıza göre ayarlayın
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Medsenser",
                      style: (TextStyle(
                          color: Colors.white,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w500,
                          fontSize: 36,
                          letterSpacing: 1.0)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: const <Widget>[
                  LandingStep(
                    title: "Önemli!",
                    content: "Medsenser ateş ölçerinizi yanınıza alın.",
                    backgroundColor: Colors.blue,
                  ),
                  LandingStep(
                    title: "Ateş Ölçer Ekleme",
                    content:
                        "Ateş ölçerinizin açma/kapama tuşu yoktur. Sadece uygulamaya eklemek için yanınızda bulunmalı.",
                    backgroundColor: Colors.blue,
                  ),
                  LandingStep(
                    title: "Kullanıcı Kaydı",
                    content:
                        "Kullanıcı kayıdı yapmadan da uygulamayı kullanabilirsiniz. Bütün özelliklerden yararlanabilmek, başka bir telefondan erişmek veya verileri kaybetmemek için kayıt olabilirsiniz.",
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
            ),
            FadeIn(
              child: Visibility(
                child: ElevatedButton(
                    onPressed: () => _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                    child: Text("Devam")),
                visible: _currentPage < 2,
                replacement: ElevatedButton(
                  onPressed: () =>
                      StateManagerService.state.changeNeedsToShowLanding(false),
                  child: Text("Uygulamayı Aç"),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class LandingStep extends StatelessWidget {
  final String title;
  final String content;
  final Color backgroundColor;
  final VoidCallback? buttonAction;

  const LandingStep({
    Key? key,
    required this.title,
    required this.content,
    required this.backgroundColor,
    this.buttonAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 150), // Boşluk bırakır (100 birim yükseklikte

          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22, color: Colors.white, height: 1.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
