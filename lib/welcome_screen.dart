import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:internshala/screens/all_intership.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/sliding.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnIsOpen();
  }

  Future<void> _navigateBasedOnIsOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOpen = prefs.getBool('isOpen') ?? false;
    await Future.delayed(const Duration(seconds: 3));


    if (isOpen) {
      Get.off(() => const AllInternships());
    } else {
      Get.off(() => const Sliding1());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Lottie.asset(
          "assets/images/farm2.json",  
          fit: BoxFit.contain,
          height: 350,
          width: 350,
        

        )
      ),
    );
  }
}
