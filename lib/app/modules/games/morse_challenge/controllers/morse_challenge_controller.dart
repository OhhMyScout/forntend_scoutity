import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MorseChallengeController extends GetxController {
  final answerController = TextEditingController();
  
  // Observables
  var streak = 5.obs;
  var timer = "00:45".obs;
  var currentQuestion = 8.obs;
  var totalQuestions = 10.obs;
  var points = 1240.obs;
  var accuracy = 94.obs;
  
  // Urutan sinyal saat ini
  final List<String> currentMorseSequence = [".", "-", "."];

  void repeatSignal() {
    print("Mengulangi sinyal morse...");
  }

  void submitAnswer() {
    print("Jawaban dikirim: ${answerController.text}");
    // Logika validasi jawaban di sini
  }

  void clearAnswer() {
    answerController.clear();
  }

  void back() => Get.back();

  @override
  void onClose() {
    answerController.dispose();
    super.onClose();
  }
}