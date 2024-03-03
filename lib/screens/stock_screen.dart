import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/controllers/stock_controller.dart';
import 'package:eit/helpers/loader.dart';
import 'package:eit/models/api/api_stock_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants.dart';

class StockScreen extends GetView<StockController> {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                'Stock'.tr,
                style: const TextStyle(color: darkColor),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() => controller.stockItemList.isEmpty
          ? const SizedBox()
          : Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () async {
                              controller.stockItemDropDown =
                                  StockItemModel(itemName: 'Choose Item'.tr)
                                      .obs;
                              controller.getItemsStock();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                          title: Obx(
                            () => controller.stockItemList.isEmpty
                                ? Text('Choose Item'.tr)
                                : DropdownSearch<StockItemModel>(
                                    popupProps: const PopupProps.menu(
                                        showSearchBox: true),
                                    items: controller.stockItemList,
                                    itemAsString: (item) => item.itemName!,
                                    onChanged: (item) async {
                                      StockItemModel stockItemModel = item!;
                                      // controller.customerNameFilter(
                                      //     customerModel.custName!);
                                      Loading.load();
                                      await controller.getItemsStock(
                                          itemid: stockItemModel.itemId);
                                      Loading.dispose();
                                    },
                                    selectedItem:
                                        controller.stockItemDropDown.value,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Card(
                          child: ListTile(
                            leading: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                controller.stockItemList[index].itemName ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            title: Text(
                                (controller.stockItemList[index].quantity ?? 0)
                                    .roundToDouble()
                                    .toString()),
                            trailing: Text(
                                controller.stockItemList[index].mainUnit ?? ''),
                          ),
                        ),
                      );
                    },
                    itemCount: controller.stockItemList.length,
                  ),
                ),
              ],
            )),
    );
  }
}
