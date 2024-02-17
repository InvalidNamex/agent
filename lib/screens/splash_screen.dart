import 'package:eit/constants.dart';
import 'package:eit/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/location_service.dart';

class SplashScreen extends GetView<AuthController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void handlePermissions() async {
      bool hasLocationPermission = await LocationService().checkPermission();

      if (hasLocationPermission) {
        bool userCredentials = await controller.readUserFromPrefs();
        if (userCredentials) {
          Get.offNamed('/index-screen');
        } else {
          Get.offNamed('/login-screen');
        }
      }
    }

    // Call the local function without using BuildContext after the async gap
    Future.delayed(const Duration(seconds: 1), handlePermissions);

    return Scaffold(
      backgroundColor: lightColor,
      body: Center(
        child: Image.asset('assets/logo.jpeg'),
      ),
    );
  }
}
