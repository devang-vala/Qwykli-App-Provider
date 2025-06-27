import 'package:flutter/material.dart';
import 'package:shortly_provider/core/constants/app_icons.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'dart:async';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/core/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Keep the splash screen visible for at least 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is already authenticated
    final isAuthenticated = await AuthService.isAuthenticated();

    if (mounted) {
      if (isAuthenticated) {
        // Navigate to home if authenticated
        CustomNavigator.pushReplace(context, AppPages.navbar);
      } else {
        // Navigate to login if not authenticated
        CustomNavigator.pushReplace(context, AppPages.login);
      }
    }
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
            CustomSpacers.height30,
            // Add a loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}