import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/bank_soal_kotak1.dart';
import '../models/kotak1_question.dart';

class Kotak1ChallengeController extends GetxController {
  var questions = <Kotak1Question>[].obs;

  var index = 0.obs;
  var score = 0.obs;
  var timeLeft = 40.obs;

  var selectedAnswer = ''.obs;
  var isAnswered = false.obs;

  var shuffledOptions = <String>[].obs;
  
  Timer? _timer;

  Kotak1Question get current => questions[index.value];

  @override
  void onInit() {
    super.onInit();
    startGame();
  }

  void startGame() {
    _timer?.cancel(); 
    index.value = 0;
    score.value = 0;
    timeLeft.value = 40;
    selectedAnswer.value = '';
    isAnswered.value = false;

    var allQuestions = [...BankSoalKotak1.questions]..shuffle(Random());
    questions.value = allQuestions.take(10).toList();

    loadQuestion();
    startTimer();
  }

  void loadQuestion() {
    selectedAnswer.value = '';
    isAnswered.value = false;

    if (questions.isNotEmpty) {
      shuffledOptions.value = [...current.options]..shuffle(Random());
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        _timer?.cancel();
        _showResultDialog(
          status: GameResultStatus.timeout,
          title: "WAKTU HABIS!",
          message: "Kamu kehabisan waktu. Mari berlatih lebih cepat lagi!",
        );
      }
    });
  }

  void selectAnswer(String answer) {
    if (isAnswered.value) return;

    selectedAnswer.value = answer;
    isAnswered.value = true;

    if (answer == current.correctAnswer) {
      score.value += 2;
    } else {
      score.value -= 1;

      if (score.value < 0) {
        _timer?.cancel();
        _showResultDialog(
          status: GameResultStatus.lose,
          title: "YAH, KAMU KALAH!",
          message: "Skor kamu turun di bawah 0. Jangan menyerah, ayo coba lagi!",
        );
        return;
      }
    }

    Future.delayed(const Duration(milliseconds: 800), nextQuestion);
  }

  void nextQuestion() {
    if (index.value < questions.length - 1) {
      index.value++;
      loadQuestion();
    } else {
      _timer?.cancel();
      _showResultDialog(
        status: GameResultStatus.win,
        title: "LUAR BIASA!",
        message: "Kamu berhasil menyelesaikan seluruh tantangan sandi!",
      );
    }
  }

  void _showResultDialog({
    required GameResultStatus status,
    required String title,
    required String message,
  }) {
    Color headerColor;
    Color iconColor;
    IconData iconData;

    switch (status) {
      case GameResultStatus.win:
        headerColor = Colors.green.shade50;
        iconColor = Colors.green;
        iconData = Icons.emoji_events_rounded;
        break;
      case GameResultStatus.lose:
        headerColor = Colors.red.shade50;
        iconColor = Colors.red;
        iconData = Icons.sentiment_dissatisfied_rounded;
        break;
      case GameResultStatus.timeout:
        headerColor = Colors.orange.shade50;
        iconColor = Colors.orange;
        iconData = Icons.timer_off_rounded;
        break;
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          tween: Tween<double>(begin: 0.6, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: const Color(0xFFEBE8E3), 
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF361F1A).withValues(alpha: 0.15),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: headerColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        iconData,
                        size: 56,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF361F1A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        color: Color(0xFF504442),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCA98),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF7A532A).withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "TOTAL SKOR KAMU",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              letterSpacing: 1.2,
                              color: Color(0xFF7A532A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${score.value}",
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              height: 1.0,
                              color: Color(0xFF7A532A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // PERBAIKAN: Gunakan tanda hubung sesuai _Paths
                              Get.offAllNamed('/beranda-game');
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Color(0xFF361F1A), width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Beranda",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF361F1A),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                              startGame();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF361F1A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Main Lagi",
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  void gameOver({required bool isTimeOut}) {
    _timer?.cancel();
    // PERBAIKAN: Gunakan tanda hubung sesuai _Paths
    Get.offAllNamed('/beranda-game');
    Get.snackbar(
      isTimeOut ? "Waktu Habis!" : "Game Selesai", 
      "Skor akhir: ${score.value}",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

enum GameResultStatus { win, lose, timeout }