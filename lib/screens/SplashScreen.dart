import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hi/utils/ColorsCustom.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white54,
        child: Center(
          child: Lottie.asset('assets/chat.json')
        ),
      ),
    );
  }

  Future<void> whereToGo() async {
    var pref = await SharedPreferences.getInstance();
    var isLogIn = pref.getBool('isLogIn');
    var user = pref.getBool('user');

    Timer(const Duration(seconds: 5), () {
      if (isLogIn == true) {
        if (user == true) {
          Navigator.pushReplacementNamed(context, '/Home');
        } else {
          Navigator.pushReplacementNamed(context, '/UserInformation');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/MobileNo');
      }
    });
  }
}
