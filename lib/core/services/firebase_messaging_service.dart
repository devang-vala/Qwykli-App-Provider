import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shortly_provider/core/network/network_config.dart';
import 'package:shortly_provider/core/services/local_notification_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();
  final _storage = const FlutterSecureStorage();

  final StreamController<String> _tokenStreamController =
      StreamController<String>.broadcast();
  Stream<String> get tokenStream => _tokenStreamController.stream;

  static String get baseUrl => NetworkConfig.baseUrl;
  String get _registerTokenUrl => '$baseUrl/provider/device-tokens/register';
  bool _isInitialized = false;
  bool _isTokenRegistered = false;

  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  bool get isInitialized => _isInitialized;
  bool get isTokenRegistered => _isTokenRegistered;

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    debugPrint('🔔 Initializing Firebase Messaging Service');
    if (!_localNotificationService.isInitialized) {
      await _localNotificationService.initialize();
    }
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    String? token = await _messaging.getToken();
    debugPrint('🔔 FCM Token received: $token');
    if (token != null) {
      _tokenStreamController.add(token);
      await registerTokenWithServer(token);
    }
    _messaging.onTokenRefresh.listen((newToken) {
      debugPrint('🔄 FCM Token refreshed: $newToken');
      _tokenStreamController.add(newToken);
      registerTokenWithServer(newToken);
    });
    _isInitialized = true;
    debugPrint('✅ Firebase Messaging Service Initialized');
  }

  Future<bool> registerTokenWithServer([String? providedToken]) async {
    int retries = 0;
    String? token = providedToken;
    while (token == null && retries < 3) {
      await Future.delayed(const Duration(seconds: 1));
      token = await _messaging.getToken();
      retries++;
      debugPrint('🔄 Retrying to get FCM token (attempt $retries): $token');
    }
    final authToken = await _storage.read(key: 'auth_token');
    debugPrint(
        '🔗 Attempting FCM registration: authToken=$authToken, fcmToken=$token');
    try {
      if (token == null) {
        debugPrint('❌ No FCM token available to register');
        return false;
      }
      if (authToken == null) {
        debugPrint('❌ No auth token available for FCM registration');
        return false;
      }
      String platform;
      if (defaultTargetPlatform == TargetPlatform.android) {
        platform = 'android';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        platform = 'ios';
      } else {
        platform = 'web';
      }
      debugPrint(
          '🔗 Registering FCM token with backend: token=$token, platform=$platform, url=${NetworkConfig.baseUrl}/provider/device-tokens/register');
      final response = await http.post(
        Uri.parse('${NetworkConfig.baseUrl}/provider/device-tokens/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(
            {'token': token, 'platform': platform, 'userType': 'provider'}),
      );
      debugPrint(
          '🔗 FCM token registration response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        _isTokenRegistered = true;
        debugPrint('✅ FCM token registered with backend');
        return true;
      }
      debugPrint('❌ Failed to register FCM token with backend');
      return false;
    } catch (e) {
      debugPrint('❌ Exception registering FCM token: $e');
      return false;
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📩 Foreground FCM message received: ${message.data}');
    debugPrint(
        '📩 Foreground FCM notification: ${message.notification?.title} - ${message.notification?.body}');

    // Handle both notification and data-only messages
    String title = '';
    String body = '';

    if (message.notification != null) {
      title = message.notification!.title ?? 'New Notification';
      body = message.notification!.body ?? '';
    } else if (message.data.isNotEmpty) {
      title = message.data['title'] ?? 'New Notification';
      body = message.data['message'] ?? message.data['body'] ?? '';
    }

    debugPrint('🔔 Showing local notification: $title - $body');
    if (title.isNotEmpty) {
      _localNotificationService.showNotification(
        id: message.hashCode,
        title: title,
        body: body,
        payload: message.data.isNotEmpty ? json.encode(message.data) : null,
      );
    }
  }

  Future<bool> verifyTokenRegistration() async {
    if (_isTokenRegistered) return true;
    final authToken = await _storage.read(key: 'auth_token');
    if (authToken == null) return false;
    return registerTokenWithServer();
  }

  void dispose() {
    _tokenStreamController.close();
    _isInitialized = false;
  }
}
