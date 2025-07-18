class NotificationService {
  static Future<String> getToken() async {
    try {
      // For now, return a placeholder token
      // In a real app, this would use Firebase Messaging
      return 'fcm_token_placeholder';
    } catch (e) {
      print('Error getting FCM token: $e');
      return 'fcm_token_placeholder';
    }
  }
} 