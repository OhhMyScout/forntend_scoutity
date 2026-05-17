import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kotak2_challenge_controller.dart';

class Kotak2ChallengeView extends GetView<Kotak2ChallengeController> {
  const Kotak2ChallengeView({super.key});

  static const Color primary = Color(0xFF361F1A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color secondaryContainer = Color(0xFFFFCA98);
  static const Color onSecondaryContainer = Color(0xFF7A532A);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceContainerHigh = Color(0xFFEBE8E3);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DD);
  static const Color outline = Color(0xFF827471);
  static const Color outlineVariant = Color(0xFFD4C3BF);
  static const Color errorColor = Color(0xFFBA1A1A);

  void _showSandiTable() {
    // Mencegah bottom sheet terbuka berkali-kali jika user melakukan swipe berulang
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
              "Panduan Tabel Sandi Kotak 2",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: primary,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/image_sandi/full-kotak2.png',
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
    return Scaffold(
      backgroundColor: background,
      // Membungkus body dengan detektor swipe up kustom
      body: SwipeUpDetector(
        onSwipeUp: _showSandiTable,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: DotGridPainter(),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        children: [
                          _buildStatusProgress(),
                          const SizedBox(height: 24),
                          _buildChallengeCard(),
                          const SizedBox(height: 16),
                          _buildHintAndGuide(),
                          const SizedBox(height: 260), 
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildKeyboard(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: primary),
                  onPressed: () => Get.offAllNamed('/beranda-game'),
                ),
                const SizedBox(width: 4),
                const Expanded(
                  child: Text(
                    "Tebak Sandi Kotak 2",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite, size: 18, color: Color(0xFF7D562D)),
                const SizedBox(width: 4),
                Text(
                  "${controller.lives.value}",
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: onSecondaryContainer,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStatusProgress() {
    return Obx(() {
      if (controller.questions.isEmpty) return const SizedBox.shrink();
      
      double progressPct = (controller.currentQuestionIndex.value) / controller.questions.length;
      
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LEVEL ${controller.currentQuestionIndex.value + 1}/${controller.questions.length}",
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: outline,
                      ),
                    ),
                    const Text(
                      "Tantangan Sandi",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: secondaryContainer, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    "${controller.timeLeft.value}",
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: controller.timeLeft.value <= 10 ? errorColor : primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 8,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: progressPct),
                builder: (context, value, _) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: surfaceContainerHighest,
                    color: secondaryContainer,
                  );
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildChallengeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 40,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Obx(() {
        if (controller.currentWord.value.isEmpty) return const SizedBox.shrink();
        
        String word = controller.currentWord.value;
        
        return Column(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: word.split('').map((char) {
                return Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: surfaceContainerHigh, width: 1.5),
                  ),
                  child: Image.asset(
                    'assets/images/kotak2/${char.toUpperCase()}.png', 
                    fit: BoxFit.contain,
                    errorBuilder: (context, err, stack) => const Icon(Icons.broken_image, color: outline),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            
            const Text(
              "TERJEMAHKAN",
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: outline,
              ),
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: List.generate(word.length, (index) {
                String answeredChar = '';
                if (index < controller.userAnswer.length) {
                  answeredChar = controller.userAnswer[index];
                }
                
                bool isFilled = answeredChar.isNotEmpty;

                return Container(
                  width: 44,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isFilled 
                        ? surfaceContainerLow.withValues(alpha: 0.5) 
                        : surfaceContainerLow.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      bottom: BorderSide(
                        color: isFilled ? primary : surfaceContainerHigh,
                        width: 4,
                      ),
                      top: BorderSide(color: isFilled ? primary : surfaceContainerHigh, width: 2),
                      left: BorderSide(color: isFilled ? primary : surfaceContainerHigh, width: 2),
                      right: BorderSide(color: isFilled ? primary : surfaceContainerHigh, width: 2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      isFilled ? answeredChar : "_",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: isFilled ? primary : outline.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHintAndGuide() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4E342E).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF4E342E).withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline, color: primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Urbanist', 
                      fontSize: 14, 
                      color: Color(0xFF504442), 
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: "Petunjuk: ", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: primary),
                      ),
                      TextSpan(
                        text: "Sandi Kotak 2 menggunakan satu kotak untuk tiga huruf. Jumlah titik menentukan posisinya. Atau kamu juga bisa swipe/usap ke atas untuk melihat tabel bantuan.",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _showSandiTable,
          icon: const Icon(Icons.grid_on, size: 18),
          label: const Text("Tabel Sandi Kotak 2"),
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyboard(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(top: 12, bottom: bottomPadding > 0 ? bottomPadding : 24, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, -8),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle (Indikator visual untuk swipe up)
          Center(
            child: Container(
              width: 48,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          _buildKeyboardRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildKeyboardRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L']),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 15,
                child: _buildKeyWidget(
                  child: const Icon(Icons.backspace_outlined, color: errorColor, size: 22),
                  bgColor: errorColor.withValues(alpha: 0.1),
                  onTap: () => controller.onBackspace(),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(flex: 10, child: _buildKey('Z')),
              const SizedBox(width: 4),
              Expanded(flex: 10, child: _buildKey('X')),
              const SizedBox(width: 4),
              Expanded(flex: 10, child: _buildKey('C')),
              const SizedBox(width: 4),
              Expanded(flex: 10, child: _buildKey('V')),
              const SizedBox(width: 4),
              Expanded(flex: 10, child: _buildKey('B')),
              const SizedBox(width: 4),
              Expanded(flex: 10, child: _buildKey('N')),
              const SizedBox(width: 4),
              Expanded(flex: 10, child: _buildKey('M')),
              const SizedBox(width: 4),
              Expanded(
                flex: 20,
                child: _buildKeyWidget(
                  child: const Text(
                    "CEK", 
                    style: TextStyle(
                      fontFamily: 'Nunito', 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white, 
                      fontSize: 16,
                      letterSpacing: 1.0,
                    ),
                  ),
                  bgColor: primary,
                  onTap: () => controller.checkAnswer(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: _buildKey(key),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildKey(String letter) {
    return _buildKeyWidget(
      child: Text(
        letter,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: primary,
        ),
      ),
      bgColor: surfaceContainerLow,
      onTap: () => controller.onKeyPress(letter),
    );
  }

  Widget _buildKeyWidget({required Widget child, required Color bgColor, required VoidCallback onTap}) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: secondaryContainer.withValues(alpha: 0.5),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

// Widget Stateful Khusus untuk mendeteksi Swipe Up secara global
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
        // Jika jari diusap ke atas lebih dari 80 pixel, jalankan fungsi
        if (deltaY > 80) {
          widget.onSwipeUp();
        }
      },
      child: widget.child,
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4C3BF)
      ..strokeWidth = 1.5
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