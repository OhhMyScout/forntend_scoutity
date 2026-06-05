import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart';

// Enum untuk status akhir permainan ditambahkan "lose"
enum GameResultStatus { win, timeout, lose }

class MorseChallengeController extends GetxController {
  // =========================================================
  // OBS
  // =========================================================

  final currentQuestion = 1.obs;
  final totalQuestion = 10.obs;
  final score = 0.obs;
  
  // Melacak jumlah salah ketik (Maksimal 5)
  final mistakes = 0.obs;

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
  // TIME OUT & GAME OVER LOGIC
  // =========================================================

  void onTimeOut() {
    HapticFeedback.heavyImpact();
    
    // SIMPAN SKOR SAAT WAKTU HABIS
    _submitScore();
    
    _showResultDialog(
      status: GameResultStatus.timeout,
      title: "WAKTU HABIS!",
      message: "Kamu berhasil meraih ${score.value} poin. Game akan diulang dari awal.",
      actionText: "Ulangi",
      onAction: () {
        Get.back();
        resetHardModeGame();
      },
    );
  }

  void onGameOver() {
    HapticFeedback.heavyImpact();
    stopTimer();
    
    // SIMPAN SKOR SAAT KALAH (SALAH 5 KALI)
    _submitScore();

    _showResultDialog(
      status: GameResultStatus.lose,
      title: "GAME OVER!",
      message: "Kamu telah salah mengetik kode morse sebanyak 5 kali. Skor akhirmu adalah ${score.value} poin.",
      actionText: "Coba Lagi",
      onAction: () {
        Get.back();
        showModeDialog();
      },
    );
  }

  // =========================================================
  // RESET HARD MODE
  // =========================================================

  void resetHardModeGame() {
    stopTimer();
    score.value = 0;
    mistakes.value = 0; // Reset kesalahan
    currentQuestion.value = 1;
    currentLetterIndex.value = 0;
    currentInput.value = '';

    generateQuestions();
    loadQuestion();
    startTimer();
  }

  // =========================================================
  // RESTART GAME
  // =========================================================

  void restartGame() {
    stopTimer();
    currentQuestion.value = 1;
    score.value = 0;
    mistakes.value = 0; // Reset kesalahan
    currentLetterIndex.value = 0;
    currentInput.value = '';

    generateQuestions();
    loadQuestion();
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
    if (mistakes.value >= 5) return;
    HapticFeedback.lightImpact();
    currentInput.value += '.';
    checkCurrentLetter();
  }

  void inputDash() {
    if (mistakes.value >= 5) return;
    HapticFeedback.lightImpact();
    currentInput.value += '-';
    checkCurrentLetter();
  }

  void deleteInput() {
    if (mistakes.value >= 5) return;
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

    // WRONG (Jika input tidak sesuai dengan awal dari kode morse yang benar)
    if (!correctMorse.startsWith(input)) {
      HapticFeedback.heavyImpact();
      
      mistakes.value++; // Tambah 1 kesalahan

      // Cek apakah sudah 5 kali salah
      if (mistakes.value >= 5) {
        onGameOver();
        return;
      }

      Get.snackbar(
        "Salah",
        "Kode morse tidak sesuai! (Kesalahan: ${mistakes.value}/5)",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(milliseconds: 1000),
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
    
    // SIMPAN SKOR SAAT MENANG
    _submitScore();
    
    _showResultDialog(
      status: GameResultStatus.win,
      title: "LUAR BIASA!",
      message: "Kamu berhasil menyelesaikan Mode ${gameMode.value.toUpperCase()} dan meraih ${score.value} poin!",
      actionText: "Main Lagi",
      onAction: () {
        Get.back();
        showModeDialog();
      },
    );
  }

  // ==========================================================
  // FITUR BARU: UPLOAD SKOR KE DATABASE
  // ==========================================================
  Future<void> _submitScore() async {
    // Abaikan jika skor 0 agar database tidak penuh
    if (score.value <= 0) return; 

    try {
      final token = SessionManager.getToken();
      final response = await http.post(
        Uri.parse(ApiEndpoint.submitScore),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "game_name": "morse_challenge",
          "score": score.value,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("[Morse] Skor berhasil disimpan: ${score.value}");
      } else {
        debugPrint("[Morse] Gagal menyimpan skor: ${response.body}");
      }
    } catch (e) {
      debugPrint("[Morse] Error submit skor: $e");
    }
  }

  // =========================================================
  // DESAIN DIALOG RESULT CUSTOM (MENANG / TIMEOUT / LOSE)
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
      case GameResultStatus.lose:
        headerColor = Colors.red.shade50;
        iconColor = Colors.red;
        iconData = Icons.cancel_rounded;
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
  // MODE DIALOG
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

  Widget _modeButton({
    required String title,
    required String subtitle,
    required String mode,
    required Color iconColor,
  }) {
    return GestureDetector(
      onTap: () {
        Get.back();
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
  // KELUAR DARI PERMAINAN (BACK DENGAN KONFIRMASI)
  // =========================================================

  void onBack() {
    // Memunculkan popup konfirmasi sebelum keluar
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
                      onPressed: () => Get.back(), // Tutup dialog
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
                        // KELUAR TANPA MEMANGGIL _submitScore()
                        stopTimer();
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
}