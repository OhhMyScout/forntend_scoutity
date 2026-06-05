import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../data/bank_soal_kotak1.dart';
import '../models/kotak1_question.dart';

import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart';

enum GameResultStatus { win, lose, timeout }

class Kotak1ChallengeController extends GetxController {
  var questions = <Kotak1Question>[].obs;

  var index = 0.obs;
  var score = 0.obs;
  var timeLeft = 40.obs;

  var selectedAnswer = ''.obs;
  var isAnswered = false.obs;
  var isSavingScore = false.obs;

  var shuffledOptions = <String>[].obs;

  Timer? _timer;

  Kotak1Question get current => questions[index.value];

  @override
  void onInit() {
    super.onInit();
    startGame();
  }

  // =====================================================
  // GAME START
  // =====================================================
  void startGame() {
    _timer?.cancel();

    index.value = 0;
    score.value = 0;
    timeLeft.value = 40;

    selectedAnswer.value = '';
    isAnswered.value = false;
    isSavingScore.value = false;

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

  // =====================================================
  // TIMER
  // =====================================================
  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        timer.cancel();
        _handleGameEnd(
          status: GameResultStatus.timeout,
          title: "WAKTU HABIS!",
          message: "Kamu kehabisan waktu.",
        );
      }
    });
  }

  // =====================================================
  // ANSWER LOGIC
  // =====================================================
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
        _handleGameEnd(
          status: GameResultStatus.lose,
          title: "KAMU KALAH",
          message: "Aduh, skor kamu mencapai minus. Banyakin belajar lagi ya!",
        );
        return;
      }
    }

    Future.delayed(const Duration(milliseconds: 700), nextQuestion);
  }

  void nextQuestion() {
    if (index.value < questions.length - 1) {
      index.value++;
      loadQuestion();
    } else {
      _timer?.cancel();
      _handleGameEnd(
        status: GameResultStatus.win,
        title: "LUAR BIASA!",
        message: "Kamu berhasil menyelesaikan semua soal Sandi Kotak 1.",
      );
    }
  }

  // =====================================================
  // END GAME + SAVE SCORE (FIXED)
  // =====================================================
  Future<void> _handleGameEnd({
    required GameResultStatus status,
    required String title,
    required String message,
  }) async {
    _timer?.cancel();

    isSavingScore.value = true;

    try {
      final token = SessionManager.token ?? '';

      // DEBUG (penting)
      debugPrint("TOKEN CHECK: $token");

      if (token.isEmpty) {
        debugPrint("SKIP SAVE SCORE (NO TOKEN)");
        _showResultDialog(status: status, title: title, message: message);
        return;
      }

      if (score.value <= 0) {
        debugPrint("SKIP SAVE SCORE (SCORE <= 0)");
        _showResultDialog(status: status, title: title, message: message);
        return;
      }

      final response = await http.post(
        Uri.parse(ApiEndpoint.submitScore),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "game_name": "sandi_kotak_1",
          "score": score.value,
        }),
      );

      debugPrint("SUBMIT SCORE STATUS: ${response.statusCode}");
      debugPrint("SUBMIT SCORE BODY: ${response.body}");

    } catch (e) {
      debugPrint("ERROR SAVE SCORE: $e");
    } finally {
      isSavingScore.value = false;

      if (Get.isDialogOpen == true) Get.back();

      _showResultDialog(
        status: status,
        title: title,
        message: message,
      );
    }
  }

  // =====================================================
  // RESULT UI (SAMA DENGAN GAME LAINNYA)
  // =====================================================
  void _showResultDialog({
    required GameResultStatus status,
    required String title,
    required String message,
  }) {
    Color headerColor;
    Color iconColor;
    IconData iconData;
    String actionText;

    switch (status) {
      case GameResultStatus.win:
        headerColor = Colors.green.shade50;
        iconColor = Colors.green;
        iconData = Icons.emoji_events_rounded;
        actionText = "Main Lagi";
        break;
      case GameResultStatus.timeout:
        headerColor = Colors.orange.shade50;
        iconColor = Colors.orange;
        iconData = Icons.timer_off_rounded;
        actionText = "Ulangi";
        break;
      case GameResultStatus.lose:
        headerColor = Colors.red.shade50;
        iconColor = Colors.red;
        iconData = Icons.cancel_rounded;
        actionText = "Coba Lagi";
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
                      child: Icon(iconData, size: 56, color: iconColor),
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
                            child: Text(
                              actionText,
                              style: const TextStyle(
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

  // =========================================================
  // KELUAR DARI PERMAINAN (BACK DENGAN KONFIRMASI)
  // =========================================================
  void onBack() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.exit_to_app_rounded, color: Colors.red, size: 40),
              ),
              const SizedBox(height: 20),
              const Text(
                "Yakin Ingin Keluar?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF361F1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Jika kamu keluar sekarang, poin yang telah kamu kumpulkan pada sesi ini tidak akan disimpan.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  color: Color(0xFF504442),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFD4C3BF), width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Batal",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF827471),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _timer?.cancel();
                        Get.offAllNamed('/beranda-game');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Keluar",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}