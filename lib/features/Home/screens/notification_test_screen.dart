import 'package:flutter/material.dart';
import 'package:shortly_provider/core/services/firebase_messaging_service.dart';
import 'package:shortly_provider/core/services/local_notification_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shortly_provider/core/network/network_config.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  final FirebaseMessagingService _messagingService = FirebaseMessagingService();
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String _fcmToken = 'Not available';
  bool _isTokenRegistered = false;
  String _authToken = 'Not available';

  @override
  void initState() {
    super.initState();
    _loadTokenInfo();
  }

  Future<void> _loadTokenInfo() async {
    try {
      // Get FCM token
      final fcmToken = await _messagingService.getToken();

      // Get auth token
      final authToken = await _storage.read(key: 'auth_token');

      setState(() {
        _fcmToken = fcmToken ?? 'Not available';
        _authToken = authToken ?? 'Not available';
        _isTokenRegistered = _messagingService.isTokenRegistered;
      });
    } catch (e) {
      debugPrint('Error loading token info: $e');
    }
  }

  Future<void> _testLocalNotification() async {
    try {
      await _localNotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: 'Test Notification',
        body: 'This is a test notification from the provider app',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Local notification sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _testTokenRegistration() async {
    try {
      final success = await _messagingService.registerTokenWithServer();
      setState(() {
        _isTokenRegistered = success;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(success
                ? 'Token registered successfully!'
                : 'Failed to register token')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _testSelfNotification() async {
    try {
      final authToken = await _storage.read(key: 'auth_token');
      if (authToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No auth token available')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('${NetworkConfig.baseUrl}/admin/notifications/send-to-all'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'title': 'Test Provider Notification',
          'message': 'This is a test notification for providers',
          'type': 'test',
          'recipientModel': 'Provider',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Test notification sent to all providers!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to send notification: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Token Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('FCM Token: ${_fcmToken.substring(0, 20)}...'),
                    const SizedBox(height: 4),
                    Text('Auth Token: ${_authToken.substring(0, 20)}...'),
                    const SizedBox(height: 4),
                    Text('Token Registered: $_isTokenRegistered'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testLocalNotification,
                child: const Text('Test Local Notification'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testTokenRegistration,
                child: const Text('Test Token Registration'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testSelfNotification,
                child: const Text('Send Test Notification to All Providers'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Instructions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              '1. Test local notification to ensure local notifications work\n'
              '2. Test token registration to ensure FCM token is registered\n'
              '3. Send test notification to verify end-to-end functionality',
            ),
          ],
        ),
      ),
    );
  }
}
