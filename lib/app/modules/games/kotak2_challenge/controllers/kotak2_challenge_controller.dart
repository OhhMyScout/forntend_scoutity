import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Kotak2ChallengeController extends GetxController {

  final currentIndex = 1.obs;

  final answer = 'A__'.obs;

  final String correctAnswer = 'API';

  final timeLeft = 45.obs;

  final List<String> keyboardRows = [
    'QWERTYUIOP',
    'ASDFGHJKL',
    'ZXCVBNM',
  ];

  void addLetter(String letter) {

    List<String> chars =
        answer.value.split('');

    for (int i = 0; i < chars.length; i++) {

      if (chars[i] == '_') {

        chars[i] = letter;
        break;
      }
    }

    answer.value = chars.join();
  }

  void removeLetter() {

    List<String> chars =
        answer.value.split('');

    for (int i = chars.length - 1; i >= 0; i--) {

      if (chars[i] != '_') {

        chars[i] = '_';
        break;
      }
    }

    chars[0] = 'A';

    answer.value = chars.join();
  }

  void checkAnswer() {

    if (answer.value == correctAnswer) {

      Get.snackbar(
        'Berhasil',
        'Jawaban benar!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

    } else {

      Get.snackbar(
        'Salah',
        'Jawaban masih belum tepat',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}