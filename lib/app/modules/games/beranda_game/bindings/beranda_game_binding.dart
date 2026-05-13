import 'package:get/get.dart';
import '../controllers/beranda_game_controller.dart';

class BerandaGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BerandaGameController>(() => BerandaGameController());
  }
}