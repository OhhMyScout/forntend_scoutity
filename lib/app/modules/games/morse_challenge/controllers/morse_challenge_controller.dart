// lib/app/modules/games/morse_challenge/controllers/morse_challenge_controller.dart

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MorseChallengeController extends GetxController {
  // =========================================================
  // OBS
  // =========================================================

  final currentQuestion = 1.obs;
  final totalQuestion = 10.obs;
  final score = 0.obs;

  final currentWord = ''.obs;
  final currentLetterIndex = 0.obs;
  final currentInput = ''.obs;

  final gameStarted = false.obs;

  // =========================================================
  // MODE
  // =========================================================

  final gameMode = "easy".obs;
  final showHint = true.obs;

  // =========================================================
  // TIMER HARD MODE
  // =========================================================

  final timer = 90.obs;

  Timer? countdownTimer;

  // =========================================================
  // POINT PER MODE
  // =========================================================

  int get pointPerQuestion {
    switch (gameMode.value) {
      case "easy":
        return 2;

      case "hard":
        return 25;

      default:
        return 10;
    }
  }

  // =========================================================
  // MORSE MAP
  // =========================================================

  final Map<String, String> morseMap = {
    "A": ".-",
    "B": "-...",
    "C": "-.-.",
    "D": "-..",
    "E": ".",
    "F": "..-.",
    "G": "--.",
    "H": "....",
    "I": "..",
    "J": ".---",
    "K": "-.-",
    "L": ".-..",
    "M": "--",
    "N": "-.",
    "O": "---",
    "P": ".--.",
    "Q": "--.-",
    "R": ".-.",
    "S": "...",
    "T": "-",
    "U": "..-",
    "V": "...-",
    "W": ".--",
    "X": "-..-",
    "Y": "-.--",
    "Z": "--..",
  };

  // =========================================================
  // DATABASE SOAL
  // =========================================================

  final List<String> allWords = [
    "SCOUT",
    "PRAMUKA",
    "MORSE",
    "SEMAPHORE",
    "SURVIVAL",
    "KEMAH",
    "TANDU",
    "REGU",
    "API",
    "HIKING",
    "JELAJAH",
    "SANDI",
    "TALI",
    "KOMPAS",
    "PELUIT",
    "BARUNG",
    "PENGGALANG",
    "SIAGA",
    "PENEGAK",
    "AMBALAN",
    "KEMAHAN",
    "PETA",
    "PIONERING",
    "RANSEL",
    "KAKI",
    "HUTAN",
    "ALAM",
    "TIM",
    "LATIHAN",
    "DISIPLIN",
    "MANDIRI",
    "TANGGUH",
    "BERANI",
    "SATYA",
    "DARMA",
    "KEGIATAN",
    "JAMBORE",
    "NASIONAL",
    "PETUALANG",
    "KREATIF",
    "AKTIF",
    "CERDAS",
    "HEBAT",
    "TANGKAS",
    "SIGAP",
    "KOMPAK",
    "SAHABAT",
    "BINTANG",
    "PELANTIKAN",
    "KETUA",
    "ANGGOTA",
    "LENCANA",
    "UPACARA",
    "PENOLONG",
    "PERSAUDARAAN",
    "KEPEMIMPINAN",
    "BARU",
    "MERDEKA",
    "INDONESIA",
    "GARUDA",
    "PANCASILA",
    "SEMANGAT",
    "JUJUR",
    "TULUS",
    "RAJIN",
    "SOPAN",
    "HEMAT",
    "TEPAT",
    "CEPAT",
    "KUAT",
    "LATIH",
    "GERAK",
  ];

  // =========================================================
  // RANDOM QUESTION
  // =========================================================

  final List<String> selectedQuestions = [];

  // =========================================================
  // INIT
  // =========================================================

  @override
  void onInit() {
    super.onInit();

    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        showModeDialog();
      },
    );
  }

  @override
  void onClose() {
    stopTimer();

    super.onClose();
  }

  // =========================================================
  // PROGRESS
  // =========================================================

  double get progress =>
      currentQuestion.value / totalQuestion.value;

  // =========================================================
  // START GAME
  // =========================================================

  void startGame(String mode) {
    gameMode.value = mode;

    if (mode == "easy") {
      showHint.value = true;
    } else if (mode == "normal") {
      showHint.value = true;
    } else {
      showHint.value = false;
    }

    gameStarted.value = true;

    restartGame();
  }

  // =========================================================
  // HIDE MORSE
  // =========================================================

  bool shouldHideMorse() {
    return !showHint.value;
  }

  // =========================================================
  // TIMER
  // =========================================================

  void startTimer() {
    countdownTimer?.cancel();

    timer.value = 90;

    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (countdown) {
        timer.value--;

        if (timer.value <= 0) {
          countdown.cancel();

          onTimeOut();
        }
      },
    );
  }

  void stopTimer() {
    countdownTimer?.cancel();
  }

  // =========================================================
  // TIME OUT
  // =========================================================

  void onTimeOut() {
    HapticFeedback.heavyImpact();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.timer_off_rounded,
                size: 80,
                color: Colors.red,
              ),

              const SizedBox(height: 20),

              const Text(
                "Waktu Habis",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Game diulang dari awal\nScore menjadi 0",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();

                    resetHardModeGame();
                  },
                  child: const Text("Ulangi"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // =========================================================
  // RESET HARD MODE
  // =========================================================

  void resetHardModeGame() {
    stopTimer();

    score.value = 0;

    currentQuestion.value = 1;

    currentLetterIndex.value = 0;

    currentInput.value = '';

    generateQuestions();

    loadQuestion();

    startTimer();
  }

  // =========================================================
  // GENERATE QUESTION
  // =========================================================

  void generateQuestions() {
    final random = Random();

    final shuffled = [...allWords];

    shuffled.shuffle(random);

    selectedQuestions.clear();

    selectedQuestions.addAll(
      shuffled.take(totalQuestion.value),
    );
  }

  // =========================================================
  // LOAD QUESTION
  // =========================================================

  void loadQuestion() {
    currentWord.value =
        selectedQuestions[
                currentQuestion.value - 1]
            .toUpperCase();

    currentLetterIndex.value = 0;

    currentInput.value = '';

    // =====================================================
    // NORMAL MODE
    // =====================================================

    if (gameMode.value == "normal") {
      showHint.value =
          currentQuestion.value <= 5;
    }

    // =====================================================
    // HARD TIMER
    // =====================================================

    if (gameMode.value == "hard") {
      startTimer();
    }
  }

  // =========================================================
  // INPUT DOT
  // =========================================================

  void inputDot() {
    HapticFeedback.lightImpact();

    currentInput.value += '.';

    checkCurrentLetter();
  }

  // =========================================================
  // INPUT DASH
  // =========================================================

  void inputDash() {
    HapticFeedback.lightImpact();

    currentInput.value += '-';

    checkCurrentLetter();
  }

  // =========================================================
  // DELETE INPUT
  // =========================================================

  void deleteInput() {
    if (currentInput.value.isNotEmpty) {
      currentInput.value =
          currentInput.value.substring(
        0,
        currentInput.value.length - 1,
      );
    }
  }

  // =========================================================
  // CHECK LETTER
  // =========================================================

  void checkCurrentLetter() {
    final word = currentWord.value;

    if (currentLetterIndex.value >=
        word.length) {
      return;
    }

    final letter =
        word[currentLetterIndex.value];

    final correctMorse =
        morseMap[letter] ?? '';

    final input = currentInput.value;

    // =====================================================
    // WRONG
    // =====================================================

    if (!correctMorse.startsWith(input)) {
      HapticFeedback.heavyImpact();

      Get.snackbar(
        "Salah",
        "Kode morse tidak sesuai",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration:
            const Duration(milliseconds: 700),
      );

      currentInput.value = '';

      return;
    }

    // =====================================================
    // CORRECT
    // =====================================================

    if (input == correctMorse) {
      HapticFeedback.mediumImpact();

      currentLetterIndex.value++;

      currentInput.value = '';

      // ===================================================
      // WORD FINISH
      // ===================================================

      if (currentLetterIndex.value >=
          word.length) {
        score.value += pointPerQuestion;

        Future.delayed(
          const Duration(milliseconds: 700),
          () {
            nextQuestion();
          },
        );
      }
    }
  }

  // =========================================================
  // NEXT QUESTION
  // =========================================================

  void nextQuestion() {
    if (currentQuestion.value <
        totalQuestion.value) {
      currentQuestion.value++;

      loadQuestion();
    } else {
      finishGame();
    }
  }

  // =========================================================
  // FINISH GAME
  // =========================================================

  void finishGame() {
    stopTimer();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 80,
                color: Colors.amber,
              ),

              const SizedBox(height: 20),

              const Text(
                "Game Selesai",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Mode : ${gameMode.value.toUpperCase()}",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Score Kamu : ${score.value}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();

                    showModeDialog();
                  },
                  child: const Text("Main Lagi"),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // =========================================================
  // RESTART GAME
  // =========================================================

  void restartGame() {
    stopTimer();

    currentQuestion.value = 1;

    score.value = 0;

    currentLetterIndex.value = 0;

    currentInput.value = '';

    generateQuestions();

    loadQuestion();
  }

  // =========================================================
  // MODE DIALOG
  // =========================================================

  void showModeDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          "Pilih Mode",
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _modeButton(
              title: "Easy",
              subtitle:
                  "Hint aktif • 2 point",
              mode: "easy",
            ),

            const SizedBox(height: 12),

            _modeButton(
              title: "Normal",
              subtitle:
                  "5 soal hint • 10 point",
              mode: "normal",
            ),

            const SizedBox(height: 12),

            _modeButton(
              title: "Hard",
              subtitle:
                  "Tanpa hint • Timer 90 detik • 25 point",
              mode: "hard",
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  // =========================================================
  // MODE BUTTON
  // =========================================================

  Widget _modeButton({
    required String title,
    required String subtitle,
    required String mode,
  }) {
    return GestureDetector(
      onTap: () {
        Get.back();

        startGame(mode);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F3EE),
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(subtitle),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // MORSE TABLE
  // =========================================================

  void openMorseTable() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.75,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFFFCF9F4),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(32),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFD4C3BF),
                borderRadius:
                    BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Tabel Morse",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF361F1A),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.8,
                children:
                    morseMap.entries.map((entry) {
                  return Container(
                    padding:
                        const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                      border: Border.all(
                        color: const Color(
                          0xFFE5E2DD,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                            color: Color(
                              0xFF361F1A,
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 24,
                            letterSpacing: 2,
                            color: Color(
                              0xFF7D562D,
                            ),
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // =========================================================
  // BACK
  // =========================================================

  void onBack() {
    stopTimer();

    Get.back();
  }
}