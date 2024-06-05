import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/constants.dart';
import 'package:eit/controllers/reports_controller.dart';
import 'package:eit/helpers/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/customer_controller.dart';
import '../../../custom_widgets/date_filters.dart';
import '../../../helpers/loader.dart';
import '../../../models/customer_model.dart';
import 'sales_analysis_table.dart';

class SalesAnalysis extends GetView<ReportsController> {
  const SalesAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.find<CustomerController>();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        centerTitle: true,
        backgroundColor: lightColor,
        iconTheme:
            const IconThemeData(color: darkColor), // Setting the icon color
        title: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              'assets/images/icon.png',
              height: 25,
              width: 60,
            ),
            FittedBox(
              child: Text(
                'Products Sales Analysis'.tr,
                style: const TextStyle(color: darkColor),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          SizedBox(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child:
                        dateFromFilterMethod(controller.dateFromFilter, context,
                            optionalFunction: () async {
                      controller.reportsScreenCustomerModel.value.custName ==
                              'Choose Customer'.tr
                          ? AppToasts.errorToast('اختر عميل أولًا')
                          : await controller.getSalesInvList();
                    }),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: dateToFilterMethod(controller.dateToFilter, context,
                        optionalFunction: () async {
                      controller.reportsScreenCustomerModel.value.custName ==
                              'Choose Customer'.tr
                          ? AppToasts.errorToast('اختر عميل أولًا')
                          : await controller.getSalesInvList();
                    }),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => customerController.customersList.isEmpty
                ? Text('Choose A Customer'.tr)
                : DropdownSearch<CustomerModel>(
                    popupProps: const PopupProps.menu(showSearchBox: true),
                    items: customerController.customersList,
                    itemAsString: (customer) => customer.custName!,
                    onChanged: (customer) async {
                      CustomerModel customerModel = customer!;
                      Loading.load();
                      controller.reportsScreenCustomerModel.value =
                          customerModel;
                      await controller.getSalesInvList();
                      Loading.dispose();
                    },
                    selectedItem: controller.reportsScreenCustomerModel.value,
                  ),
          ),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Pay Type:'.tr),
                  Radio<String>(
                    value: 'Cash',
                    activeColor: accentColor,
                    groupValue: controller.payTypeFilter.value,
                    onChanged: (value) async {
                      controller.payTypeFilter.value = value!;
                      await controller.getSalesInvList(payType: value);
                    },
                  ),
                  Text('Cash'.tr),
                  Radio<String>(
                    activeColor: accentColor,
                    value: 'Debit',
                    groupValue: controller.payTypeFilter.value,
                    onChanged: (value) async {
                      controller.payTypeFilter.value = value!;
                      await controller.getSalesInvList(payType: value);
                    },
                  ),
                  Text('Debit'.tr),
                  Radio<String>(
                    value: 'All',
                    activeColor: accentColor,
                    groupValue: controller.payTypeFilter.value,
                    onChanged: (value) async {
                      controller.payTypeFilter.value = value!;
                      await controller.getSalesInvList(payType: value);
                    },
                  ),
                  Text('All'.tr),
                ],
              )),
          Obx(
            () => Expanded(
                child: controller.salesAnalysisList.isEmpty
                    ? Center(
                        child: Text('No Sales Found'.tr),
                      )
                    : SalesAnalysisTable(
                        data: controller.salesAnalysisList,
                      )),
          ),
        ]),
      ),
    );
  }
}
