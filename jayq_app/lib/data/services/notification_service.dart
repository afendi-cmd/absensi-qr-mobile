import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final StorageService _storageService = StorageService();
  String? _fcmToken;

  // Initialize notification service
  Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
    } else {
      debugPrint('User declined or has not accepted notification permission');
    }

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Get FCM token
    _fcmToken = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $_fcmToken');

    // Save token to backend
    if (_fcmToken != null) {
      await _saveFcmTokenToBackend(_fcmToken!);
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      _saveFcmTokenToBackend(newToken);
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
  }

  // Save FCM token to backend
  Future<void> _saveFcmTokenToBackend(String token) async {
    try {
      final authToken = await _storageService.getToken();
      if (authToken == null) return;

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $authToken';
      dio.options.headers['Accept'] = 'application/json';

      await dio.post(
        '${AppConstants.baseUrl}/user/fcm-token',
        data: {'fcm_token': token},
      );

      debugPrint('FCM token saved to backend');
    } catch (e) {
      debugPrint('Error saving FCM token: $e');
    }
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground message received: ${message.notification?.title}');

    if (message.notification != null) {
      _showLocalNotification(
        title: message.notification!.title ?? 'Pengumuman',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  // Handle background messages
  void _handleBackgroundMessage(RemoteMessage message) {
    debugPrint('Background message opened: ${message.notification?.title}');
    // Navigate to specific screen based on message data
  }

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'pengumuman_channel',
          'Pengumuman',
          channelDescription: 'Channel untuk pengumuman kampus',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Show notification immediately (for testing without FCM)
  Future<void> showTestNotification({
    required String title,
    required String body,
  }) async {
    await _showLocalNotification(title: title, body: body, payload: 'test');
  }

  // Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Navigate to specific screen based on payload
  }

  // Get FCM token
  String? get fcmToken => _fcmToken;

  // Send notification to specific users (backend will handle this)
  Future<void> sendNotificationToUsers({
    required String title,
    required String body,
    required String target, // 'all', 'dosen', 'mahasiswa'
  }) async {
    try {
      final authToken = await _storageService.getToken();
      if (authToken == null) {
        throw Exception('Not authenticated');
      }

      final String url = '${AppConstants.baseUrl}/notifications/send';
      debugPrint('🔔 Sending notification to: $url');
      debugPrint('🔔 Target: $target');
      debugPrint('🔔 Title: $title');

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $authToken';
      dio.options.headers['Accept'] = 'application/json';

      final response = await dio.post(
        url,
        data: {'title': title, 'body': body, 'target': target},
      );

      debugPrint('✅ Notification sent successfully: ${response.data}');
    } catch (e) {
      debugPrint('❌ Error sending notification: $e');
      if (e is DioException) {
        debugPrint('❌ Request URL: ${e.requestOptions.uri}');
        debugPrint('❌ Status Code: ${e.response?.statusCode}');
        debugPrint('❌ Response: ${e.response?.data}');
      }
      rethrow;
    }
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.notification?.title}');
}
