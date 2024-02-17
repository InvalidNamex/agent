import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationController extends GetxController {
  static LocalizationController instance = Get.find();
  final lang = GetStorage();
  saveLocale(String language) {
    lang.write('locale', language);
  }

  updateLocale() {
    if (lang.read('locale') == 'ar') {
      Get.updateLocale(const Locale('ar', 'EG'));
      print(lang.read('locale'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
      print(lang.read('locale'));
    }
  }

  @override
  void onReady() {
    updateLocale();
    super.onReady();
  }
}
