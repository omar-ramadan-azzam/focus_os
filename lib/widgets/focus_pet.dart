import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FocusPetWidget extends StatefulWidget {
  @override
  _FocusPetWidgetState createState() => _FocusPetWidgetState();
}

class _FocusPetWidgetState extends State<FocusPetWidget> {
  int xp = 0;
  String petEmoji = '🐣';

  @override
  void initState() {
    super.initState();
    _loadXP();
  }

  Future<void> _loadXP() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      xp = prefs.getInt('xp') ?? 0;
      if (xp < 500) petEmoji = '🐣';
      else if (xp < 2000) petEmoji = '🐥';
      else petEmoji = '🦅';
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
            Text('الحيوان الأليف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(petEmoji, style: TextStyle(fontSize: 64)),
            Text('XP: $xp', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
