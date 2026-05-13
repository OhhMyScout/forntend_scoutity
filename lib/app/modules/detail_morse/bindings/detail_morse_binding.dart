import 'package:get/get.dart';

import '../controllers/detail_morse_controller.dart';

class DetailMorseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailMorseController>(
      () => DetailMorseController(),
    );
  }
}
