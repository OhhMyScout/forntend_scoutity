import 'package:get/get.dart';
import '../controllers/beranda_sku_controller.dart';

class BerandaSkuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaSkuController>(
      () => BerandaSkuController(),
    );
  }
}