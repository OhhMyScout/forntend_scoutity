import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/morse_challenge_controller.dart';

class MorseChallengeView extends GetView<MorseChallengeController> {
  const MorseChallengeView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);
    const surfaceColor = Color(0xFFFAF7F2);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: _buildAppBar(primaryColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsivitas: Gunakan Row jika layar lebar (Tablet/Desktop), Column jika sempit (Mobile)
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: _buildLeftSection(primaryColor, secondaryColor),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 5,
                        child: _buildRightSection(primaryColor, secondaryColor),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildLeftSection(primaryColor, secondaryColor),
                      const SizedBox(height: 24),
                      _buildRightSection(primaryColor, secondaryColor),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color primary) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: primary),
        onPressed: controller.back,
      ),
      title: Text(
        "Tebak Sandi Morse",
        style: TextStyle(
          color: primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Obx(
          () => Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFCA98),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: Color(0xFF7A532A), size: 16),
                Text(
                  "${controller.streak.value}x Streak",
                  style: const TextStyle(
                    color: Color(0xFF7A532A),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.leaderboard_rounded, color: primary),
        ),
      ],
    );
  }

  Widget _buildLeftSection(Color primary, Color secondary) {
    return Column(
      children: [
        // Signal Light Area
        Container(
          height: 350,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
              ),
            ],
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Obx(
                      () => Text(
                        controller.timer.value,
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCA98).withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF0EDE9),
                          width: 8,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: secondary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: secondary.withValues(alpha: 0.4),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.repeatSignal,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("ULANGI SINYAL"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: const StadiumBorder(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // --- BAGIAN YANG DIPERBAIKI ---
                        IconButton.outlined(
                          onPressed: () {},
                          icon: const Icon(Icons.volume_up),
                          style: IconButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFD4C3BF),
                              width: 2,
                            ),
                          ),
                        ),
                        // ------------------------------
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Sequence Display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F3EE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "URUTAN MORSE",
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                children: [
                  ...controller.currentMorseSequence.map(
                    (e) => _buildMorseKey(e, primary),
                  ),
                  _buildMorseKey("?", Colors.grey, isHint: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRightSection(Color primary, Color secondary) {
    return Column(
      children: [
        // Progress Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Progress Misi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "Soal ${controller.currentQuestion} / ${controller.totalQuestions}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: 0.8,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFF0EDE9),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    secondary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    "Poin",
                    controller.points.value.toString(),
                    primary,
                  ),
                  _buildStatItem(
                    "Akurasi",
                    "${controller.accuracy.value}%",
                    primary,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Input Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masukkan Jawaban",
                style: TextStyle(fontWeight: FontWeight.bold, color: primary),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.answerController,
                decoration: InputDecoration(
                  hintText: "Ketik kata yang terdeteksi...",
                  filled: true,
                  fillColor: const Color(0xFFF6F3EE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.clearAnswer,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFD4C3BF),
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "HAPUS",
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.submitAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "KIRIM",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Context Image
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.network(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuDcUeZqfeQw7BisSbGJqLHri3ThMoGGvuXTYCiZwtqb44DuTknwV0iELZmHeDl2i23YpHyhJdaSDoakXaDr_ShRXbuuw6jXuzyCnw116gZlrcP3gnl9qHzQ4jFonGPkyGGu_YwIfG2G2I1aMO-EHZK8IkHZbwfu9101PesmWWJsJ0pDHcf4UNR4Eo7acU5nJRsXXziuoaBSywlTw1q-68yq54gDWSFfRsbQDwnmmVI9GmLwdF6FoiRGNXSRmhQjLGLl3WWlG1PqGCA",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  "Pesan: Sinyal dari Menara Barat",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMorseKey(String char, Color color, {bool isHint = false}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isHint
            ? Border.all(color: const Color(0xFFE5BEB5), width: 2)
            : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5),
        ],
      ),
      child: Center(
        child: Text(
          char,
          style: TextStyle(
            fontSize: 24,
            fontWeight: isHint ? FontWeight.normal : FontWeight.bold,
            color: color,
            fontStyle: isHint ? FontStyle.italic : FontStyle.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color primary) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
