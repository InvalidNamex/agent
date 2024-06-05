import 'dart:convert';

import 'package:eit/models/api/save_invoice/api_invoice_master_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../helpers/toast.dart';
import '../models/api/api_invoice_details_model.dart';
import '../models/api/api_invoice_model.dart';
import '../models/api/api_po_master_model.dart';
import '../models/api/api_sales_analysis_model.dart';
import '../models/customer_model.dart';
import '../models/user_model.dart';
import '/controllers/auth_controller.dart';
import '/helpers/loader.dart';

class ReportsController extends GetxController {
  RxString payTypeFilter = 'All'.obs;
  Rx<DateTime> dateFromFilter = DateTime.now().obs;
  Rx<DateTime> dateToFilter = DateTime.now().obs;
  final authController = Get.find<AuthController>();
  Rx<CustomerModel> reportsScreenCustomerModel =
      CustomerModel(custName: 'Choose Customer'.tr).obs;

  RxList<SalesAnalysisModel> salesAnalysisList = RxList<SalesAnalysisModel>();
  InvMasterModel? invMaster;
  PoMasterModel? poMaster;
  RxList<InvDetailsModel> salesInvDetails = RxList<InvDetailsModel>();

  Future<void> getSalesInvList(
      {String pageNo = '-1',
      String pageSize = '1',
      String payType = 'All' // Cash, Credit, All
      }) async {
    String dateFrom = DateFormat('dd/MM/yyyy').format(dateFromFilter.value);
    String dateTo = DateFormat('dd/MM/yyyy').format(dateToFilter.value);
    RxBool isLoading = false.obs;
    List<String?>? newDateFrom = dateFrom.split('T');
    List<String?>? newDateTo = dateTo.split('T');
    UserModel? user = authController.userModel;
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    if (user != null) {
      //?/RepSalesAnalysis?ServiceKey=1357&CustID=304&SalesRepID=1&PayType="All"&datefrom=1/1/2022&dateto=30/10/2022&PageNo=-1&PageSize=0
      final url = Uri.parse(
          'https://$apiURL/RepSalesAnalysis?ServiceKey=$secretKey&CustID=${reportsScreenCustomerModel.value.custCode}&SalesRepID=${user.saleRepID}&PayType=$payType&datefrom=${newDateFrom.first}&dateto=${newDateTo.first}&PageNo=$pageNo&PageSize=$pageSize');
      try {
        isLoading(true);
        salesAnalysisList.clear();
        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['Success']) {
            if (data['dataCount'] > 0) {
              final List _x = json.decode(data['data']);
              for (final x in _x) {
                if (!salesAnalysisList.contains(x)) {
                  salesAnalysisList.add(SalesAnalysisModel.fromJson(x));
                }
              }
            }
          } else {
            AppToasts.errorToast('Incorrect Credentials'.tr);
            Logger().e('Incorrect Credentials, reportsController');
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

  //!this actually was updated to get inv details and master also it gets po details and master.
  Future<bool> getInvDetails({
    ApiInvoiceModel? apiInv,
  }) async {
    salesInvDetails.clear();
    Logger().i(apiInv?.sysInvID);
    Logger().i(apiInv?.transID);
    String? invID = apiInv?.sysInvID.toString() == '0'
        ? apiInv?.transID.toString()
        : apiInv?.sysInvID.toString();
    bool isPO = apiInv?.sysInvID.toString() == '0';
    Map config = await authController.readApiConnectionFromPrefs();
    String apiURL = config.keys.first;
    String secretKey = config.values.first;
    //https://Mobiletest.itgenesis.app/GetInvInfo?ServiceKey=1357&InvID=37
    final url = Uri.parse(isPO
        ? 'https://$apiURL/GetInvTrans?ServiceKey=$secretKey&&TransID=$invID'
        : 'https://$apiURL/GetInvInfo?ServiceKey=$secretKey&&InvID=$invID');
    try {
      Loading.load();
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Success']) {
          Map<String, dynamic> decoded = jsonDecode(data['data']);
          if (!isPO) {
            invMaster = InvMasterModel.fromJson(decoded['Master'][0]);
          } else {
            poMaster = PoMasterModel.fromJson(decoded['Master'][0]);
            print(poMaster?.toJson().toString());
          }
          List _x = decoded['Detail'];
          for (final x in _x) {
            if (!salesInvDetails.contains(x)) {
              salesInvDetails.add(InvDetailsModel.fromJson(x));
            }
          }
          Loading.dispose();
          if (isPO) {
            return true;
          } else {
            return false;
          }
        } else {
          AppToasts.errorToast('Error occurred, contact support'.tr);
        }
      }
      Loading.dispose();
    } catch (e) {
      AppToasts.errorToast('Error occurred, contact support'.tr);
      Logger logger = Logger();
      logger.d(e.toString());
      Loading.dispose();
    }
    return false;
  }
}
