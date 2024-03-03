import '/custom_widgets/date_filters.dart';
import '/screens/new_receipt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/receipt_controller.dart';

class ReceiptScreen extends GetView<ReceiptController> {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/new-receipt');
        },
        icon: const Icon(Icons.add),
        label: Text('New Receipt'.tr),
        backgroundColor: darkColor,
      ),
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
                'Receipt'.tr,
                style: const TextStyle(color: darkColor),
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      child: dateFromFilterMethod(
                          controller.dateFromFilter, context,
                          optionalFunction: () async =>
                              controller.getReceiptVouchers())),
                  Flexible(
                      child: dateToFilterMethod(
                          controller.dateToFilter, context,
                          optionalFunction: () async =>
                              controller.getReceiptVouchers()))
                ],
              ),
            ),
            controller.receiptModelList.isEmpty
                ? Center(child: Text('No Invoices Found.'.tr))
                : Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        itemCount: controller.receiptModelList.length,
                        itemBuilder: (context, index) {
                          String? date =
                              controller.receiptModelList[index].transDt ?? '';
                          List<String?>? newDate = date.split('T');
                          return ExpansionTile(
                            textColor: accentColor,
                            iconColor: accentColor,
                            title: Text(
                              controller.receiptModelList[index].custName ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: Text(newDate[0] ?? ''),
                            children: [
                              controller.receiptModelList[index].docNo !=
                                          null &&
                                      controller
                                              .receiptModelList[index].docNo !=
                                          ''
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Doc No: '.tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(controller
                                              .receiptModelList[index].docNo
                                              .toString()),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Amount: '.tr,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text((controller.receiptModelList[index]
                                                .payValue ??
                                            0)
                                        .toString()),
                                  ],
                                ),
                              ),
                              controller.receiptModelList[index].notes != ''
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Notes: '.tr,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(controller
                                                  .receiptModelList[index]
                                                  .notes ??
                                              ''),
                                        ],
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          );
                        }),
                  )
          ],
        ),
      ),
    );
  }
}
