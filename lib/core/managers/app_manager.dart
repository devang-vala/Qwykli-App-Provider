// ignore_for_file: use_build_context_synchronously, unused_import

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shortly_provider/features/location.dart';
import 'package:shortly_provider/main.dart';
import 'shared_preference_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


class AppManager {
  static Future<void> initialize() async {
    LocationHandler location = new LocationHandler();
    // Initialize Firebase and other services
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SharedPreferencesManager.init();
    await location.getCurrentLocation();
  } 
}
