import 'package:get/get.dart';

import '../controllers/bertahan_hidup_controller.dart';

class BertahanHidupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BertahanHidupController>(
      () => BertahanHidupController(),
    );
  }
}
