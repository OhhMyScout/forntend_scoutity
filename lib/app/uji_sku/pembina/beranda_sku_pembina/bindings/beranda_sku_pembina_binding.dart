import 'package:get/get.dart';

import '../controllers/beranda_sku_pembina_controller.dart';

class BerandaSkuPembinaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaSkuPembinaController>(
      () => BerandaSkuPembinaController(),
    );
  }
}
