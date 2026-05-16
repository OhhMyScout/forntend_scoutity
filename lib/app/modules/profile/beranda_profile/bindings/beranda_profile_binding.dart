// lib/app/modules/profile/beranda_profile/bindings/beranda_profile_binding.dart

import 'package:get/get.dart';

import '../controllers/beranda_profile_controller.dart';

class BerandaProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaProfileController>(
      () => BerandaProfileController(),
    );
  }
}