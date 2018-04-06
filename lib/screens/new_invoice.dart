import 'package:dropdown_search/dropdown_search.dart';
import 'package:eit/controllers/auth_controller.dart';
import 'package:eit/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../constants.dart';
import '../custom_widgets/add_item_dialog.dart';
import '../custom_widgets/items_table.dart';
import '../helpers/loader.dart';
import '../helpers/location_comparison.dart';
import '../helpers/toast.dart';
import '../map_hierarchy/location_service.dart';
import '../models/customer_model.dart';
import '../utilities/qr_scanner.dart';
import '/controllers/customer_controller.dart';
import '/controllers/sales_controller.dart';
import '/custom_widgets/custom_drawer.dart';
import '/models/api/save_invoice/api_save_invoice_model.dart';
import '/models/item_model.dart';
import '/screens/print_screen.dart';

class NewInvoice extends GetView<SalesController> {
  const NewInvoice({super.key});

  @override
  Widget build(BuildContext context) {
    final customerNameArgument =
        Get.arguments != null ? Get.arguments['custName'] : null;
    final customerController = Get.find<CustomerController>();
    final homeController = Get.find<HomeController>();
    int payType = 1;
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = controller.invoiceItemsList.isEmpty
            ? true
            : await showDialog<bool>(
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
                        controller.invoiceNote.clear();
                        controller.invoiceItemsList.clear();
                        controller.isCustomerChosen(false);
                        controller.resetValues();
                        controller.addItemDropDownCustomer.value =
                            CustomerModel(custName: 'Choose Customer'.tr);
                        Get.offAllNamed('/index-screen');
                      },
                    ),
                  ],
                ),
              );
        controller.isCustomerChosen(false);
        return shouldPop ?? false;
      },
      child: Scaffold(
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
                  'New Invoice'.tr,
                  style: const TextStyle(color: darkColor),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: customerNameArgument == null
                    ? Obx(
                        () => customerController.customersList.isEmpty
                            ? Text('Choose A Customer'.tr)
                            : Card(
                                child: ListTile(
                                  leading: const Icon(
                                    Icons.search,
                                    color: accentColor,
                                  ),
                                  title: DropdownSearch<CustomerModel>(
                                    popupProps: const PopupProps.menu(
                                        showSearchBox: true),
                                    items: customerController.customersList,
                                    itemAsString: (customer) =>
                                        customer.custName!,
                                    onChanged: (customer) async {
                                      try {
                                        CustomerModel customerModel = customer!;
                                        controller.customerModel = customer;
                                        controller.isCustomerChosen(true);
                                        if (controller
                                            .invoiceItemsList.isNotEmpty) {
                                          Get.defaultDialog(
                                            title:
                                                'Items in the invoice will be deleted as you change customer.\n Do you wish to proceed?'
                                                    .tr,
                                            titleStyle:
                                                const TextStyle(fontSize: 14),
                                            content: Column(children: [
                                              SizedBox(
                                                height: 50,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        controller
                                                            .invoiceItemsList
                                                            .clear();
                                                        await controller
                                                            .getFilteredItemsByCustomer(
                                                                customerID:
                                                                    customerModel
                                                                        .custCode!);
                                                        Get.back();
                                                      },
                                                      child: Text(
                                                        'Yes'.tr,
                                                        style: const TextStyle(
                                                            color: darkColor),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                          'No'.tr,
                                                          style: const TextStyle(
                                                              color: darkColor),
                                                        ))
                                                  ],
                                                ),
                                              )
                                            ]),
                                          );
                                        } else {
                                          await controller
                                              .getFilteredItemsByCustomer(
                                                  customerID:
                                                      customerModel.custCode!);
                                        }
                                      } catch (e) {
                                        AppToasts.errorToast(
                                            'Cannot find customer'.tr);
                                      }
                                    },
                                    selectedItem: controller
                                        .addItemDropDownCustomer.value,
                                  ),
                                ),
                              ),
                      )
                    : Text(customerNameArgument.toString()),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Card(
                    child: ListTile(
                      leading: !controller.isCustomerChosen.value
                          ? const SizedBox()
                          : controller.customerItemsList.isEmpty
                              ? const Icon(
                                  Icons.qr_code_2,
                                  color: darkColor,
                                  size: 40,
                                )
                              : IconButton(
                                  icon: const Icon(
                                    Icons.qr_code_2,
                                    color: accentColor,
                                    size: 40,
                                  ),
                                  onPressed: () async {
                                    String barcodeString =
                                        await barcodeScanner();
                                    ItemModel? item = controller
                                        .customerItemsList
                                        .firstWhereOrNull((item) =>
                                            item.barCode == barcodeString);
                                    if (item != null) {
                                      itemQtyPopUp(item, controller);
                                    } else {
                                      AppToasts.errorToast(
                                          '$barcodeString\nBarcode Not Found'
                                              .tr);
                                    }
                                  },
                                ),
                      title: !controller.isCustomerChosen.value
                          ? InkWell(
                              onTap: () => Get.dialog(AlertDialog(
                                    content: Text(
                                        'You must first choose a customer'.tr),
                                  )),
                              child: Text('Choose Item'.tr))
                          : controller.customerItemsList.isEmpty
                              ? loader()
                              : DropdownSearch<ItemModel>(
                                  popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      itemBuilder: (context, item, selected) {
                                        return ListTile(
                                          title: Text(
                                            item.itemName ?? 'No Name'.tr,
                                            style: const TextStyle(
                                                color: darkColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  '${item.mainUnit}: ${item.mainUnitPack.toString()}'),
                                              SizedBox(
                                                  height: 25,
                                                  child: VerticalDivider(
                                                    width: 20,
                                                    color: darkColor
                                                        .withOpacity(0.4),
                                                    thickness: 2,
                                                  )),
                                              Text(
                                                  '${item.subUnit}: ${item.subUnitPack.toString()}'),
                                            ],
                                          ),
                                        );
                                      }),
                                  items: controller.customerItemsList,
                                  itemAsString: (item) =>
                                      item.itemName ?? 'No Name'.tr,
                                  selectedItem:
                                      ItemModel(itemName: 'Choose Item'.tr),
                                  onChanged: (item) {
                                    itemQtyPopUp(item!, controller);
                                  },
                                ),
                    ),
                  ),
                ),
              ),
              buildTable(context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Total Tax:  '.tr,
                      style: const TextStyle(color: darkColor, fontSize: 18),
                    ),
                    Text(
                      controller.totalTax.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Total Discount:  '.tr,
                      style: const TextStyle(color: darkColor, fontSize: 18),
                    ),
                    Text(
                      controller.totalDiscount.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Total:  '.tr,
                      style: const TextStyle(color: darkColor, fontSize: 18),
                    ),
                    Text(
                      controller.grandTotal.toStringAsFixed(2),
                      style: const TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Note:  '.tr,
                      style: const TextStyle(color: darkColor, fontSize: 18),
                    ),
                    Flexible(
                        child: TextFormField(
                      controller: controller.invoiceNote,
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => !homeController.isPayTypeCash.value
                    ? Row(
                        children: [
                          Text(
                            'Pay Type: '.tr,
                            style:
                                const TextStyle(color: darkColor, fontSize: 18),
                          ),
                          Flexible(child: isCashDropDown(payType))
                        ],
                      )
                    : const SizedBox()),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50), // Rounded corners
                    ),
                  ),
                  onPressed: () async {
                    try {
                      Loading.load();
                      LocationData? locationData =
                          await LocationService().getLocationData();
                      controller.longitude(locationData?.longitude);
                      controller.latitude(locationData?.latitude);
                      Loading.dispose();
                      if ((controller.latitude.value != 0.0) ||
                          (controller.longitude.value != 0.0)) {
                        final authController = Get.find<AuthController>();
                        DateTime now = DateTime.now();
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(now);
                        ApiSaveInvoiceModel apiInvoiceModel =
                            ApiSaveInvoiceModel(
                                invDate: formattedDate,
                                custID: int.parse(
                                    controller.customerModel!.custCode!),
                                salesRepID:
                                    authController.userModel!.saleRepID!,
                                payType: payType,
                                invNote: controller.invoiceNote.text,
                                latitude: controller.latitude.toString(),
                                longitude: controller.longitude.toString(),
                                products: controller.apiInvoiceItemList
                                    .map((item) => item
                                        .toJson()) // Ensure correct conversion to JSON
                                    .toList());
                        if (controller.invoiceItemsList.isNotEmpty) {
                          if (await isWithinDistance(
                              gpsLocation:
                                  controller.customerModel!.gpsLocation!)) {
                            controller.saveInvoice(apiInvoiceModel);
                            controller.invoiceItemsList.clear();
                            controller.apiInvoiceItemList.clear();
                            controller.invoiceNote.clear();
                            controller.resetValues();
                            Get.offNamed('/index-screen');
                            controller.addItemDropDownCustomer(
                                CustomerModel(custName: 'Choose Customer'.tr));
                            controller.isCustomerChosen(false);
                          } else {
                            AppToasts.errorToast(
                                'You have to be within 500 meters range from client'
                                    .tr);
                          }
                        } else {
                          AppToasts.errorToast(
                              'Please add items before saving'.tr);
                        }
                      } else {
                        AppToasts.errorToast('Unrecognized Location'.tr);
                      }
                    } catch (e) {
                      AppToasts.errorToast('Please add items before saving'.tr);
                    }
                  },
                  child: Text(
                    'Save'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(50), // Rounded corners
                    ),
                  ),
                  onPressed: () async {
                    printScreen(invoiceItems: controller.invoiceItemsList);
                  },
                  child: Text(
                    'Print'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        endDrawer: const CustomDrawer(),
      ),
    );
  }
}

Widget isCashDropDown(int payType) {
  return Card(
    child: DropdownSearch<String>(
      items: ['Cash'.tr, 'Credit'.tr],
      selectedItem: 'Select pay type'.tr,
      onChanged: (value) async {
        if (value == 'Cash'.tr) {
          payType = 1;
        } else {
          payType = 0;
        }
      },
    ),
  );
}
