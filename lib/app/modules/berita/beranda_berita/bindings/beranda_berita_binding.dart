import 'package:get/get.dart';

import '../controllers/beranda_berita_controller.dart';

class BerandaBeritaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaBeritaController>(
      () => BerandaBeritaController(),
    );
  }
}
