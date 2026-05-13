import 'package:get/get.dart';

class SemaphoreDetectController extends GetxController {

  final detectedLetter = 'A'.obs;
  final accuracy = 98.obs;

  final isAnalyzing = true.obs;

  void captureImage() {
    Get.snackbar(
      'Capture',
      'Gambar berhasil diambil',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateDetection(String letter, int percent) {
    detectedLetter.value = letter;
    accuracy.value = percent;
  }
}