import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBlockerService {
  static Future<bool> requestUsageStatsPermission() async {
    return await Permission.usageStats.request().isGranted;
  }

  static Future<void> saveBlockedApps(List<String> packages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blocked_apps', packages);
  }

  static Future<List<String>> loadBlockedApps() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('blocked_apps') ?? [];
  }
}
