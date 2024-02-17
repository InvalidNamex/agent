import 'dart:convert';

import 'package:eit/models/customer_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../helpers/toast.dart';
import '../models/api/api_customer_model.dart';
import '../models/user_model.dart';
import 'auth_controller.dart';

class CustomerController extends GetxController {
  RxList<CustomerModel> customersList = RxList<CustomerModel>();
  RxBool isLoading = false.obs;
  final authController = Get.find<AuthController>();

  Future<void> fetchCustomers(
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
      customersList.clear();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          final List _x = json.decode(data['data']);
          for (final x in _x) {
            if (!customersList.contains(x)) {
              customersList.add(CustomerModel.fromJson(x));
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

  Future<void> saveCustomer(ApiCustomerModel customerModel) async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    final queryString = Uri.encodeComponent(jsonEncode(customerModel.toJson()));
    //https://Mobiletest.itgenesis.app/AddCustomer?ServiceKey=1357&CustInfo={"CustName":"Test Customer","CustCode":"XY1000","Address":"Test Address","Latitude":"24.655305","Longitude":"46.707436","PhoneNo":"009663582451","TaxNo":"1245215421","SalesRepID":1}
    final url = Uri.parse(
        'https://$apiURL/AddCustomer?ServiceKey=$secretKey&CustInfo=$queryString');
    try {
      isLoading(true);
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          final String dataString = '{${data['data']}}';
          final decodedData = json.decode(dataString);
          int custID = decodedData['CustID'];
          await fetchCustomers();
          Get.back();
          AppToasts.successToast(
              '${'Saved Successfully'.tr}\n ${'Customer Code: '.tr}${custID.toString()}');
        } else {
          AppToasts.errorToast('Error: ${data['Message']}');
        }
      } else {
        final data = json.decode(response.body);
        AppToasts.errorToast('Error: ${data['Message']}');
      }
    } catch (e) {
      AppToasts.errorToast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    await fetchCustomers();
    super.onInit();
  }
}
