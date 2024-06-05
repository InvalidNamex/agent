import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/controllers/customer_controller.dart';
import 'package:eit/controllers/receipt_controller.dart';
import 'package:eit/helpers/loader.dart';
import 'package:eit/helpers/toast.dart';
import 'package:eit/models/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
import '../controllers/auth_controller.dart';

class NewReceipt extends GetView<ReceiptController> {
  const NewReceipt({super.key});
  @override
  Widget build(BuildContext context) {
    final customerController = Get.find<CustomerController>();
    final authController = Get.find<AuthController>();
    List<CustomerModel> customersList =
        authController.sysInfoModel?.custSys == '1'
            ? customerController.customersListByRoute
            : customerController.customersList;
    final customerNameArgument =
        Get.arguments != null ? Get.arguments['custName'] : null;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'.tr),
            content: Text('Do you want to leave without saving?'.tr),
            actions: [
              TextButton(
                child: Text('No'.tr),
                onPressed: () {
                  Get.back();
                }, // Disallow pop
              ),
              TextButton(
                child: Text('Yes'.tr),
                onPressed: () {
                  controller.newReceiptDropDownCustomer(
                      CustomerModel(custName: 'Choose Customer'.tr));
                  controller.receiptAmount.clear();
                  controller.notes.clear();
                  Get.offAllNamed('/index-screen');
                },
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 65,
          centerTitle: true,
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
                  'New Receipt'.tr,
                  style: const TextStyle(color: darkColor),
                ),
              ),
            ],
          ),
        ),
        body: Form(
          key: controller.receiptFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: customerNameArgument == null
                    ? Obx(
                        () => customersList.isEmpty
                            ? Text('Choose A Customer'.tr)
                            : DropdownSearch<CustomerModel>(
                                popupProps:
                                    const PopupProps.menu(showSearchBox: true),
                                items: customersList,
                                itemAsString: (customer) => customer.custName!,
                                onChanged: (customer) {
                                  CustomerModel customerModel = customer!;
                                  controller.newReceiptDropDownCustomer(
                                      customerModel);
                                },
                                selectedItem:
                                    controller.newReceiptDropDownCustomer.value,
                              ),
                      )
                    : Text(customerNameArgument.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'mandatory field'.tr; // Validation message
                    }
                    return null; // Return null if the input is valid
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.attach_money,
                      color: accentColor,
                    ),
                    contentPadding: const EdgeInsets.all(5),
                    labelText: 'Amount'.tr,
                    labelStyle: const TextStyle(color: darkColor, fontSize: 14),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                          color:
                              accentColor.withOpacity(0.5)), // Change the bor
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                          color: accentColor.withOpacity(
                              0.5)), // Change the border color when not focused
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: controller.receiptAmount,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.note_alt,
                      color: accentColor,
                    ),
                    contentPadding: const EdgeInsets.all(5),
                    labelText: 'Notes'.tr,
                    labelStyle: const TextStyle(color: darkColor, fontSize: 14),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),

                      borderSide: BorderSide(
                          color:
                              accentColor.withOpacity(0.5)), // Change the bor
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),

                      borderSide: BorderSide(
                          color: accentColor.withOpacity(
                              0.5)), // Change the border color when not focused
                    ),
                  ),
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  controller: controller.notes,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50), // Rounded corners
                    ),
                  ),
                  onPressed: () async {
                    if (controller.receiptFormKey.currentState!.validate()) {
                      try {
                        Loading.load();
                        if (customerNameArgument != null &&
                            customerNameArgument != '') {
                          final customerController =
                              Get.find<CustomerController>();
                          CustomerModel _customer = customerController
                              .customersList
                              .where((CustomerModel customer) =>
                                  customer.custName == customerNameArgument)
                              .first;
                          controller.newReceiptDropDownCustomer.value =
                              _customer;
                        }
                        await controller.saveReceipt();
                        controller.newReceiptDropDownCustomer =
                            CustomerModel(custName: 'Choose Customer'.tr).obs;
                        Loading.dispose();
                        controller.notes.clear();
                        controller.receiptAmount.clear();
                      } catch (e) {
                        AppToasts.errorToast(e.toString());
                        Logger().e(e.toString());
                      }
                    }
                  },
                  child: Text(
                    'Save Receipt'.tr,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
