import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shortly_provider/core/constants/app_icons.dart';
import 'package:shortly_provider/core/utils/screen_utils.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'package:shortly_provider/route/custom_navigator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    Timer(const Duration(seconds: 2), () async {
      CustomNavigator.pushReplace(context, AppPages.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppIcons.app_logo,
          width: 160.w,
          height: 160.h,
        ),
      ),
    );
  }
}
