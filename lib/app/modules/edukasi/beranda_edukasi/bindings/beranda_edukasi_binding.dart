import 'package:get/get.dart';

import '../controllers/beranda_edukasi_controller.dart';

class BerandaEdukasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaEdukasiController>(
      () => BerandaEdukasiController(),
    );
  }
}
