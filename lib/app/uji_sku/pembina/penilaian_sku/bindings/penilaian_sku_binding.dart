import 'package:get/get.dart';

import '../controllers/penilaian_sku_controller.dart';

class PenilaianSkuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenilaianSkuController>(
      () => PenilaianSkuController(),
    );
  }
}
