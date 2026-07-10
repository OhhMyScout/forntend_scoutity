import 'package:get/get.dart';

import '../controllers/daftar_antrian_validasi_controller.dart';

class DaftarAntrianValidasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaftarAntrianValidasiController>(
      () => DaftarAntrianValidasiController(),
    );
  }
}
