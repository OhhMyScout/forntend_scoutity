import 'package:get/get.dart';
import '../controllers/kotak2_challenge_controller.dart';

class Kotak2ChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Kotak2ChallengeController>(
      () => Kotak2ChallengeController(),
    );
  }
}