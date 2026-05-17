import 'package:get/get.dart';

import '../controllers/tabel_berita_paling_populer_controller.dart';

class TabelBeritaPalingPopulerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabelBeritaPalingPopulerController>(
      () => TabelBeritaPalingPopulerController(),
    );
  }
}
