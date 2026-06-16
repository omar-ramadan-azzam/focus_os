import 'package:shared_preferences/shared_preferences.dart';

class GamificationService {
  static const String _xpKey = 'xp';
  static const String _levelKey = 'level';
  static const String _streakKey = 'streak';
  static const String _totalSessionsKey = 'total_sessions';
  static const String _totalMinutesKey = 'total_focus_minutes';

  static Future<int> getXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_xpKey) ?? 0;
  }

  static Future<int> getLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_levelKey) ?? 1;
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<int> getTotalSessions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalSessionsKey) ?? 0;
  }

  static Future<void> addFocusSession(int minutesFocused) async {
    final prefs = await SharedPreferences.getInstance();
    // XP
    int currentXP = await getXP();
    int gained = minutesFocused * 10;
    int newXP = currentXP + gained;
    await prefs.setInt(_xpKey, newXP);
    // Level
    int newLevel = (newXP / 1000).floor() + 1;
    await prefs.setInt(_levelKey, newLevel);
    // Total sessions
    int sessions = await getTotalSessions();
    await prefs.setInt(_totalSessionsKey, sessions + 1);
    // Total minutes
    int totalMins = prefs.getInt(_totalMinutesKey) ?? 0;
    await prefs.setInt(_totalMinutesKey, totalMins + minutesFocused);
    // Streak
    await _updateStreak(prefs);
  }

  static Future<void> _updateStreak(SharedPreferences prefs) async {
    String lastDate = prefs.getString('last_focus_date') ?? '';
    String today = DateTime.now().toIso8601String().substring(0, 10);
    if (lastDate == today) return;
    int streak = await getStreak();
    if (lastDate == _yesterdayString()) {
      streak++;
    } else {
      streak = 1;
    }
    await prefs.setInt(_streakKey, streak);
    await prefs.setString('last_focus_date', today);
  }

  static String _yesterdayString() {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    return yesterday.toIso8601String().substring(0, 10);
  }
}
