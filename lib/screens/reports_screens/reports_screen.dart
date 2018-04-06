import 'package:eit/controllers/reports_controller.dart';
import 'package:eit/screens/reports_screens/sales_analysis/sales_analysis.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';

class ReportsScreen extends GetView<ReportsController> {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Card(
          child: ExpansionTile(
            textColor: darkColor,
            iconColor: darkColor,
            leading: const CircleAvatar(
                radius: 15,
                backgroundColor: accentColor,
                child: Icon(
                  Icons.add,
                  color: lightColor,
                  size: 20,
                )),
            title: Text(
              'Sales Reports'.tr,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Products Sales Analysis'.tr),
                onTap: () {
                  Get.back();
                  Get.to(const SalesAnalysis());
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Sales Analysis'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/');
                },
              ),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            textColor: darkColor,
            iconColor: darkColor,
            leading: const CircleAvatar(
                radius: 15,
                backgroundColor: accentColor,
                child: Icon(
                  Icons.add,
                  color: lightColor,
                  size: 20,
                )),
            title: Text(
              'Customers Reports'.tr,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Customer Ledger'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/');
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Customers Information'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/');
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Visits List'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/');
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Customers Balance'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/');
                },
              ),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            textColor: darkColor,
            iconColor: darkColor,
            leading: const CircleAvatar(
                radius: 15,
                backgroundColor: accentColor,
                child: Icon(
                  Icons.add,
                  color: lightColor,
                  size: 20,
                )),
            title: Text(
              'Products Reports'.tr,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Stock Management'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/');
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Product History'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/');
                },
              ),
            ],
          ),
        ),
        Card(
          child: ExpansionTile(
            textColor: darkColor,
            iconColor: darkColor,
            leading: const CircleAvatar(
                radius: 15,
                backgroundColor: accentColor,
                child: Icon(
                  Icons.add,
                  color: lightColor,
                  size: 20,
                )),
            title: Text(
              'Stock Reports'.tr,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            ),
            children: [
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Cash Balance'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/');
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_forward_ios),
                title: Text('Cash Flow'.tr),
                onTap: () {
                  Get.back();
                  Get.toNamed('/');
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
