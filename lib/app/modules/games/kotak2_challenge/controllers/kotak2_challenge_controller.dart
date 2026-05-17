import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/bank_soal_kotak2.dart'; 

class Kotak2ChallengeController extends GetxController {
  var questions = <String>[].obs;
  var currentQuestionIndex = 0.obs;
  
  var currentWord = ''.obs;
  var userAnswer = <String>[].obs;
  
  var score = 0.obs;
  var lives = 3.obs;
  var timeLeft = 45.obs; 

  // Variabel untuk melacak apakah pemain melakukan interaksi (mengetik)
  bool hasInteracted = false;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startGame();
  }

  void startGame() {
    _timer?.cancel();
    score.value = 0;
    lives.value = 3;
    currentQuestionIndex.value = 0;
    
    // Reset status interaksi di awal permainan
    hasInteracted = false;
    
    var shuffledBank = [...BankSoalKotak2.words]..shuffle(Random());
    questions.value = shuffledBank.take(5).toList();
    
    loadQuestion();
  }

  void loadQuestion() {
    if (currentQuestionIndex.value >= questions.length) {
      _timer?.cancel();
      _showResultDialog(
        isWin: true,
        title: "TANTANGAN SELESAI!",
        message: "Hebat! Kamu berhasil memecahkan semua sandi Kotak 2.",
      );
      return;
    }

    currentWord.value = questions[currentQuestionIndex.value];
    userAnswer.value = List.filled(currentWord.value.length, '');
    
    timeLeft.value = 45;
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        _timer?.cancel();
        // Kurangi nyawa karena waktu habis
        reduceLife(isTimeout: true);
      }
    });
  }

  void onKeyPress(String letter) {
    hasInteracted = true; // Tandai bahwa pemain sudah berinteraksi
    int emptyIndex = userAnswer.indexWhere((char) => char.isEmpty);
    if (emptyIndex != -1) {
      userAnswer[emptyIndex] = letter;
    }
  }

  void onBackspace() {
    hasInteracted = true; // Tandai bahwa pemain sudah berinteraksi
    int lastFilledIndex = userAnswer.lastIndexWhere((char) => char.isNotEmpty);
    if (lastFilledIndex != -1) {
      userAnswer[lastFilledIndex] = '';
    }
  }

  void checkAnswer() {
    hasInteracted = true; // Tandai bahwa pemain sudah berinteraksi
    if (userAnswer.contains('')) {
      Get.snackbar(
        "Belum Lengkap", 
        "Isi semua kotak huruf terlebih dahulu!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
      );
      return;
    }

    String answerStr = userAnswer.join('');
    if (answerStr == currentWord.value) {
      _timer?.cancel();
      score.value += 20;
      currentQuestionIndex.value++;
      
      Get.snackbar(
        "Benar!", 
        "Lanjut ke sandi berikutnya.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        duration: const Duration(seconds: 1),
      );
      
      Future.delayed(const Duration(seconds: 1), loadQuestion);
    } else {
      reduceLife(isTimeout: false);
    }
  }

  void _resetForRetry() {
    userAnswer.value = List.filled(currentWord.value.length, '');
    timeLeft.value = 45;
    startTimer();
  }

  void reduceLife({required bool isTimeout}) {
    _timer?.cancel();
    lives.value--;

    // Kondisi 1: Nyawa Habis (0)
    if (lives.value <= 0) {
      
      // LOGIKA BARU: Jika dari awal game sampai nyawa habis tidak ada interaksi sama sekali
      if (!hasInteracted) {
        _showResultDialog(
          isWin: false,
          title: "HALO?",
          message: "Apa Km Tidur Scout? Kok tidak ada pergerakan sama sekali. Ayo bangun dan selesaikan tantangannya!",
          customIcon: Icons.snooze_rounded,
          customColor: Colors.blueGrey,
        );
      } 
      // Jika nyawa habis tapi skor masih 0 (Pernah mencoba tapi salah terus)
      else if (score.value == 0) {
        _showResultDialog(
          isWin: false,
          title: "YAH, KAMU KALAH!",
          message: "Aduh, kamu banyakin belajar yah! Nyawa kamu habis dan skor kamu masih 0.",
        );
      } 
      // Jika nyawa habis tapi punya skor
      else {
        _showResultDialog(
          isWin: false,
          title: "KAMU HEBAT!",
          message: "Kamu hebat berhasil meraih ${score.value} poin! Tapi sayang nyawa kamu sudah habis.",
        );
      }
    } 
    // Kondisi 2: Nyawa sisa 1 (Peringatan Khusus)
    else if (lives.value == 1) {
      _showWarningDialog();
    } 
    // Kondisi 3: Nyawa masih aman (> 1)
    else {
      Get.snackbar(
        "Oops!", 
        isTimeout 
            ? "Waktu habis! Nyawa kamu berkurang 1." 
            : "Jawaban kurang tepat! Nyawa kamu berkurang 1.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      _resetForRetry();
    }
  }

  // Desain Dialog Peringatan (Nyawa sisa 1)
  void _showWarningDialog() {
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
                        color: Colors.orange.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_rounded,
                        size: 56,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "HATI-HATI!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF361F1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Nyawa kamu sisa 1! Ayo hati-hati dan lebih fokus lagi memperhatikannya.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 16,
                        color: Color(0xFF504442),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _resetForRetry();
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
                          "LANJUT",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
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

  // Desain Dialog Akhir Game (Diperbarui agar mendukung ikon/warna kustom)
  void _showResultDialog({
    required bool isWin,
    required String title,
    required String message,
    IconData? customIcon,
    Color? customColor,
  }) {
    Color iconColor = customColor ?? (isWin ? Colors.green : Colors.red);
    Color headerColor = customColor != null 
        ? customColor.withValues(alpha: 0.1) 
        : (isWin ? Colors.green.shade50 : Colors.red.shade50);
    IconData iconData = customIcon ?? (isWin ? Icons.emoji_events_rounded : Icons.sentiment_dissatisfied_rounded);

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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}