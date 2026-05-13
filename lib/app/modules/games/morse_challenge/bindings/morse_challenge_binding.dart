import 'package:get/get.dart';
import '../controllers/morse_challenge_controller.dart';

class MorseChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MorseChallengeController>(() => MorseChallengeController());
  }
}