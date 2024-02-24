import 'package:eit/controllers/receipt_controller.dart';
import 'package:eit/helpers/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class NewReceipt extends GetView<ReceiptController> {
  const NewReceipt({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'mandatory field'.tr; // Validation message
                  }
                  return null; // Return null if the input is valid
                },
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.person,
                    color: accentColor,
                  ),
                  contentPadding: const EdgeInsets.all(5),
                  labelText: 'Customer Name'.tr,
                  labelStyle: const TextStyle(color: darkColor, fontSize: 14),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),

                    borderSide: BorderSide(
                        color: accentColor.withOpacity(0.5)), // Change the bor
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),

                    borderSide: BorderSide(
                        color: accentColor.withOpacity(
                            0.5)), // Change the border color when not focused
                  ),
                ),
                textAlign: TextAlign.start,
                controller: controller.customerName,
              ),
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
                        color: accentColor.withOpacity(0.5)), // Change the bor
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
                        color: accentColor.withOpacity(0.5)), // Change the bor
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),

                    borderSide: BorderSide(
                        color: accentColor.withOpacity(
                            0.5)), // Change the border color when not focused
                  ),
                ),
                maxLines: 2,
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
                    borderRadius: BorderRadius.circular(50), // Rounded corners
                  ),
                ),
                onPressed: () async {
                  if (controller.receiptFormKey.currentState!.validate()) {
                    //todo: add validation and functionality to button
                    try {} catch (e) {
                      AppToasts.errorToast(e.toString());
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
    );
  }
}
