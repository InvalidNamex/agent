import 'dart:ui';

import 'package:eit/constants.dart';
import 'package:eit/screens/new_receipt.dart';
import 'package:eit/screens/receipt_screen.dart';
import 'package:eit/screens/stock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/screens/home_screen.dart';
import '/screens/index_screen.dart';
import '/screens/login_screen.dart';
import '/screens/new_customer.dart';
import '/screens/new_invoice.dart';
import '/screens/splash_screen.dart';
import 'bindings.dart';
import 'localization_hierarchy/lanugages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Get.deviceLocale,
      translations: Languages(),
      fallbackLocale: const Locale('en', 'US'),
      title: 'EIT',
      initialRoute: '/',
      enableLog: true,
      theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Cairo',
          appBarTheme: const AppBarTheme(backgroundColor: lightColor)),
      logWriterCallback: (text, {isError = false}) {
        if (isError) {
          Get.defaultDialog(
              title: 'Error',
              content: Text(
                text,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ));
        } else {}
      },
      // fallbackLocale: const Locale('ar', 'EG'),
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      initialBinding: AuthBinding(),
      getPages: [
        GetPage(
            name: '/',
            page: () => const SplashScreen(),
            binding: AuthBinding(),
            transition: Transition.fadeIn,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/login-screen',
            page: () => const LoginScreen(),
            binding: AuthBinding(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/index-screen',
            page: () => const IndexScreen(),
            binding: HomeBinding(),
            transition: Transition.fadeIn,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/home-screen',
            page: () => const HomeScreen(),
            binding: HomeBinding(),
            transition: Transition.rightToLeft,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/receipt-screen',
            page: () => const ReceiptScreen(),
            binding: HomeBinding(),
            transition: Transition.leftToRight,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/stock-screen',
            page: () => const StockScreen(),
            binding: HomeBinding(),
            transition: Transition.upToDown,
            transitionDuration: const Duration(milliseconds: 200)),
        GetPage(
            name: '/new-invoice',
            page: () => const NewInvoice(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/new-customer',
            page: () => NewCustomer(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/new-receipt',
            page: () => const NewReceipt(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
      ],
    );
  }
}
