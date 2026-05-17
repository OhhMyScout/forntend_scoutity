import 'package:get/get.dart';

import '../controllers/sinyal_darurat_controller.dart';

class SinyalDaruratBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SinyalDaruratController>(
      () => SinyalDaruratController(),
    );
  }
}
