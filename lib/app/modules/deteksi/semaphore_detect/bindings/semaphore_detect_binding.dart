import 'package:get/get.dart';
import '../controllers/semaphore_detect_controller.dart';

class SemaphoreDetectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SemaphoreDetectController>(
      () => SemaphoreDetectController(),
    );
  }
}