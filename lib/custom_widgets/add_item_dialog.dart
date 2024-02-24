import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/sales_controller.dart';
import '../models/api/api_invoice_item.dart';
import '../models/invoice_item_model.dart';
import '../models/item_model.dart';

void itemQtyPopUp(ItemModel item, SalesController controller) {
  RxDouble itemTotalPrice = 0.0.obs;
  RxDouble itemTotalDiscount = 0.0.obs;
  RxDouble itemTotalTax = 0.0.obs;
  controller.mainQty.text = '1';
  controller.subQty.text = '';
  controller.smallQty.text = '';
  calculatePrice() {
    double mainQty = double.parse(
        controller.mainQty.text.isEmpty ? '0' : controller.mainQty.text);
    double subQty = double.parse(
            controller.subQty.text.isEmpty ? '0' : controller.subQty.text) /
        (item.mainUnitPack ?? 0);
    double smallQty = double.parse(
            controller.smallQty.text.isEmpty ? '0' : controller.smallQty.text) /
        (item.subUnitPack ?? 0) /
        (item.mainUnitPack ?? 0);
    double totalQty = mainQty + subQty + smallQty;
    itemTotalPrice(totalQty * (item.price ?? 0));
    itemTotalDiscount(
        itemTotalPrice.value * (item.disc != null ? (item.disc! / 100) : 0));
    itemTotalTax((itemTotalPrice.value - itemTotalDiscount.value) *
        (item.vat != null ? (item.vat! / 100) : 0));
  }

  calculatePrice();
  Get.dialog(AlertDialog(
      content: SingleChildScrollView(
    child: Form(
      key: controller.itemQuantityFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.itemName ?? '',
            overflow: TextOverflow.ellipsis,
          ),
          Card(
            child: ListTile(
              leading: Text(
                item.mainUnit ?? 'Main Unit'.tr,
              ),
              title: TextFormField(
                onTap: () {
                  controller.mainQty.clear();
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.mainQty.text = value;
                  } else {
                    controller.mainQty.text = 0.toString();
                  }
                  calculatePrice();
                },
                textAlign: TextAlign.center,
                controller: controller.mainQty,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .transparent), // Change the border color when focused
                  ),
                ),
              ),
            ),
          ),
          item.subUnit.isBlank!
              ? const SizedBox()
              : Card(
                  child: ListTile(
                    leading: Text(
                      item.subUnit ?? 'Sub Unit'.tr,
                    ),
                    title: TextFormField(
                      onTap: () {
                        controller.subQty.clear();
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          controller.subQty.text = value;
                        } else {
                          controller.subQty.text = 0.toString();
                        }
                        calculatePrice();
                      },
                      textAlign: TextAlign.center,
                      controller: controller.subQty,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .transparent), // Change the border color when focused
                        ),
                      ),
                    ),
                    trailing: Text(item.mainUnitPack.toString()),
                  ),
                ),
          item.smallUnit.isBlank!
              ? const SizedBox()
              : Card(
                  child: ListTile(
                    leading: Text(
                      item.smallUnit ?? 'Small Unit'.tr,
                    ),
                    title: TextFormField(
                      onTap: () {
                        controller.smallQty.clear();
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          controller.smallQty.text = value;
                        } else {
                          controller.smallQty.text = 0.toString();
                        }
                        calculatePrice();
                      },
                      textAlign: TextAlign.center,
                      controller: controller.smallQty,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      autofocus: true,
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .transparent), // Change the border color when focused
                        ),
                      ),
                    ),
                    trailing: Text(item.subUnitPack.toString()),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Price: '.tr,
                        style: const TextStyle(color: darkColor, fontSize: 16),
                      ),
                      Obx(
                        () => Text(
                          (itemTotalPrice).roundToDouble().toString(),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Discount: '.tr,
                        style: const TextStyle(color: darkColor, fontSize: 16),
                      ),
                      Obx(
                        () => Text(
                          (itemTotalDiscount).roundToDouble().toString(),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Tax: '.tr,
                        style: const TextStyle(color: darkColor, fontSize: 16),
                      ),
                      Obx(
                        () => Text(
                          (itemTotalTax).roundToDouble().toString(),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                  width: 1,
                  height: 60,
                  child: VerticalDivider(
                    thickness: 1,
                    color: darkColor,
                    width: 1,
                  )),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Stock: '.tr,
                        style: const TextStyle(color: darkColor, fontSize: 16),
                      ),
                      Text(
                        (item.qtyBalance ?? 0).roundToDouble().toString(),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: Get.width,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                InvoiceItemModel invItemModel = InvoiceItemModel(
                  mainQty: double.tryParse(controller.mainQty.text),
                  subQty: double.tryParse(controller.subQty.text),
                  smallQty: double.tryParse(controller.smallQty.text),
                  itemName: item.itemName,
                  quantity:
                      '${controller.mainQty.text.isEmpty ? '' : '${item.mainUnit}: ${controller.mainQty.text}'}${controller.subQty.text.isEmpty ? '' : '\n${item.subUnit}: ${controller.subQty.text}'}${controller.smallQty.text.isEmpty ? '' : '\n${item.smallUnit}: ${controller.smallQty.text}'}',
                  price: (item.price ?? 0).roundToDouble(),
                  discount: itemTotalDiscount.value,
                  tax: itemTotalTax.value,
                  total: ((itemTotalPrice.value - itemTotalDiscount.value) +
                          itemTotalTax.value)
                      .roundToDouble(),
                );
                controller.invoiceItemsList.add(invItemModel);
                ApiInvoiceItem apiInvoiceItem = ApiInvoiceItem(
                    itemId: item.id!,
                    price: (item.price ?? 0),
                    quantity: (controller.mainQty.text != '0' &&
                                controller.mainQty.text.isNotEmpty
                            ? double.parse(controller.mainQty.text)
                            : 0.0) +
                        (controller.subQty.text != '0' &&
                                controller.subQty.text.isNotEmpty
                            ? (double.parse(controller.subQty.text) /
                                item.mainUnitPack!)
                            : 0.0) +
                        (controller.smallQty.text != '0' &&
                                controller.smallQty.text.isNotEmpty
                            ? ((double.parse(controller.smallQty.text) /
                                    item.subUnitPack!) /
                                item.mainUnitPack!)
                            : 0.0),
                    discountPercentage: (item.disc ?? 0).roundToDouble(),
                    vatPercentage: (item.vat ?? 0).roundToDouble());
                controller.apiInvoiceItemList.add(apiInvoiceItem);
                Get.back();
              },
              style: ElevatedButton.styleFrom(backgroundColor: darkColor),
              child: Text(
                'ADD'.tr,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: lightColor),
              ),
            ),
          ),
        ],
      ),
    ),
  )));
}
