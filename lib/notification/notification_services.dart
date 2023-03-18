import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:remember_app/notification/notified_page.dart';
import 'package:remember_app/timer/timer_counter.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../model/task_data.dart';
import '../timer/timer.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    _configureLocalTimezone();
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("t");

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(Text("Welcome to flutter"));
  }

  Future selectNotification(String? payload) async {
    TimerController _timer = Get.put(TimerController());
    _timer.ww = 900;
    Get.to(() => timer());
  }

  displayNotification({required String title, required String body}) async {
    print("doing test");
    // ignore: prefer_const_constructors
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_sound',
    );
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    DateTime date = DateFormat.jm().parse(task.startTime.toString());
    var myTime = DateFormat("HH:mm").format(date);
    int seconds = Duration(hours: int.parse(myTime.toString().split(":")[0])).inSeconds + Duration(minutes: int.parse(myTime.toString().split(":")[1])).inSeconds;
    DateTime date1 = DateFormat.jm().parse(task.endTime.toString());
    var myTime1 = DateFormat("HH:mm").format(date1);
    int seconds1 = Duration(hours: int.parse(myTime1.toString().split(":")[0])).inSeconds + Duration(minutes: int.parse(myTime1.toString().split(":")[1])).inSeconds;
    int seconds3 = seconds1 - seconds ;
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
       _convertTime(hour, minutes),
      // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
      const NotificationDetails(
          android: AndroidNotificationDetails(
              'your channel id', 'your channel name')),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
       matchDateTimeComponents: DateTimeComponents.time,
       payload: "${seconds3}|"
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timezone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezone));
  }
}
