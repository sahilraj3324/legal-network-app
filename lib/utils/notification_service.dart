import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<String> getToken() async {
    try {
      String? token = await messaging.getToken();
      return token ?? '';
    } catch (e) {
      log('Error getting FCM token: $e');
      return '';
    }
  }

  static Future<void> sendChatNotification({
    required String token,
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final String serverKey = 'YOUR_SERVER_KEY'; // Add your Firebase server key here
      
      final Map<String, dynamic> notification = {
        'to': token,
        'notification': {
          'title': title,
          'body': body,
          'sound': 'default',
        },
        'data': payload,
        'priority': 'high',
      };

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(notification),
      );

      if (response.statusCode == 200) {
        log('Notification sent successfully');
      } else {
        log('Failed to send notification: ${response.statusCode}');
      }
    } catch (e) {
      log('Error sending notification: $e');
    }
  }
} 