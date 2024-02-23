import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eit/helpers/toast.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  RxString connectionStatus = 'unknown'.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus.value = "wifi";
        AppToasts.successToast('Connected to WiFi');
        break;
      case ConnectivityResult.mobile:
        connectionStatus.value = "data";
        AppToasts.successToast('Connected to Mobile Data');
        break;
      case ConnectivityResult.none:
        connectionStatus.value = "lost";
        AppToasts.errorToast('Internet connection lost');
        break;
      default:
        connectionStatus.value = "unknown";
        AppToasts.errorToast('Internet status unknown');
        break;
    }
  }
}
// add this package to pubspec.yaml
// flutter pub add connectivity_plus
//https://pub.dev/packages/connectivity_plus
