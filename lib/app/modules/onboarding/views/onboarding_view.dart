import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> with SingleTickerProviderStateMixin {
  // Panggil controller GetX secara manual
  final OnboardingController controller = Get.find<OnboardingController>();

  // Setup Animasi
  late AnimationController _animationController;
  
  // Background & Header
  late Animation<double> _bgFadeAnimation;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  // Konten Slide (Gambar & Teks)
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _contentScaleAnimation;

  // Footer (Indikator & Tombol)
  late Animation<double> _footerFadeAnimation;
  late Animation<Offset> _footerSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Durasi total animasi 1.8 detik
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // 1. Animasi Background (0.0 - 0.3)
    _bgFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.3, curve: Curves.easeOut)),
    );

    // 2. Animasi Header (0.1 - 0.5) meluncur dari atas ke bawah
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic)),
    );
    _headerSlideAnimation = Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic)),
    );

    // 3. Animasi Konten Utama (0.3 - 0.8) meluncur dari bawah + zoom halus
    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic)),
    );
    _contentSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic)),
    );
    _contentScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.3, 0.8, curve: Curves.easeOutBack)),
    );

    // 4. Animasi Footer (0.5 - 1.0) meluncur dari bawah
    _footerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic)),
    );
    _footerSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic)),
    );

    // Eksekusi animasi saat halaman pertama kali dibuka
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Visual Accents Dianimasikan
          FadeTransition(
            opacity: _bgFadeAnimation,
            child: Stack(
              children: [
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
              ],
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header Dianimasikan
                FadeTransition(
                  opacity: _headerFadeAnimation,
                  child: SlideTransition(
                    position: _headerSlideAnimation,
                    child: _buildHeader(),
                  ),
                ),
                
                // Konten Slide (PageView) Dianimasikan
                Expanded(
                  child: FadeTransition(
                    opacity: _contentFadeAnimation,
                    child: SlideTransition(
                      position: _contentSlideAnimation,
                      child: ScaleTransition(
                        scale: _contentScaleAnimation,
                        child: PageView.builder(
                          controller: controller.pageController,
                          onPageChanged: controller.onPageChanged,
                          itemCount: controller.data.length,
                          itemBuilder: (context, i) => _buildSlide(controller.data[i]),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Footer Dianimasikan
                FadeTransition(
                  opacity: _footerFadeAnimation,
                  child: SlideTransition(
                    position: _footerSlideAnimation,
                    child: _buildFooter(),
                  ),
                ),
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
              fontFamily: 'Poppins',
            ),
          ),
          TextButton(
            onPressed: controller.goToLogin,
            child: const Text(
              "Lewati", 
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
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
                width: double.infinity,
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
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item['desc']!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.5),
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
            height: 52, // Sedikit ditebalkan agar konsisten dengan tombol Login
            child: ElevatedButton(
              onPressed: controller.next,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF361F1A),
                shape: const StadiumBorder(),
                elevation: 4,
                shadowColor: const Color(0xFF361F1A).withOpacity(0.4),
              ),
              child: const Text(
                "Lanjutkan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text.rich(
            TextSpan(
              text: "Sudah punya akun? ",
              style: const TextStyle(color: Colors.black54),
              children: [
                TextSpan(
                  text: "Masuk",
                  recognizer: TapGestureRecognizer()..onTap = controller.goToLogin,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7D562D),
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