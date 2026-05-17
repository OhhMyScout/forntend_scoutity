import 'package:get/get.dart';

import '../controllers/detail_tali_controller.dart';

class DetailTaliBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTaliController>(
      () => DetailTaliController(),
    );
  }
}
