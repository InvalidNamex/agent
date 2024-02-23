import 'dart:convert';

import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/models/customer_model.dart';
import 'package:eit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../custom_widgets/date_filters.dart';
import '../helpers/toast.dart';
import '../models/api/api_invoice_item.dart';
import '../models/api/api_invoice_model.dart';
import '../models/api/save_invoice/api_save_invoice_model.dart';
import '../models/invoice_item_model.dart';
import '../models/item_model.dart';

class SalesController extends GetxController {
  Rx<DateTime> dateFromFilter = DateTime.now().obs;
  Rx<DateTime> dateToFilter = DateTime.now().obs;
  final itemQuantityFormKey = GlobalKey<FormState>();
  TextEditingController invoiceNote = TextEditingController();
  RxDouble longitude = 0.0.obs;
  RxDouble latitude = 0.0.obs;
  TextEditingController mainQty = TextEditingController();
  TextEditingController subQty = TextEditingController();
  TextEditingController smallQty = TextEditingController();
  RxBool isLoading = false.obs;
  RxString customerNameFilter = ''.obs;
  RxList<ApiInvoiceModel> apiInvList = RxList<ApiInvoiceModel>();
  RxList<InvoiceItemModel> invoiceItemsList = RxList<InvoiceItemModel>();
  Rx<CustomerModel> salesScreenDropDownCustomer =
      CustomerModel(custName: 'Choose Customer'.tr).obs;
  Rx<CustomerModel> addItemDropDownCustomer =
      CustomerModel(custName: 'Choose Customer'.tr).obs;

  double get totalTax =>
      invoiceItemsList.fold(0, (sum, item) => sum + (item.tax ?? 0));
  double get totalDiscount =>
      invoiceItemsList.fold(0, (sum, item) => sum + (item.discount ?? 0));
  double get grandTotal =>
      invoiceItemsList.fold(0, (sum, item) => sum + (item.total ?? 0));
  RxList<ApiInvoiceItem> apiInvoiceItemList = RxList<ApiInvoiceItem>();
  RxList<ItemModel> customerItemsList = RxList<ItemModel>();
  RxBool isCustomerChosen = false.obs;
  final priceFrom = TextEditingController(text: 0.toString());
  final priceTo = TextEditingController(text: 1000000.toString());
  final GlobalKey<FormState> filterFormKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();
  CustomerModel? customerModel;

  Future<void> getFilteredInvoices(
      {String pageNo = '-1',
      String pageSize = '1',
      double amountFrom = 0,
      double amountTo = 1000000,
      bool isFiltered = false}) async {
    dateFromFilter.value =
        isFiltered ? dateFromFilter.value : firstOfJanuaryLastYear();
    String dateFrom = DateFormat('dd/MM/yyyy').format(dateFromFilter.value);
    String dateTo = DateFormat('dd/MM/yyyy').format(dateToFilter.value);
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    if (user != null) {
      final url = Uri.parse(
          //https://Mobiletest.itgenesis.app/GetInvList?ServiceKey=1357&SalesRepID=2&datefrom=01/01/2022&dateto=23/12/2023&PageNo=1&PageSize=1
          'https://$apiURL/GetInvList?ServiceKey=$secretKey&SalesRepID=${user.saleRepID}&datefrom=$dateFrom&dateto=$dateTo&PageNo=$pageNo&PageSize=$pageSize');

      try {
        isLoading(true);
        List<ApiInvoiceModel> unfilteredList = [];
        apiInvList.clear();
        unfilteredList.clear();
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['Success']) {
            final List _x = json.decode(data['data']);
            for (final x in _x) {
              if (!unfilteredList.contains(x)) {
                unfilteredList.add(ApiInvoiceModel.fromJson(x));
              }
            }
            if (unfilteredList.isNotEmpty) {
              for (ApiInvoiceModel x in unfilteredList) {
                if (x.invAmount! < amountTo && x.invAmount! >= amountFrom) {
                  if (customerNameFilter.value == '') {
                    apiInvList.add(x);
                  } else if (customerNameFilter.value != '' &&
                      customerNameFilter.value == x.custName) {
                    apiInvList.add(x);
                  }
                }
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
        AppToasts.errorToast(e.toString());
      }
    } else {
      AppToasts.errorToast('User Unrecognized'.tr);
    }
  }

  Future<void> getFilteredItemsByCustomer({required String customerID}) async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    // https://Mobiletest.itgenesis.app/GetItemList?ServiceKey=1357&CustCode=304
    final url = Uri.parse(
        'https://$apiURL/GetItemList?ServiceKey=$secretKey&CustCode=$customerID');
    try {
      isLoading(true);
      customerItemsList.clear();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          final List _x = json.decode(data['data']);
          for (final i in _x) {
            if (!customerItemsList.contains(i)) {
              customerItemsList.add(ItemModel.fromJson(i));
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
      AppToasts.errorToast('Error occurred, please contact support'.tr);
      isLoading(true);
      var logger = Logger();
      logger.d(e.toString());
    }
  }

  String formatDate(String? dateStr) {
    try {
      DateTime parsedDate = DateTime.parse(dateStr!);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      AppToasts.errorToast('Date Error'.tr);
      return '';
    }
  }

  Future<void> saveInvoice(ApiSaveInvoiceModel invoice) async {
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;

    final queryString = Uri.encodeComponent(jsonEncode(invoice.toJson()));
    final url = Uri.parse(
        'https://$apiURL/SaveInvTrans?ServiceKey=$secretKey&InvInfo=$queryString');
    try {
      isLoading(true);
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          final String dataString = '{${data['data']}}';
          final decodedData = json.decode(dataString);
          int transID = decodedData['TransID'];
          AppToasts.successToast(
              '${'Saved Successfully'.tr}\n ${transID.toString()}');
          await getFilteredInvoices();
        } else {
          AppToasts.errorToast('Error: ${data['Message']}');
        }
      } else {
        AppToasts.errorToast('Connection Error'.tr);
      }
    } catch (e) {
      AppToasts.errorToast(e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() async {
    dateFromFilter.value = firstOfJanuaryLastYear();
    super.onInit();
  }

  @override
  void onReady() async {
    await getFilteredInvoices();
    super.onReady();
  }
}
