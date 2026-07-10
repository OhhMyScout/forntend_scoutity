import 'package:get/get.dart';

import '../controllers/info_logs_controller.dart';

class InfoLogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfoLogsController>(
      () => InfoLogsController(),
    );
  }
}
