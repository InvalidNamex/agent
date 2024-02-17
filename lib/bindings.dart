import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/controllers/customer_controller.dart';
import 'package:eit/controllers/sales_controller.dart';
import 'package:eit/localization_herarchy/localization_controller.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LocalizationController());
    Get.put(HomeController());
    Get.put(SalesController());
    Get.put(CustomerController());
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
