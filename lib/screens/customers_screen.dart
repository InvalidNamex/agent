import 'package:eit/constants.dart';
import 'package:eit/controllers/customer_controller.dart';
import 'package:eit/helpers/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import '../custom_widgets/download_customers.dart';

class CustomersScreen extends GetView<CustomerController> {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TableRow tableHeaders = TableRow(
      children: [
        Container(
          color: accentColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Name'.tr,
            style: const TextStyle(
                color: lightColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: accentColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Phone'.tr,
            style: const TextStyle(
                color: lightColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: accentColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Address'.tr,
            style: const TextStyle(
                color: lightColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          color: accentColor,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Edit'.tr,
            style: const TextStyle(
                color: lightColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    RxList<TableRow> tableRowByCustomer() {
      RxList<TableRow> tableRows = RxList();
      tableRows.insert(0, tableHeaders);
      for (final x in controller.customersList) {
        tableRows.add(TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                x.custName ?? '',
                maxLines: 3,
                style: const TextStyle(color: darkColor, fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                x.phone ?? '',
                maxLines: 3,
                style: const TextStyle(color: darkColor, fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                x.address ?? '',
                style: const TextStyle(color: darkColor, fontSize: 12),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.edit_location_alt_outlined,
                    color: accentColor,
                  ),
                )),
          ],
        ));
      }
      return tableRows;
    }

    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: darkColor,
        overlayOpacity: 0,
        children: [
          SpeedDialChild(
              child: const Icon(
                Icons.download,
                color: lightColor,
              ),
              backgroundColor: accentColor,
              onTap: () async {
                Loading.load();
                await generateCustomersReportPdf(controller);
                Loading.dispose();
              }),
          SpeedDialChild(
              child: const Icon(
                Icons.add_reaction_outlined,
                color: lightColor,
              ),
              backgroundColor: accentColor,
              onTap: () {
                Get.toNamed('/new-customer');
              }),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Obx(
            () => controller.customersList.isEmpty
                ? loader()
                : Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: IntrinsicColumnWidth(flex: 1),
                      1: IntrinsicColumnWidth(flex: 1),
                      2: IntrinsicColumnWidth(flex: 1),
                      3: IntrinsicColumnWidth(flex: 1),
                    },
                    border: TableBorder.all(width: 1.0, color: darkColor),
                    children: tableRowByCustomer(),
                  ),
          ),
        ),
      ),
    );
  }
}