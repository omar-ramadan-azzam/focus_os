import 'package:flutter/material.dart';
import '../services/gamification_service.dart';
import '../services/ai_coach_service.dart';
import '../widgets/focus_forest.dart';
import '../widgets/focus_pet.dart';
import 'focus_session_screen.dart';
import 'add_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int xp = 0, level = 1, streak = 0;
  String coachSuggestion = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    xp = await GamificationService.getXP();
    level = await GamificationService.getLevel();
    streak = await GamificationService.getStreak();
    coachSuggestion = await AICoachService.getSuggestion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة التحكم'),
        actions: [IconButton(icon: Icon(Icons.refresh), onPressed: _loadData)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('المستوى $level', style: TextStyle(fontSize: 18)),
                Text('النقاط: $xp', style: TextStyle(fontSize: 18)),
                Text('التتابع: $streak أيام', style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 20),
            FocusForestWidget(),
            SizedBox(height: 20),
            FocusPetWidget(),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: Icon(Icons.psychology),
                title: Text('مدرب AI'),
                subtitle: Text(coachSuggestion),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FocusSessionScreen())),
              icon: Icon(Icons.timer),
              label: Text('ابدأ جلسة تركيز'),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen())),
              icon: Icon(Icons.calendar_today),
              label: Text('إضافة مهمة إلى التقويم'),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
