import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kotak1_challenge_controller.dart';

class Kotak1ChallengeView extends GetView<Kotak1ChallengeController> {
  const Kotak1ChallengeView({super.key});

  Color getOptionBgColor(BuildContext context, String opt) {
    if (!controller.isAnswered.value) return Colors.white;
    if (opt == controller.current.correctAnswer) return Colors.green.shade100;
    if (opt == controller.selectedAnswer.value) return Colors.red.shade100;
    return Colors.white;
  }

  Color getOptionBorderColor(BuildContext context, String opt) {
    final theme = Theme.of(context);
    if (!controller.isAnswered.value) return theme.colorScheme.surfaceContainerHigh;
    if (opt == controller.current.correctAnswer) return Colors.green;
    if (opt == controller.selectedAnswer.value) return Colors.red;
    return theme.colorScheme.surfaceContainerHigh;
  }

  Color getProgressBarColor(BuildContext context) {
    final theme = Theme.of(context);
    if (controller.isAnswered.value) {
      if (controller.selectedAnswer.value == controller.current.correctAnswer) {
        return Colors.green; 
      } else {
        return Colors.red; 
      }
    }
    return theme.colorScheme.secondaryContainer; 
  }

  void _showSandiTable(BuildContext context) {
    // Mencegah bottom sheet terbuka lebih dari satu kali jika user swipe berulang
    if (Get.isBottomSheetOpen == true) return;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Panduan Tabel Sandi Kotak 1",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF361F1A),
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/image_sandi/full-kotak1.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Gagal memuat gambar tabel sandi."),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
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
      backgroundColor: theme.scaffoldBackgroundColor,
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Get.offAllNamed('/beranda-game'),
        ),
        title: Text(
          "Scoutify",
          style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24),
        ),
        actions: [
          Obx(() {
            final seconds = controller.timeLeft.value;
            final isCritical = seconds <= 10;
            return Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isCritical ? theme.colorScheme.error : theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer, 
                    size: 14, 
                    color: isCritical ? theme.colorScheme.onError : Colors.white
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "00:${seconds.toString().padLeft(2, '0')}",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isCritical ? theme.colorScheme.onError : Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      
      // Membungkus body utama dengan SwipeUpDetector
      body: SwipeUpDetector(
        onSwipeUp: () => _showSandiTable(context),
        child: Obx(() {
          if (controller.questions.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final q = controller.current;
          final currentIdx = controller.index.value + 1;
          final totalQuestions = controller.questions.length;
          final progressPct = currentIdx / totalQuestions;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CHALLENGE ${currentIdx.toString().padLeft(2, '0')}/${totalQuestions.toString().padLeft(2, '0')}",
                          style: theme.textTheme.labelMedium,
                        ),
                        Text(
                          "Sandi Kotak I",
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.colorScheme.onSecondaryContainer.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.military_tech, 
                            size: 14, 
                            color: theme.colorScheme.onSecondaryContainer
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Skor: ${controller.score.value}",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 12,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      tween: Tween<double>(begin: 0.0, end: progressPct),
                      builder: (context, value, _) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: LinearProgressIndicator(
                            value: value,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            color: getProgressBarColor(context),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: theme.colorScheme.surfaceContainerHigh),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 192,
                        height: 192,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: DotGridPainter(
                                    dotColor: theme.colorScheme.outlineVariant,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Image.asset(q.image, fit: BoxFit.contain),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        q.question,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),

                      DragTarget<String>(
                        onAcceptWithDetails: (details) {
                          controller.selectAnswer(details.data);
                        },
                        builder: (context, candidateData, rejectedData) {
                          final hasAnswered = controller.isAnswered.value;
                          final currentSelection = controller.selectedAnswer.value;

                          return Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: hasAnswered 
                                  ? getOptionBgColor(context, currentSelection) 
                                  : theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: hasAnswered 
                                    ? getOptionBorderColor(context, currentSelection) 
                                    : theme.colorScheme.outlineVariant,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                hasAnswered ? currentSelection : "Drop Jawaban Kamu Di Sini",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: hasAnswered 
                                      ? theme.colorScheme.primary 
                                      : theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.shuffledOptions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemBuilder: (context, i) {
                    final opt = controller.shuffledOptions[i];
                    final isThisSelected = controller.selectedAnswer.value == opt;
                    final isAnswered = controller.isAnswered.value;

                    final childWidget = Container(
                      decoration: BoxDecoration(
                        color: isThisSelected ? theme.colorScheme.surfaceContainerHigh : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.surfaceContainerHigh, 
                          width: 2,
                        ),
                        boxShadow: isThisSelected ? null : [
                          BoxShadow(
                            color: theme.colorScheme.primary,
                            offset: const Offset(0, 4),
                            blurRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "PILIHAN ${i + 1}",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            opt,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ],
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
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: theme.colorScheme.primary, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              opt,
                              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.4,
                        child: childWidget,
                      ),
                      child: childWidget,
                    );
                  },
                ),
                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border(
                      left: BorderSide(color: theme.colorScheme.secondary, width: 4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info, color: theme.colorScheme.secondary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cara Bermain",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Seret (drag) kotak kata di atas ke dalam area jawaban. Kamu juga bisa swipe/usap ke atas layar untuk melihat tabel bantuan.",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showSandiTable(context),
                  icon: const Icon(Icons.grid_on, size: 18),
                  label: const Text("Tabel Sandi Kotak 1"),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// Widget Global Pendeteksi Usap/Swipe Ke Atas
class SwipeUpDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeUp;

  const SwipeUpDetector({
    super.key,
    required this.child,
    required this.onSwipeUp,
  });

  @override
  State<SwipeUpDetector> createState() => _SwipeUpDetectorState();
}

class _SwipeUpDetectorState extends State<SwipeUpDetector> {
  double _startY = 0.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _startY = event.position.dy;
      },
      onPointerUp: (event) {
        double deltaY = _startY - event.position.dy;
        // Jika jari mengusap ke atas lebih dari 80 pixel
        if (deltaY > 80) {
          widget.onSwipeUp();
        }
      },
      child: widget.child,
    );
  }
}

// Custom Painter Untuk Canvas Bintik
class DotGridPainter extends CustomPainter {
  final Color dotColor;
  DotGridPainter({required this.dotColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const double spacing = 20.0;
    for (double x = 10; x < size.width; x += spacing) {
      for (double y = 10; y < size.height; y += spacing) {
        canvas.drawPoints(PointMode.points, [Offset(x, y)], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}