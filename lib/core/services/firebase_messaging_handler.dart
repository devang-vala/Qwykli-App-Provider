import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint('📩 Background FCM message received: ${message.data}');
  debugPrint(
      '📩 Background FCM notification: ${message.notification?.title} - ${message.notification?.body}');

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

  // Only show local notification if we have content
  if (title.isNotEmpty || body.isNotEmpty) {
    debugPrint('🔔 Showing local notification (background): $title - $body');

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'provider_notifications', // Updated channel ID for provider app
      'Provider Notifications', // Updated channel name
      description: 'This channel is used for provider app notifications',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
      enableLights: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Configure notification details
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'provider_notifications',
      'Provider Notifications',
      channelDescription: 'This channel is used for provider app notifications',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      enableLights: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.active,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      body,
      platformDetails,
      payload: message.data.isNotEmpty ? json.encode(message.data) : null,
    );
  }
}
