import 'package:get/get.dart';

import '../controllers/beranda_sku_admin_controller.dart';

class BerandaSkuAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaSkuAdminController>(
      () => BerandaSkuAdminController(),
    );
  }
}
