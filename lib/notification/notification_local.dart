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
    final TimezoneInfo currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));


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
    final dateParts = habit.date.split('/');
    final timeParts = habit.time.split(':');

    final int day = int.parse(dateParts[0]);
    final int month = int.parse(dateParts[1]);
    final int year = int.parse(dateParts[2]);
    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    final scheduledDate = tz.TZDateTime(
      tz.local,
      year,
      month,
      day,
      hour,
      minute,
    );



    await notificationsPlugin.zonedSchedule(
        id: habit.id.hashCode,
        title: habit.title,
        body: habit.desc,
        notificationDetails: _notificationDetails(),
        scheduledDate: scheduledDate.add(const Duration(seconds: 5)),
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