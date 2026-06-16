import 'package:flutter/material.dart';
import 'dart:async';
import '../services/gamification_service.dart';
import '../services/notification_service.dart';
import '../services/strict_mode_service.dart';

class FocusSessionScreen extends StatefulWidget {
  @override
  _FocusSessionScreenState createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends State<FocusSessionScreen> {
  int _seconds = 25 * 60;
  bool _running = false;
  Timer? _timer;

  void _start() async {
    setState(() => _running = true);
    await StrictModeService.enableStrictMode();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
        setState(() => _running = false);
        _completeSession();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _reset() async {
    _timer?.cancel();
    setState(() {
      _seconds = 25 * 60;
      _running = false;
    });
    await StrictModeService.disableStrictMode();
  }

  Future<void> _completeSession() async {
    int minutes = (25 * 60) ~/ 60;
    await GamificationService.addFocusSession(minutes);
    await NotificationService.showFocusReminder();
    await StrictModeService.disableStrictMode();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('أحسنت! 🎉'),
        content: Text('أكملت جلسة تركيز بنجاح. حصلت على نقاط إضافية.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('رائع'))],
      ),
    );
  }

  String _format(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    StrictModeService.disableStrictMode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('جلسة تركيز')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_format(_seconds), style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold)),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_running) ElevatedButton.icon(onPressed: _start, icon: Icon(Icons.play_arrow), label: Text('ابدأ')),
                if (_running) ElevatedButton.icon(onPressed: _pause, icon: Icon(Icons.pause), label: Text('إيقاف')),
                SizedBox(width: 20),
                OutlinedButton.icon(onPressed: _reset, icon: Icon(Icons.refresh), label: Text('إعادة ضبط')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
