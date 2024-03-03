import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/controllers/customer_controller.dart';
import 'package:eit/controllers/receipt_controller.dart';
import 'package:eit/controllers/sales_controller.dart';
import 'package:eit/controllers/stock_controller.dart';
import 'package:eit/helpers/connectivity_controller.dart';
import 'package:eit/localization_hierarchy/localization_controller.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(SalesController());
    Get.put(CustomerController());
    Get.put(ReceiptController());
    Get.put(StockController());
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(LocalizationController());
    Get.put(AuthController());
    Get.put(ConnectivityController());
  }
}
