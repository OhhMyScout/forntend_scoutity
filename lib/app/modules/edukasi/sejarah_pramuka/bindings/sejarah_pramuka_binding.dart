import 'package:get/get.dart';

import '../controllers/sejarah_pramuka_controller.dart';

class SejarahPramukaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SejarahPramukaController>(
      () => SejarahPramukaController(),
    );
  }
}
