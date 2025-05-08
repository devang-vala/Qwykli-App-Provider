import 'package:flutter/material.dart';
import 'package:shortly_provider/core/constants/app_icons.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'dart:async';

import 'package:shortly_provider/route/custom_navigator.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      CustomNavigator.pushReplace(context, AppPages.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Image.asset(
                AppIcons.app_logo, 
              height: 100,
            ),
            CustomSpacers.height20,
            // App Name
            const Text(
              'Shortly',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
