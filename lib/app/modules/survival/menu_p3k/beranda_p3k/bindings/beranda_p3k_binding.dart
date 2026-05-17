import 'package:get/get.dart';
import '../controllers/beranda_p3k_controller.dart';

class BerandaP3KBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaP3KController>(
      () => BerandaP3KController(),
    );
  }
}