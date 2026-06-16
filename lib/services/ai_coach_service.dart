import 'package:shared_preferences/shared_preferences.dart';

class AICoachService {
  static Future<String> getSuggestion() async {
    final prefs = await SharedPreferences.getInstance();
    int totalMinutes = prefs.getInt('total_focus_minutes') ?? 0;
    int streak = prefs.getInt('streak') ?? 0;
    if (totalMinutes < 60) {
      return 'أنت في البداية! حاول أن تبدأ بجلسة تركيز مدتها 25 دقيقة.';
    } else if (streak >= 7) {
      return 'رائع! استمراريتك رائعة. زد المدة إلى 30 دقيقة.';
    } else {
      return 'حاول أن تحافظ على التزام يومي لمدة أسبوع.';
    }
  }
}
