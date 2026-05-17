import 'package:get/get.dart';
import '../controllers/tali_temali_controller.dart';

class TaliTemaliBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaliTemaliController>(
      () => TaliTemaliController(),
    );
  }
}