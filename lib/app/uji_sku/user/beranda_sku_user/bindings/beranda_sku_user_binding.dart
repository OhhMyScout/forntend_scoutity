import 'package:get/get.dart';

import '../controllers/beranda_sku_user_controller.dart';

class BerandaSkuUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaSkuUserController>(
      () => BerandaSkuUserController(),
    );
  }
}
