import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../custom_widgets/date_filters.dart';
import '../models/api/api_receipt_model.dart';
import '/helpers/toast.dart';
import '/models/user_model.dart';
import 'auth_controller.dart';

class ReceiptController extends GetxController {
  final authController = Get.find<AuthController>();
  Rx<DateTime> dateFromFilter = DateTime.now().obs;
  Rx<DateTime> dateToFilter = DateTime.now().obs;
  final receiptFormKey = GlobalKey<FormState>();
  TextEditingController customerName = TextEditingController();
  TextEditingController receiptAmount = TextEditingController();
  TextEditingController notes = TextEditingController();

  RxBool isLoading = false.obs;
  RxList<ApiReceiptModel> receiptModelList = RxList<ApiReceiptModel>();

  Future<void> getReceiptVouchers({
    String pageNo = '-1',
    String pageSize = '1',
  }) async {
    String dateFrom = DateFormat('dd/MM/yyyy').format(dateFromFilter.value);
    String dateTo = DateFormat('dd/MM/yyyy').format(dateToFilter.value);
    List<String?>? newDateFrom = dateFrom.split('T');
    List<String?>? newDateTo = dateTo.split('T');
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    if (user != null) {
      final url = Uri.parse(
          'https://$apiURL/GetPaymentList?ServiceKey=$secretKey&SalesRepID=${user.saleRepID}&datefrom=${newDateFrom[0]}&dateto=${newDateTo[0]}&PageNo=$pageNo&PageSize=$pageSize');
      try {
        isLoading(true);
        List<ApiReceiptModel> unfilteredList = [];
        receiptModelList.clear();
        unfilteredList.clear();
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['Success']) {
            final List _x = json.decode(data['data']);
            for (final x in _x) {
              if (!unfilteredList.contains(x)) {
                unfilteredList.add(ApiReceiptModel.fromJson(x));
              }
            }
            if (unfilteredList.isNotEmpty) {
              for (ApiReceiptModel x in unfilteredList) {
                receiptModelList.add(x);
              }
            }
          } else {
            AppToasts.errorToast('Incorrect Credentials'.tr);
          }
        } else {
          AppToasts.errorToast('Connection Error'.tr);
        }
        isLoading(false);
      } catch (e) {
        AppToasts.errorToast('Error occurred, contact support'.tr);
        Logger logger = Logger();
        logger.d(e.toString());
      }
    } else {
      AppToasts.errorToast('User Unrecognized'.tr);
    }
  }

  @override
  void onReady() async {
    await getReceiptVouchers();
    super.onReady();
  }

  @override
  void onInit() {
    dateFromFilter.value = firstOfJanuaryLastYear();
    super.onInit();
  }
}
