import 'package:get/get.dart';

import '../controllers/tabel_berita_provinsi_controller.dart';

class TabelBeritaProvinsiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabelBeritaProvinsiController>(
      () => TabelBeritaProvinsiController(),
    );
  }
}
