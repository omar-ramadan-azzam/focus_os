import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await Permission.notification.request();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notifications.initialize(settings);
  }

  static Future<void> showFocusReminder() async {
    const android = AndroidNotificationDetails(
      'focus_channel',
      'تذكير التركيز',
      importance: Importance.high,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);
    await _notifications.show(0, 'حان وقت التركيز', 'ابدأ جلسة تركيز الآن', details);
  }

  static Future<void> scheduleDailyReminder(Time time) async {
    await _notifications.periodicallyShow(
      1,
      'جلسة تركيز يومية',
      'حان وقت جلسة التركيز اليومية',
      RepeatInterval.daily,
      const NotificationDetails(
        android: AndroidNotificationDetails('focus_channel', 'تذكير التركيز'),
      ),
      androidAllowWhileIdle: true,
    );
  }
}
