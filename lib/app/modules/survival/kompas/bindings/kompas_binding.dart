/// lib/app/modules/kompas/bindings/kompas_binding.dart

import 'package:get/get.dart';

import '../controllers/kompas_controller.dart';

class KompasBinding extends Bindings {

  @override
  void dependencies() {

    Get.lazyPut<KompasController>(
      () => KompasController(),
    );
  }
}