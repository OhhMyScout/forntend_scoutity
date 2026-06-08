import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart'; // Audio player sudah diaktifkan

import '../../../theme/theme.dart';
import '../controllers/morse_challenge_controller.dart';

class MorseChallengeView extends GetView<MorseChallengeController> {
  const MorseChallengeView({super.key});

  void _showMorseTable(BuildContext context) {
    if (Get.isBottomSheetOpen == true) return;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -5),
            )
          ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 6,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Panduan Tabel Sandi Morse",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F3EE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEBE5DB)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/image_sandi/full-morse.png', 
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Gagal memuat gambar tabel morse."),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),
      
      // Diganti menjadi SwipeDown agar seragam dengan game lainnya
      body: SwipeDownDetector(
        onSwipeDown: () => _showMorseTable(context),
        child: SafeArea(
          child: Obx(
            () {
              return Column(
                children: [
                  _buildAppBar(),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
                      child: Column(
                        children: [
                          _buildProgress(),
                          const SizedBox(height: 28),
                          _buildChallengeCard(),
                          const SizedBox(height: 40),
                          _buildControlButtons(context),
                          const SizedBox(height: 40),
                          
                          // TOMBOL TELEGRAF TUNGGAL (Dengan Suara)
                          _MorseTelegraphButton(
                            onDot: controller.inputDot,
                            onDash: controller.inputDash,
                          ),
                          
                          const SizedBox(height: 32),
                          const Text(
                            "Tarik layar ke bawah untuk melihat Tabel Bantuan",
                            style: TextStyle(
                              color: Color(0xFF827471),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // =========================================================
  // APP BAR
  // =========================================================

  Widget _buildAppBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.onBack,
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppTheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Sandi Morse",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
              ),
            ),
          ),
          
          _buildMiniModeBadge(),
          
          // INDIKATOR SISA KESEMPATAN (NYAWA)
          Obx(() {
            int chancesLeft = 5 - controller.mistakes.value;
            Color chanceColor = chancesLeft <= 2 ? Colors.red : Colors.orange;

            return Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: chanceColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: chanceColor.withValues(alpha: 0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, size: 15, color: chanceColor),
                  const SizedBox(width: 4),
                  Text(
                    "$chancesLeft",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: chanceColor,
                    ),
                  ),
                ],
              ),
            );
          }),

          // INDIKATOR TIMER KHUSUS HARD MODE
          if (controller.gameMode.value == "hard") ...[
            const SizedBox(width: 8),
            _buildMiniTimer(),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniModeBadge() {
    String mode = "Easy";
    Color color = Colors.green;

    if (controller.gameMode.value == "normal") {
      mode = "Normal";
      color = Colors.orange;
    }

    if (controller.gameMode.value == "hard") {
      mode = "Hard";
      color = Colors.red;
    }

    return GestureDetector(
      onTap: controller.showModeDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flash_on_rounded, size: 15, color: color),
            const SizedBox(width: 4),
            Text(
              mode,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniTimer() {
    final value = controller.timer.value;
    Color timerColor = Colors.green;

    if (value <= 20) timerColor = Colors.orange;
    if (value <= 10) timerColor = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: timerColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: timerColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 15, color: timerColor),
          const SizedBox(width: 4),
          Text(
            "${controller.timer.value}s",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: timerColor,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // PROGRESS
  // =========================================================

  Widget _buildProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Soal ${controller.currentQuestion.value} / ${controller.totalQuestion.value}",
              style: const TextStyle(
                color: Color(0xFF827471),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "+${controller.pointPerQuestion}",
                    style: const TextStyle(
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Score ${controller.score.value}",
                  style: const TextStyle(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: controller.progress,
            minHeight: 8,
            backgroundColor: const Color(0xFFEBE8E3),
            valueColor: const AlwaysStoppedAnimation(AppTheme.secondary),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // CHALLENGE CARD
  // =========================================================

  Widget _buildChallengeCard() {
    final word = controller.currentWord.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFD4C3BF).withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4E342E).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'TERJEMAHKAN KATA',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 4,
              fontWeight: FontWeight.w800,
              color: Color(0xFF827471),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            word,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: List.generate(
              word.length,
              (index) {
                final letter = word[index];
                final morse = controller.morseMap[letter] ?? '';
                final isActive = index == controller.currentLetterIndex.value;
                final isDone = index < controller.currentLetterIndex.value;

                return _buildLetter(
                  letter: letter,
                  morse: morse,
                  active: isActive,
                  done: isDone,
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          
          // AREA INPUT JAWABAN SAAT INI
          Container(
            width: double.infinity,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ]
            ),
            child: Text(
              controller.currentInput.value.isEmpty ? "..." : controller.currentInput.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: controller.currentInput.value.isEmpty ? Colors.white38 : Colors.white,
                letterSpacing: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetter({
    required String letter,
    required String morse,
    required bool active,
    required bool done,
  }) {
    return Column(
      children: [
        controller.showHint.value
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  morse.length,
                  (index) {
                    final symbol = morse[index];
                    Color color;

                    if (done) {
                      color = Colors.green;
                    } else if (active) {
                      final typed = controller.currentInput.value;
                      if (index < typed.length) {
                        color = (typed[index] == symbol) ? Colors.green : Colors.red;
                      } else {
                        color = AppTheme.secondary;
                      }
                    } else {
                      color = const Color(0xFFE5E2DD);
                    }

                    if (symbol == '.') {
                      return Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      );
                    }
                    return Container(
                      width: 22,
                      height: 8,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                    );
                  },
                ),
              )
            : Container(
                width: 70,
                height: 12,
                decoration: BoxDecoration(
                  color: done ? Colors.green : active ? AppTheme.secondary : const Color(0xFFE5E2DD),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
        const SizedBox(height: 14),
        Container(
          padding: active ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4) : EdgeInsets.zero,
          decoration: active
              ? BoxDecoration(
                  color: AppTheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Text(
            letter,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: done ? Colors.green : active ? AppTheme.secondary : const Color(0xFF827471),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // CONTROL BUTTONS
  // =========================================================

  Widget _buildControlButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showMorseTable(context),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F3EE),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFD4C3BF).withValues(alpha: 0.5)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book_rounded, color: AppTheme.secondary),
                  SizedBox(width: 8),
                  Text('Tabel Morse', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.secondary)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              controller.deleteInput();
            },
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.backspace_rounded, color: Colors.red.shade600),
                  const SizedBox(width: 8),
                  Text('Hapus', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade700)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================
// WIDGET TOMBOL TELEGRAF TUNGGAL (INTERAKTIF & AUDIO)
// =========================================================
class _MorseTelegraphButton extends StatefulWidget {
  final VoidCallback onDot;
  final VoidCallback onDash;

  const _MorseTelegraphButton({required this.onDot, required this.onDash});

  @override
  State<_MorseTelegraphButton> createState() => _MorseTelegraphButtonState();
}

class _MorseTelegraphButtonState extends State<_MorseTelegraphButton> with SingleTickerProviderStateMixin {
  DateTime? _pressStartTime;
  bool _isPressed = false;
  
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    
    // Agar suara tidak delay saat tombol diketuk cepat
    _audioPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  void _handlePointerDown(PointerDownEvent event) async {
    setState(() {
      _isPressed = true;
      _pressStartTime = DateTime.now();
    });
    _animController.forward();
    
    HapticFeedback.lightImpact();
    
    // Putar suara beep
    await _audioPlayer.stop(); 
    await _audioPlayer.play(AssetSource('sounds/morse_beep.mp3'));
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (_pressStartTime != null) {
      final duration = DateTime.now().difference(_pressStartTime!);
      
      // Jika ditekan lebih dari 400 milidetik, dianggap sebagai DASH (-)
      if (duration.inMilliseconds >= 400) {
        widget.onDash();
        HapticFeedback.heavyImpact(); 
      } 
      // Jika ditekan sebentar, dianggap sebagai DOT (.)
      else {
        widget.onDot();
        HapticFeedback.selectionClick(); 
      }
    }
    _resetState();
  }

  void _resetState() {
    setState(() {
      _isPressed = false;
      _pressStartTime = null;
    });
    _animController.reverse();
  }

  @override
  void dispose() {
    _animController.dispose();
    _audioPlayer.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerUp,
      onPointerCancel: (_) => _resetState(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: _isPressed ? AppTheme.secondary : AppTheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withValues(alpha: _isPressed ? 0.2 : 0.4),
                blurRadius: _isPressed ? 10 : 30,
                offset: Offset(0, _isPressed ? 5 : 15),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(-5, -5),
              ),
            ],
            border: Border.all(
              color: AppTheme.primary.withValues(alpha: 0.5),
              width: 4,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.touch_app_rounded, 
                color: Colors.white.withValues(alpha: 0.9), 
                size: 56
              ),
              const SizedBox(height: 12),
              const Text(
                "TAP ( • )\nAtau\nHOLD ( - )",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 2,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// WIDGET DETEKSI SWIPE DOWN (TARIK KE BAWAH)
// =========================================================
class SwipeDownDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeDown;

  const SwipeDownDetector({
    super.key,
    required this.child,
    required this.onSwipeDown,
  });

  @override
  State<SwipeDownDetector> createState() => _SwipeDownDetectorState();
}

class _SwipeDownDetectorState extends State<SwipeDownDetector> {
  double _startY = 0.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _startY = event.position.dy;
      },
      onPointerUp: (event) {
        double deltaY = event.position.dy - _startY;
        // Jika ditarik ke bawah lebih dari 80 pixel
        if (deltaY > 80) {
          widget.onSwipeDown();
        }
      },
      child: widget.child,
    );
  }
}