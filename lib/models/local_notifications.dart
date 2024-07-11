import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(
    NotificationResponse notificationResponse,
  ) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future init() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            macOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      if (inputData != null &&
          inputData.containsKey('lectureTime') &&
          inputData.containsKey('lectureTitle')) {
        final lectureTime = DateTime.parse(inputData['lectureTime']);
        final lectureTitle = inputData['lectureTitle'];
        final tz.TZDateTime scheduledDateTimeInLocal =
            tz.TZDateTime.from(lectureTime, tz.local)
                .subtract(Duration(minutes: 5));

        await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Upcoming Lecture',
          'Your lecture $lectureTitle is starting in 5 minutes.',
          scheduledDateTimeInLocal,
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'channel 3', 'class clockwise notifications',
                  channelDescription: 'your channel description',
                  importance: Importance.max,
                  priority: Priority.high,
                  ticker: 'ticker')),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          // payload: payload
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
      return Future.value(true);
    });
  }

  // static Future showScheduleNotification({
  //   // required String title,
  //   // required String body,
  //   // required String payload,
  // }) async {
  //   // tz.initializeTimeZones();

  // }
  //  return Future.value(true);
}
// LocalNotifications.showScheduleNotification(
//                       title: "Schedule Notification",
//                       body: "This is a Schedule Notification",
//                       payload: "This is schedule data");