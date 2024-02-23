import 'package:eit/controllers/receipt_controller.dart';
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
      body: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [],
          )
        ],
      ),
    );
  }
}
