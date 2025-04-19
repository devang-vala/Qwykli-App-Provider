// ignore_for_file: use_build_context_synchronously, unused_import

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'shared_preference_manager.dart';



class AppManager {
  static Future<void> initialize() async {
    // Initialize Firebase and other services
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SharedPreferencesManager.init();

  }
}
