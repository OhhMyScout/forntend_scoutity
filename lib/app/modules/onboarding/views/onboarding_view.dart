// lib/modules/onboarding/onboarding_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Visual Accents
          Positioned(
            top: -100,
            right: -100,
            child: _blurCircle(Colors.brown[100]!),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: _blurCircle(Colors.orange[50]!),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: controller.data.length,
                    itemBuilder: (context, i) =>
                        _buildSlide(controller.data[i]),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Scoutify",
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF361F1A),
            ),
          ),
          TextButton(
            onPressed: controller.goToLogin, // Panggil fungsi ke login
            child: const Text("Lewati", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                item['image']!,
                height: 320,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            item['title']!,
            textAlign: TextAlign.center,
            style: Get.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF361F1A),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item['desc']!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.data.length,
                (i) => AnimatedContainer(
                  duration: 300.milliseconds,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: controller.currentPage.value == i ? 24 : 6,
                  decoration: BoxDecoration(
                    color: controller.currentPage.value == i
                        ? const Color(0xFF361F1A)
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: controller.next,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF361F1A),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                "Lanjutkan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: "Sudah punya akun? ",
              style: const TextStyle(color: Colors.black54),
              children: [
                TextSpan(
                  text: "Masuk",
                  // Menggunakan recognizer agar teks bisa diklik
                  recognizer: TapGestureRecognizer()..onTap = controller.goToLogin,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF361F1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(Color color) => Container(
    width: 300,
    height: 300,
    decoration: BoxDecoration(
      color: color.withOpacity(0.3),
      shape: BoxShape.circle,
    ),
  );
}
