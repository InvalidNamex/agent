import 'package:eit/constants.dart';
import 'package:eit/controllers/visits_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisitsScreen extends GetView<VisitsController> {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Routes'.tr,
            style: const TextStyle(color: darkColor),
          ),
          centerTitle: true,
        ),
        body: ListView.separated(
          itemBuilder: (context, index) => Card(
              child: ExpansionTile(
            title: Text(
                controller.customersListByRoute[index].custName.toString()),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  customTile(
                      image: 'assets/images/colored_sells_card.png',
                      name: 'Sales'.tr,
                      onPress: () {
                        Get.toNamed('/new-invoice', arguments: {
                          'custName': controller
                              .customersListByRoute[index].custName
                              .toString()
                        });
                      }),
                  customTile(
                      image: 'assets/images/colored_payment_card.png',
                      name: 'Receipt Vouchers'.tr,
                      onPress: () {
                        Get.toNamed('/new-invoice', arguments: {
                          'custName': controller
                              .customersListByRoute[index].custName
                              .toString()
                        });
                      }),
                  customTile(
                      image: 'assets/images/drawer_sells.png',
                      name: 'Returns'.tr,
                      onPress: () {
                        Get.toNamed('/new-invoice', arguments: {
                          'custName': controller
                              .customersListByRoute[index].custName
                              .toString()
                        });
                      }),
                  customTile(
                      image: 'assets/images/visits_card.png',
                      name: 'Negative Visit'.tr,
                      onPress: () {}),
                ],
              )
            ],
          )),
          separatorBuilder: (BuildContext context, int index) => const SizedBox(
            height: 5,
          ),
          shrinkWrap: true,
          itemCount: controller.customersListByRoute.length,
        ));
  }
}

Widget customTile(
    {required String image, required String name, required onPress}) {
  return InkWell(
    onTap: onPress,
    child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 25,
                width: 25,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(name.tr)
            ],
          ),
        )),
  );
}
