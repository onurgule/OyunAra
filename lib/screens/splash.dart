import 'dart:async';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routing/router.dart';

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('onboarding') ?? false);
    print(" Onboarding isSeen? " + prefs.getBool("onboarding").toString());

    if (_seen) {
      Timer(Duration(seconds: 4),
          () => Navigator.popAndPushNamed(context, Routes.HOME, arguments: "Onboarding isSeen? : True"));
    } else {
      Timer(Duration(seconds: 4),
          () => Navigator.popAndPushNamed(context, Routes.ONBOARDING,arguments: "Onboarding isSeen? : False"));
    }
  }

  @override
  void initState() {
    super.initState();
  }

// Sayfa daha çizilmeden burası çalışır ve shared preference bakılarak gidilecek sayfa belirlenir (Onboarding-Home)
  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        children: [
          Spacer(
            flex: 1,
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Center(
              child: Lottie.network(
                  'https://assets1.lottiefiles.com/private_files/lf30_Vdv6YA.json'),
            ),
          ),
          Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}
