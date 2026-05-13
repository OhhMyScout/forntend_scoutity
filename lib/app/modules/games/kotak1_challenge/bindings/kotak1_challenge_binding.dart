import 'package:get/get.dart';

import '../controllers/kotak1_challenge_controller.dart';

class Kotak1ChallengeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Kotak1ChallengeController>(
      () => Kotak1ChallengeController(),
    );
  }
}