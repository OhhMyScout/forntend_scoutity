import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kotak1_challenge_controller.dart';

class Kotak1ChallengeView extends GetView<Kotak1ChallengeController> {
  const Kotak1ChallengeView({super.key});

  Color getOptionBgColor(BuildContext context, String opt) {
    if (!controller.isAnswered.value) return Colors.white;
    if (opt == controller.current.correctAnswer) return Colors.green.shade50;
    if (opt == controller.selectedAnswer.value) return Colors.red.shade50;
    return Colors.white;
  }

  Color getOptionBorderColor(BuildContext context, String opt) {
    final theme = Theme.of(context);
    if (!controller.isAnswered.value) return theme.colorScheme.primary.withValues(alpha: 0.3);
    if (opt == controller.current.correctAnswer) return Colors.green.shade400;
    if (opt == controller.selectedAnswer.value) return Colors.red.shade400;
    return theme.colorScheme.surfaceContainerHigh;
  }

  Color getProgressBarColor(BuildContext context) {
    final theme = Theme.of(context);
    if (controller.isAnswered.value) {
      if (controller.selectedAnswer.value == controller.current.correctAnswer) {
        return Colors.green.shade400; 
      } else {
        return Colors.red.shade400; 
      }
    }
    return theme.colorScheme.primary; 
  }

  void _showSandiTable(BuildContext context) {
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
            // Handle Drag Indicator
            Container(
              width: 48,
              height: 6,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tabel Sandi Kotak 1",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Color(0xFF361F1A),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.grey),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                  ),
                )
              ],
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
                  'assets/images/image_sandi/full-kotak1.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Gagal memuat gambar tabel sandi.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4), // Background lebih soft dan modern
      
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F4),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF361F1A)),
          onPressed: () => Get.offAllNamed('/beranda-game'),
        ),
        title: const Text(
          "Scoutify",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Color(0xFF361F1A),
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Obx(() {
            final seconds = controller.timeLeft.value;
            final isCritical = seconds <= 10;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isCritical ? Colors.red.shade50 : theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isCritical ? Colors.red.shade200 : theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_outlined, 
                    size: 16, 
                    color: isCritical ? Colors.red.shade700 : theme.colorScheme.primary
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "00:${seconds.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isCritical ? Colors.red.shade700 : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      
      // Menggunakan SwipeDownDetector (Pull Down)
      body: SwipeDownDetector(
        onSwipeDown: () => _showSandiTable(context),
        child: Obx(() {
          if (controller.questions.isEmpty) {
            return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
          }

          final q = controller.current;
          final currentIdx = controller.index.value + 1;
          final totalQuestions = controller.questions.length;
          final progressPct = currentIdx / totalQuestions;

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Agar selalu bisa di-swipe
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER INFO CHALLENGE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CHALLENGE ${currentIdx.toString().padLeft(2, '0')}/${totalQuestions.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Sandi Kotak I",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF361F1A),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.military_tech, size: 18, color: Colors.orange.shade700),
                          const SizedBox(width: 4),
                          Text(
                            "${controller.score.value} Pts",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // PROGRESS BAR
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      tween: Tween<double>(begin: 0.0, end: progressPct),
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(getProgressBarColor(context)),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                
                // SOAL IMAGE
                Center(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFEBE5DB), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7D562D).withValues(alpha: 0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: DotGridPainter(
                                dotColor: const Color(0xFFEBE5DB),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Image.asset(q.image, fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // TEKS PERTANYAAN
                Center(
                  child: Text(
                    q.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF361F1A),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // DROP ZONE
                DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    controller.selectAnswer(details.data);
                  },
                  builder: (context, candidateData, rejectedData) {
                    final hasAnswered = controller.isAnswered.value;
                    final currentSelection = controller.selectedAnswer.value;
                    final isHovering = candidateData.isNotEmpty;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      height: 70,
                      decoration: BoxDecoration(
                        color: hasAnswered 
                            ? getOptionBgColor(context, currentSelection) 
                            : (isHovering ? theme.colorScheme.primary.withValues(alpha: 0.1) : const Color(0xFFF6F3EE)),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: hasAnswered 
                              ? getOptionBorderColor(context, currentSelection) 
                              : (isHovering ? theme.colorScheme.primary : const Color(0xFFD4C3BF)),
                          width: isHovering || hasAnswered ? 2.5 : 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          hasAnswered ? currentSelection : "Seret Jawaban Kamu Ke Sini",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: hasAnswered 
                                ? (currentSelection == q.correctAnswer ? Colors.green.shade700 : Colors.red.shade700)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),

                // DRAGGABLE OPTIONS
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.shuffledOptions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.0, // Membuat tombol lebih proporsional
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, i) {
                    final opt = controller.shuffledOptions[i];
                    final isThisSelected = controller.selectedAnswer.value == opt;
                    final isAnswered = controller.isAnswered.value;

                    // Desain kartu pilihan
                    final childWidget = AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isThisSelected ? Colors.grey.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isThisSelected ? Colors.grey.shade300 : const Color(0xFFEBE5DB), 
                          width: 1.5,
                        ),
                        boxShadow: isThisSelected || isAnswered ? [] : [
                          BoxShadow(
                            color: const Color(0xFF361F1A).withValues(alpha: 0.05),
                            offset: const Offset(0, 6),
                            blurRadius: 12,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isThisSelected ? Colors.grey.shade400 : const Color(0xFF361F1A),
                          ),
                        ),
                      ),
                    );

                    if (isAnswered) {
                      return childWidget;
                    }

                    return Draggable<String>(
                      data: opt,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 64) / 2,
                          height: 70,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              )
                            ]
                          ),
                          child: Center(
                            child: Text(
                              opt,
                              style: const TextStyle(
                                fontSize: 20, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: childWidget,
                      ),
                      child: childWidget,
                    );
                  },
                ),
                const SizedBox(height: 40),

                // INFO CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, color: Colors.blue.shade700, size: 28),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bantuan Tersedia!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Tarik (pull) layar dari atas ke bawah untuk membuka Tabel Sandi Kotak secara instan.",
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ======================================================
// PENDETEKSI SWIPE DOWN (TARIK KE BAWAH)
// ======================================================
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
        // Delta positif berarti jari bergerak dari atas ke bawah (Swipe Down)
        double deltaY = event.position.dy - _startY; 
        
        if (deltaY > 80) {
          widget.onSwipeDown();
        }
      },
      child: widget.child,
    );
  }
}

// ======================================================
// BACKGROUND DOT PAINTER
// ======================================================
class DotGridPainter extends CustomPainter {
  final Color dotColor;
  DotGridPainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const double spacing = 24.0;
    for (double x = 12; x < size.width; x += spacing) {
      for (double y = 12; y < size.height; y += spacing) {
        canvas.drawPoints(PointMode.points, [Offset(x, y)], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}