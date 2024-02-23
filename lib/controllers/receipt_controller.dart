import 'package:get/get.dart';

import '../custom_widgets/date_filters.dart';

class ReceiptController extends GetxController {
  Rx<DateTime> dateFromFilter = DateTime.now().obs;
  Rx<DateTime> dateToFilter = DateTime.now().obs;

  @override
  void onInit() {
    dateFromFilter.value = firstOfJanuaryLastYear();
    super.onInit();
  }
}
