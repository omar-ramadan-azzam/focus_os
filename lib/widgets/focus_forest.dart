import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FocusForestWidget extends StatefulWidget {
  @override
  _FocusForestWidgetState createState() => _FocusForestWidgetState();
}

class _FocusForestWidgetState extends State<FocusForestWidget> {
  int totalSessions = 0;
  String treeEmoji = '🌱';

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      totalSessions = prefs.getInt('total_sessions') ?? 0;
      if (totalSessions < 5) treeEmoji = '🌱';
      else if (totalSessions < 20) treeEmoji = '🌿';
      else if (totalSessions < 50) treeEmoji = '🌲';
      else treeEmoji = '🌳';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('غابة التركيز', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(treeEmoji, style: TextStyle(fontSize: 64)),
            Text('عدد الجلسات: $totalSessions'),
          ],
        ),
      ),
    );
  }
}
