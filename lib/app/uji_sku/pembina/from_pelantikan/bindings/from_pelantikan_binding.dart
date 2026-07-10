import 'package:get/get.dart';

import '../controllers/from_pelantikan_controller.dart';

class FromPelantikanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FromPelantikanController>(
      () => FromPelantikanController(),
    );
  }
}
