import 'package:get/get.dart';

import '../controllers/alfabet_semaphore_controller.dart';

class AlfabetSemaphoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlfabetSemaphoreController>(
      () => AlfabetSemaphoreController(),
    );
  }
}