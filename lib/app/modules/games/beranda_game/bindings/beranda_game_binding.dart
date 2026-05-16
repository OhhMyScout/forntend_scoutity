// lib/app/modules/beranda_game/bindings/beranda_game_binding.dart

import 'package:get/get.dart';

import '../controllers/beranda_game_controller.dart';

class BerandaGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaGameController>(
      () => BerandaGameController(),
    );
  }
}