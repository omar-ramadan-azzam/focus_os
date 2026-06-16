import 'package:flutter/services.dart';
import 'package:screen_pinning/screen_pinning.dart';
import 'package:permission_handler/permission_handler.dart';

class StrictModeService {
  static Future<bool> isPinned() async {
    try {
      return await ScreenPinning.isPinned();
    } catch (e) {
      print("خطأ في التحقق من التثبيت: $e");
      return false;
    }
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
}
