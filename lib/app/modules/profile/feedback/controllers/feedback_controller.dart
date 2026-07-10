import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {

  /// Message Controller
  final TextEditingController messageController =
      TextEditingController();

  /// Rating
  final rating = 0.obs;

  /// Selected Category
  final selectedCategory = 'bug'.obs;

  /// Change Rating
  void setRating(int value) {
    rating.value = value;
  }

  /// Change Category
  void selectCategory(String value) {
    selectedCategory.value = value;
  }

  /// Submit Feedback
  void submitFeedback() {

    final message =
        messageController.text.trim();

    if (message.isEmpty) {

      Get.snackbar(
        'Peringatan',
        'Pesan tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Get.snackbar(
      'Berhasil',
      'Feedback berhasil dikirim',
      snackPosition: SnackPosition.BOTTOM,
    );

    debugPrint('Kategori : ${selectedCategory.value}');
    debugPrint('Rating   : ${rating.value}');
    debugPrint('Pesan    : $message');

    /// Reset
    messageController.clear();
    rating.value = 0;
    selectedCategory.value = 'bug';
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}