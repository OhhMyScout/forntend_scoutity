import 'package:get/get.dart';

import '../controllers/uji_sku_controller.dart';

class UjiSkuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UjiSkuController>(
      () => UjiSkuController(),
    );
  }
}
