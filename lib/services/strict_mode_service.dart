import 'package:flutter/services.dart';
import 'package:screen_pinning/screen_pinning.dart';
import 'package:permission_handler/permission_handler.dart';

class StrictModeService {
  static const MethodChannel _channel = MethodChannel('strict_mode');

  static Future<bool> isPinned() async {
    return await ScreenPinning.isPinned();
  }

  static Future<void> enableStrictMode() async {
    try {
      await ScreenPinning.pin();
    } catch (e) {
      print("خطأ في التثبيت: $e");
    }
  }

  static Future<void> disableStrictMode() async {
    try {
      await ScreenPinning.unpin();
    } catch (e) {
      print("خطأ في إلغاء التثبيت: $e");
    }
  }

  static Future<bool> requestOverlayPermission() async {
    return await Permission.overlay.request().isGranted;
  }
}
