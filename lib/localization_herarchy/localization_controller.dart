import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController {
  static LocalizationController instance = Get.find();
  Future<void> saveLocale(String language) async {
    if (language == 'ar') {
      final prefs = await SharedPreferences.getInstance();
      const key = 'language';
      const value = 'ar';
      await prefs.setString(key, value);
    } else {
      final prefs = await SharedPreferences.getInstance();
      const key = 'language';
      const value = 'en';
      await prefs.setString(key, value);
    }
  }

  Future<void> readLocale() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'language';
    String? value = prefs.getString(key);
    if (value == 'ar') {
      Get.updateLocale(const Locale('ar', 'EG'));
    } else if (value == 'en') {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.deviceLocale;
    }
  }

  @override
  void onReady() async {
    await readLocale();
    super.onReady();
  }
}
