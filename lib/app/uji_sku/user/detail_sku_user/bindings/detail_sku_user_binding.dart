import 'package:get/get.dart';

import '../controllers/detail_sku_user_controller.dart';

class DetailSkuUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailSkuUserController>(
      () => DetailSkuUserController(),
    );
  }
}
