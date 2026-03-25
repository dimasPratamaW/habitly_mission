import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habitly_mission/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Background message: ${message.messageId}');
}

typedef NotificationTapCallback = void Function(Map<String, dynamic> data);

class NotificationHandlerFcm {
  NotificationHandlerFcm._();

  static final NotificationHandlerFcm instance = NotificationHandlerFcm._();

  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
        'high_important_channel', // ✅ Fix: no spaces in channel ID
        'High Importance FCM',
        description: "This one is using FCM",
        importance: Importance.high,
      );

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  NotificationTapCallback? _tapCallback;

  Future<void> init({NotificationTapCallback? onTap}) async {
    _tapCallback = onTap;

    await _requestPermission(); // ✅ Fix 5: await added
    await _setupLocalNotifications(); // ✅ Fix 1: now called
    _handleMessages(); // ✅ Fix 1: now called

    final token = await _messaging.getToken();
    print('FCM Token: $token');
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission: ${settings.authorizationStatus}');
  }

  Future<void> _setupLocalNotifications() async {
    print('Setting up local notifications...'); // ← add

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_defaultChannel);

    print('Channel created'); // ← add

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    final result = await _localNotifications.initialize(
      // ← capture result
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        print('Notification tapped: ${details.payload}');
      },
    );

    print('Local notifications initialized: $result'); // ← add
  }

  void _handleMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground message: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Opened from background: ${message.data}');
      _tapCallback?.call(message.data); // ✅ Fix 4: invoke callback
    });

    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        print('Opened from terminated: ${message.data}');
        _tapCallback?.call(message.data); // ✅ Fix 4: invoke callback
      }
    });
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    // ✅ Fix 3: positional args, not named id:/title:/body:/notificationDetails:
    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _defaultChannel.id,
          _defaultChannel.name,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.toString(),
    );
  }
}
