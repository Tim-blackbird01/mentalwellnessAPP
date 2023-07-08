import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future<void> scheduleReminderNotification(
    String goalId, String goalText, DateTime goalDateTime) async {
  tz.initializeTimeZones(); // Initialize time zones
  tz.setLocalLocation(tz.getLocation('Africa/Nairobi')); // Set your desired time zone


    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'goal_reminder_channel',
      'Goal Reminder',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the reminder notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      goalId.hashCode,
      'Goal Reminder',
      'Remember to work on your goal: $goalText',
      tz.TZDateTime.from(goalDateTime, tz.local), // Convert goalDateTime to the desired time zone
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void cancelReminderNotification(String s) {}

  static void cancelNotification(id) {}

  static void scheduleNotification(String s, String goalText, DateTime goalDateTime) {}
}
