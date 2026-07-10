import 'package:get/get.dart';

import '../controllers/form_pembina_controller.dart';

class FormPembinaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormPembinaController>(
      () => FormPembinaController(),
    );
  }
}
