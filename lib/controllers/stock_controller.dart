import 'dart:convert';

import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/helpers/toast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../models/api/api_stock_item_model.dart';
import 'package:http/http.dart' as http;

class StockController extends GetxController {
  //!GetItemsStock?ServiceKey=1357&StoreID=1&ItemID=16
  RxList<StockItemModel> stockItemList = RxList<StockItemModel>();
  RxList<StockItemModel> filteredStockItemList = RxList<StockItemModel>();

  Rx<StockItemModel> stockItemDropDown =
      StockItemModel(itemName: 'Choose Item'.tr).obs;
  final authController = Get.find<AuthController>();
  Future<void> getItemsStock({int? itemid}) async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;

    final url = itemid == null
        ? Uri.parse(
            'https://$apiURL/GetItemsStock?ServiceKey=$secretKey&StoreID=${authController.userModel!.storeID}')
        : Uri.parse(
            'https://$apiURL/GetItemsStock?ServiceKey=$secretKey&StoreID=${authController.userModel!.storeID}&itemid=$itemid');
    try {
      stockItemList.clear();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          final List _x = json.decode(data['data']);
          for (final i in _x) {
            if (!stockItemList.contains(i)) {
              stockItemList.add(StockItemModel.fromJson(i));
            }
          }
        } else {
          AppToasts.errorToast('No Stock Items Found'.tr);
        }
      } else {
        AppToasts.errorToast('Connection Error'.tr);
      }
    } catch (e) {
      AppToasts.errorToast('Error occurred, please contact support'.tr);
      var logger = Logger();
      logger.d(e.toString());
    }
  }

  @override
  void onInit() async {
    await getItemsStock();
    super.onInit();
  }
}
