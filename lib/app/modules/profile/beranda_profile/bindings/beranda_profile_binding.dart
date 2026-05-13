import 'package:get/get.dart';
import '../controllers/beranda_profile_controller.dart';

class BerandaProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaProfileController>(() => BerandaProfileController());
  }
}