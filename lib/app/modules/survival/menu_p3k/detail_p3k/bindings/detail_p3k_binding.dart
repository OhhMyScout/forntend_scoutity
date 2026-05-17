import 'package:get/get.dart';
import '../controllers/detail_p3k_controller.dart';

class DetailP3KBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailP3KController>(
      () => DetailP3KController(),
    );
  }
}