import 'package:get/get.dart';

import '../controllers/daftar_pembina_controller.dart';

class DaftarPembinaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaftarPembinaController>(
      () => DaftarPembinaController(),
    );
  }
}
