import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../helpers/toast.dart';
import '../models/customer_model.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class VisitsController extends GetxController {
  RxList<CustomerModel> customersListByRoute = RxList<CustomerModel>();
  RxBool isLoading = false.obs;
  final authController = Get.find<AuthController>();

  Future<void> fetchCustomersByRoute(
      {String pageNo = '-1', String pageSize = '1'}) async {
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    final url = Uri.parse(
        //https://Mobiletest.itgenesis.app/GetCustList?ServiceKey=1357&SalesRepID=1&P=&PageNo=-1&PageSize=0
        'https://$apiURL/GetCustList?ServiceKey=$secretKey&SalesRepID=${user!.saleRepID}&PageNo=$pageNo&PageSize=$pageSize');
    try {
      isLoading(true);
      customersListByRoute.clear();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          final List _x = json.decode(data['data']);
          for (final x in _x) {
            if (!customersListByRoute.contains(x)) {
              customersListByRoute.add(CustomerModel.fromJson(x));
            }
          }
        } else {
          AppToasts.errorToast('Server Response Error'.tr);
        }
      } else {
        AppToasts.errorToast(response.statusCode.toString());
      }
      isLoading(false);
    } catch (e) {
      AppToasts.errorToast(e.toString());
    }
  }

  @override
  void onInit() async {
    fetchCustomersByRoute();
    super.onInit();
  }
}
