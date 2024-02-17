import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

Future<String> barcodeScanner() async {
  var status = await Permission.camera.status;
  status = await Permission.camera.request();
  if (status.isGranted) {
    var res = await Get.to<String>(const SimpleBarcodeScannerPage());
    if (res != null) {
      return res;
    } else {
      return 'failed to read'.tr;
    }
  } else {
    Get.snackbar('Camera Inaccessible'.tr,
        'We cannot access camera now, please try again'.tr);
    return 'failed to read'.tr;
  }
}
