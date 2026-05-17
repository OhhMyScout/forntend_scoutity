import 'package:get/get.dart';

import '../controllers/panduan_tenda_controller.dart';

class PanduanTendaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PanduanTendaController>(
      () => PanduanTendaController(),
    );
  }
}
