import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final onNotifications = BehaviorSubject<String?>();

  NotificationService._internal();

  Future<void> initNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: ((payload) async {
      onNotifications.add(payload);
    }));
  }

  AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    'main_channel',
    'Main Channel',
    importance: Importance.max,
    priority: Priority.max,
    icon: '@mipmap/ic_launcher',
  );

  IOSNotificationDetails iosNotificationDetails = const IOSNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentBadge: true,
      presentSound: true);

  Future<void> showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        NotificationDetails(
            android: androidNotificationDetails,
            iOS: iosNotificationDetails),
        payload: payload,
      );
}
