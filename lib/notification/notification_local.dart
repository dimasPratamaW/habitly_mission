import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:habitly_mission/domain/entities/habit_entity.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

import '../presentation/state/habit_providers.dart';

class NotificationLocal {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  //INITIALIZE
  Future<void> initNotification() async {
    if (_isInitialized) return;


    // initiating time for reminder notification
    tzData.initializeTimeZones();
    final String currentTimeZone = FlutterTimezone.getLocalTimezone().toString();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));


    //1. First initialize Icon for notifications
    const initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    //initial settings
    const initSettings = InitializationSettings(android: initSettingsAndroid);
    await notificationsPlugin.initialize(settings: initSettings);

    // Request permission
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _isInitialized = true;
  }

  // Notifications Details Setup
  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: "daily notifications channel",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  // core method  - takes data
  Future<void> scheduleHabitNotification (HabitEntity habit) async{
    await notificationsPlugin.zonedSchedule(
        id: habit.id.hashCode,
        title: habit.title,
        body: habit.desc,
        notificationDetails: _notificationDetails(),
        scheduledDate: tz.TZDateTime.now(
          tz.local,
        ).add(const Duration(seconds: 5)),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle);
  }


  // Show Notifications
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(),
    );
  }
}