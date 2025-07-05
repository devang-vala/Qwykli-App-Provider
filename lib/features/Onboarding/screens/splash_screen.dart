import 'package:flutter/material.dart';
import 'package:shortly_provider/core/constants/app_icons.dart';
import 'package:shortly_provider/core/utils/custom_spacers.dart';
import 'package:shortly_provider/route/app_pages.dart';
import 'dart:async';
import 'package:shortly_provider/route/custom_navigator.dart';
import 'package:shortly_provider/core/services/auth_service.dart';
import 'package:shortly_provider/core/services/firebase_messaging_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _navigateAfterSplash();
  }

  Future<void> _initializeNotifications() async {
    try {
      debugPrint('🔔 Starting notification initialization...');
      final messagingService = FirebaseMessagingService();

      debugPrint('🔔 Initializing Firebase Messaging Service...');
      await messagingService.initialize();

      debugPrint('🔔 Registering token with server...');
      final success = await messagingService.registerTokenWithServer();

      if (success) {
        debugPrint('✅ Notification initialization completed successfully');
      } else {
        debugPrint('❌ Failed to register token with server');
      }
    } catch (e) {
      debugPrint('❌ Error during notification initialization: $e');
    }
  }

  void _navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    final isValid = await AuthService.isTokenValid();
    if (mounted) {
      if (isValid) {
        CustomNavigator.pushReplace(context, AppPages.navbar);
      } else {
        await AuthService.logout();
        CustomNavigator.pushReplace(context, AppPages.phone_input);
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
