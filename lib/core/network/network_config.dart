import 'dart:io';
import 'package:flutter/foundation.dart';

class NetworkConfig {
  // Toggle this flag to manually force production mode (for debugging/testing)
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  // Production base URL
  static const String prodBaseUrl =
      'https://local-services-backend-qwykli.onrender.com/api';

  // Development base URL (auto-adjusts based on platform)
  static String getDevBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api';
    }

    if (Platform.isIOS || kIsWeb) {
      return 'http://localhost:8080/api';
    }

    return 'http://10.0.2.2:8080/api';
  }

  /// Public base URL selector
  static String get baseUrl => isProduction ? prodBaseUrl : getDevBaseUrl();

  /// For development on physical device with local IP override
  static String getDeviceBaseUrl(String ipAddress) {
    return 'http://$ipAddress:8080/api';
  }

  /// Network error messages
  static String getNetworkErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'Unable to connect to the server. Please check your network settings or make sure the server is running.';
    }

    if (error.toString().contains('Connection refused')) {
      return 'Connection refused. Please check if the server is running and that you\'re using the correct host address.';
    }

    return error.toString();
  }

  /// Troubleshooting helper
  static String getTroubleshootingSteps() {
    String steps = '';

    if (Platform.isAndroid) {
      steps = '''
For Android Emulator:
1. Ensure your server is running on your computer
2. Use 10.0.2.2 instead of localhost
3. Check that port 3000 is open

For Physical Android Device:
1. Connect the device to the same WiFi as your computer
2. Use the local IP address of your computer
3. Ensure the firewall isn’t blocking requests
''';
    } else if (Platform.isIOS) {
      steps = '''
For iOS Simulator:
1. Server should be running on localhost
2. Verify port 3000 is open
3. Use localhost or 127.0.0.1

For Physical iOS Device:
1. Use your computer’s IP
2. Ensure same WiFi network
3. Verify firewall and server
''';
    } else {
      steps = '''
1. Ensure your server is running
2. Verify API URL and port
3. Use IP instead of localhost if needed
''';
    }

    return steps;
  }
}
