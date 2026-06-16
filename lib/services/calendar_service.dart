import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:permission_handler/permission_handler.dart';

class CalendarService {
  static Future<bool> requestPermissions() async {
    return await Permission.calendar.request().isGranted;
  }

  static Future<void> addEvent({
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final event = Event(
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
    );
    Add2Calendar.addEvent2Cal(event);
  }
}
