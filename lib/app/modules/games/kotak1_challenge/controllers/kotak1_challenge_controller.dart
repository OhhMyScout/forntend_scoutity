import 'package:get/get.dart';

class Kotak1ChallengeController extends GetxController {

  final currentQuestion = 3.obs;
  final totalQuestion = 10.obs;

  final timeLeft = 45.obs;

  final selectedAnswer = ''.obs;

  void selectAnswer(String answer) {
    selectedAnswer.value = answer;
  }

  void useHint() {
    Get.snackbar(
      'Hint',
      'Petunjuk digunakan!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void useFiftyFifty() {
    Get.snackbar(
      '50/50',
      'Dua jawaban dihapus!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}