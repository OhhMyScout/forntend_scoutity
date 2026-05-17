import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

// Enum untuk status akhir permainan
enum GameResultStatus { win, timeout }

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
    "A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".",
    "F": "..-.", "G": "--.", "H": "....", "I": "..", "J": ".---",
    "K": "-.-", "L": ".-..", "M": "--", "N": "-.", "O": "---",
    "P": ".--.", "Q": "--.-", "R": ".-.", "S": "...", "T": "-",
    "U": "..-", "V": "...-", "W": ".--", "X": "-..-", "Y": "-.--",
    "Z": "--..",
  };

  // =========================================================
  // DATABASE SOAL
  // =========================================================

  final List<String> allWords = [
    "SCOUT", "PRAMUKA", "MORSE", "SEMAPHORE", "SURVIVAL", "KEMAH",
    "TANDU", "REGU", "API", "HIKING", "JELAJAH", "SANDI", "TALI",
    "KOMPAS", "PELUIT", "BARUNG", "PENGGALANG", "SIAGA", "PENEGAK",
    "AMBALAN", "KEMAHAN", "PETA", "PIONERING", "RANSEL", "KAKI",
    "HUTAN", "ALAM", "TIM", "LATIHAN", "DISIPLIN", "MANDIRI",
    "TANGGUH", "BERANI", "SATYA", "DARMA", "KEGIATAN", "JAMBORE",
    "NASIONAL", "PETUALANG", "KREATIF", "AKTIF", "CERDAS", "HEBAT",
    "TANGKAS", "SIGAP", "KOMPAK", "SAHABAT", "BINTANG", "PELANTIKAN",
    "KETUA", "ANGGOTA", "LENCANA", "UPACARA", "PENOLONG", "PERSAUDARAAN",
    "KEPEMIMPINAN", "BARU", "MERDEKA", "INDONESIA", "GARUDA", "PANCASILA",
    "SEMANGAT", "JUJUR", "TULUS", "RAJIN", "SOPAN", "HEMAT", "TEPAT",
    "CEPAT", "KUAT", "LATIH", "GERAK",
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

  double get progress => currentQuestion.value / totalQuestion.value;

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
    
    _showResultDialog(
      status: GameResultStatus.timeout,
      title: "WAKTU HABIS!",
      message: "Game akan diulang dari awal dan skor menjadi 0.",
      actionText: "Ulangi",
      onAction: () {
        Get.back(); // Tutup dialog
        resetHardModeGame();
      },
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
    selectedQuestions.addAll(shuffled.take(totalQuestion.value));
  }

  // =========================================================
  // LOAD QUESTION
  // =========================================================

  void loadQuestion() {
    currentWord.value = selectedQuestions[currentQuestion.value - 1].toUpperCase();
    currentLetterIndex.value = 0;
    currentInput.value = '';

    if (gameMode.value == "normal") {
      showHint.value = currentQuestion.value <= 5;
    }

    if (gameMode.value == "hard") {
      startTimer();
    }
  }

  // =========================================================
  // INPUT DOT & DASH
  // =========================================================

  void inputDot() {
    HapticFeedback.lightImpact();
    currentInput.value += '.';
    checkCurrentLetter();
  }

  void inputDash() {
    HapticFeedback.lightImpact();
    currentInput.value += '-';
    checkCurrentLetter();
  }

  void deleteInput() {
    if (currentInput.value.isNotEmpty) {
      currentInput.value = currentInput.value.substring(0, currentInput.value.length - 1);
    }
  }

  // =========================================================
  // CHECK LETTER
  // =========================================================

  void checkCurrentLetter() {
    final word = currentWord.value;

    if (currentLetterIndex.value >= word.length) {
      return;
    }

    final letter = word[currentLetterIndex.value];
    final correctMorse = morseMap[letter] ?? '';
    final input = currentInput.value;

    // WRONG
    if (!correctMorse.startsWith(input)) {
      HapticFeedback.heavyImpact();

      Get.snackbar(
        "Salah",
        "Kode morse tidak sesuai",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(milliseconds: 700),
      );

      currentInput.value = '';
      return;
    }

    // CORRECT
    if (input == correctMorse) {
      HapticFeedback.mediumImpact();
      currentLetterIndex.value++;
      currentInput.value = '';

      // WORD FINISH
      if (currentLetterIndex.value >= word.length) {
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
    if (currentQuestion.value < totalQuestion.value) {
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
    
    _showResultDialog(
      status: GameResultStatus.win,
      title: "LUAR BIASA!",
      message: "Kamu berhasil menyelesaikan Mode ${gameMode.value.toUpperCase()}!",
      actionText: "Main Lagi",
      onAction: () {
        Get.back(); // Tutup dialog
        showModeDialog(); // Kembali ke pemilihan mode
      },
    );
  }

  // =========================================================
  // DESAIN DIALOG RESULT CUSTOM (MENANG / TIMEOUT)
  // =========================================================

  void _showResultDialog({
    required GameResultStatus status,
    required String title,
    required String message,
    required String actionText,
    required VoidCallback onAction,
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
                            onPressed: () => Get.offAllNamed('/beranda-game'),
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
                            onPressed: onAction,
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
  // MODE DIALOG TERBARU (DENGAN ANIMASI)
  // =========================================================

  void showModeDialog() {
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
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings_suggest_rounded,
                        size: 48,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "PILIH TINGKAT KESULITAN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF361F1A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _modeButton(
                      title: "Easy",
                      subtitle: "Hint aktif • 2 point",
                      mode: "easy",
                      iconColor: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _modeButton(
                      title: "Normal",
                      subtitle: "5 soal hint • 10 point",
                      mode: "normal",
                      iconColor: Colors.orange,
                    ),
                    const SizedBox(height: 12),
                    _modeButton(
                      title: "Hard",
                      subtitle: "Tanpa hint • Timer 90 detik • 25 point",
                      mode: "hard",
                      iconColor: Colors.red,
                    ),
                  ],
                ),
              ),
            );
          }
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
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () {
        Get.back(); // Menutup dialog
        startGame(mode);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F3EE),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFD4C3BF).withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.flash_on_rounded, color: iconColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF361F1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      color: Color(0xFF504442),
                    ),
                  ),
                ],
              ),
            ),
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
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Tabel Morse",
              style: TextStyle(
                fontFamily: 'Poppins',
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
                children: morseMap.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE5E2DD)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF361F1A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.value,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 24,
                            letterSpacing: 2,
                            color: Color(0xFF7D562D),
                            fontWeight: FontWeight.w800,
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
    Get.offAllNamed('/beranda-game');
  }
}