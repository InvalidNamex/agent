import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/toast.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxBool isPayTypeCash = false.obs;

  List<Map<String, String>> homeElements = [
    {'Sales': 'assets/images/colored_sells_card.png'},
    {'Customers': 'assets/images/colored_customers_card.png'},
    {'Stock': 'assets/images/colored_store_card.png'},
    {'Receipt Vouchers': 'assets/images/colored_payment_card.png'},
    {'Reports': 'assets/images/colored_reports_card.png'},
    {'Visits Plans': 'assets/images/colored_visits_card.png'},
  ];

  void navigateToTab(int index) {
    tabController.animateTo(index);
  }

  Future<void> setPayTypePref({required bool isCash}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isCash', isCash);
    } catch (e) {
      AppToasts.errorToast(e.toString());
    }
  }

  Future<bool> readPayTypePref() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool isCash = prefs.getBool('isCash') ?? false;
      return isCash;
    } catch (e) {
      AppToasts.errorToast('Unknown Server'.tr);
      return false;
    }
  }

  @override
  void onReady() async {
    isPayTypeCash(await readPayTypePref());
    super.onReady();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }
}
