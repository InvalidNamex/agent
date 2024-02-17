import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../localization_herarchy/update_locale_button.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Drawer(
      child: ListView(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                controller.navigateToTab(0);
                Get.back();
              },
              leading: Image.asset(
                'assets/images/drawer_home.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Home'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: darkColor,
              iconColor: darkColor,
              leading: Image.asset(
                'assets/images/drawer_sells.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Sales'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              children: [
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('View Invoices'.tr),
                  onTap: () {
                    controller.navigateToTab(1);
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('Add Invoice'.tr),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/new-invoice');
                  },
                )
              ],
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: darkColor,
              iconColor: darkColor,
              leading: Image.asset(
                'assets/images/drawer_customers.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Customers'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              children: [
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('View Customers'.tr),
                  onTap: () {
                    controller.navigateToTab(2);
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('Add Customer'.tr),
                  onTap: () {
                    Get.back();
                    Get.toNamed('/new-customer');
                  },
                )
              ],
            ),
          ),
          Card(
            child: ListTile(
              onTap: () async {
                final authController = Get.find<AuthController>();
                await authController.clearDataFromPrefs('userData');
                Get.offAllNamed('/login-screen');
              },
              leading: Image.asset(
                'assets/images/drawer_logout.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Log Out'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
          Card(
            child: ExpansionTile(
              textColor: darkColor,
              iconColor: darkColor,
              leading: Image.asset(
                'assets/images/drawer_settings.png',
                height: 30,
                width: 30,
              ),
              title: Text(
                'Settings & Privacy'.tr,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              children: [
                ListTile(
                  leading: const Icon(Icons.arrow_forward_ios),
                  title: Text('Language'.tr),
                  onTap: () {
                    showLocaleDialog();
                  },
                ),
                ListTile(
                  onTap: () async {},
                  title: Text(
                    'Sell Price Included VAT'.tr,
                  ),
                  trailing: Obx(() => Checkbox(
                        value: controller.isPayTypeCash.value,
                        onChanged: (bool? value) {
                          controller.isPayTypeCash(value);
                          controller.setPayTypePref(isCash: value!);
                        },
                      )),
                ),
                ListTile(
                  onTap: () async {},
                  title: Text(
                    'Pay type is cash'.tr,
                  ),
                  trailing: Obx(() => Checkbox(
                        value: controller.isPayTypeCash.value,
                        onChanged: (bool? value) {
                          controller.isPayTypeCash(value);
                          controller.setPayTypePref(isCash: value!);
                        },
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
