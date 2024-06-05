import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/constants.dart';
import '/screens/home_screen.dart';
import '/screens/index_screen.dart';
import '/screens/login_screen.dart';
import '/screens/new_customer.dart';
import '/screens/new_invoice.dart';
import '/screens/new_receipt.dart';
import '/screens/receipt_screen.dart';
import '/screens/reports_screens/reports_screen.dart';
import '/screens/splash_screen.dart';
import '/screens/stock_screen.dart';
import '/screens/visits_screen.dart';
import 'bindings.dart';
import 'localization_hierarchy/lanugages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //! this class overrides the check for certificate validation and logs user in even with expired certificate
  HttpOverrides.global = MyHttpOverrides();
  // await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
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
    Locale? defaultLocale = Get.deviceLocale;
    return GetMaterialApp(
      locale: const Locale('en', 'US'),
      translations: Languages(),
      fallbackLocale: const Locale('en', 'US'),
      textDirection: TextDirection.ltr,
      title: 'EIT',
      initialRoute: '/',
      enableLog: true,
      theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Cairo',
          appBarTheme: const AppBarTheme(
              backgroundColor: lightColor,
              iconTheme: IconThemeData(color: darkColor))),
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
        GetPage(
            name: '/reports-screen',
            page: () => const ReportsScreen(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
        GetPage(
            name: '/visits-screen',
            page: () => const VisitsScreen(),
            binding: HomeBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 300)),
      ],
    );
  }
}
