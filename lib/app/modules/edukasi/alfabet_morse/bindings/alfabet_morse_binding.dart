import 'package:get/get.dart';

import '../controllers/alfabet_morse_controller.dart';

class AlfabetMorseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlfabetMorseController>(
      () => AlfabetMorseController(),
    );
  }
}
