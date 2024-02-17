import 'package:eit/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25.0),
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: controller.homeElements.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) => homeTile(
                  image: controller.homeElements[index].values.first,
                  name: controller.homeElements[index].keys.first,
                )),
      ),
    );
  }
}

Widget homeTile({required String image, required String name}) {
  final homeController = Get.find<HomeController>();
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: InkWell(
      onTap: () {
        switch (name) {
          case 'Sales':
            homeController.navigateToTab(1);
            break;
          case 'Customers':
            homeController.navigateToTab(2);
            break;
          case 'Stock':
            Get.toNamed('');
            break;
          case 'Reports':
            homeController.navigateToTab(3);
            break;
          case 'Receipt Vouchers':
            Get.toNamed('');
            break;
          case 'Visits Plans':
            Get.toNamed('');
            break;
        }
      },
      child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                height: 50,
                width: 50,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(name.tr)
            ],
          )),
    ),
  );
}
