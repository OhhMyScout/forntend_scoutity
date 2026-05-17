import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/beranda_berita_controller.dart';

class BerandaBeritaView extends GetView<BerandaBeritaController> {
  const BerandaBeritaView({super.key});

  static const Color primary = Color(0xFF361F1A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color secondary = Color(0xFF7D562D);
  static const Color secondaryContainer = Color(0xFFFFCA98);
  static const Color onSecondaryContainer = Color(0xFF7A532A);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DD);
  static const Color onSurfaceVariant = Color(0xFF504442);

  @override
  Widget build(BuildContext context) {
    final RxString activePressedId = ''.obs;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Stack(
          children: [
            // Ornamen Dekoratif Latar Belakang
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondaryContainer.withValues(alpha: 0.12),
                ),
              ),
            ),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Animasi Muncul: Welcome Header
                        _buildAnimatedEntrance(
                          delayIndex: 0,
                          child: _buildWelcomeHeader(),
                        ),
                        const SizedBox(height: 24),

                        // 2. Animasi Muncul: Mini Information Board (38 Provinsi)
                        _buildAnimatedEntrance(
                          delayIndex: 1,
                          child: _buildInfoBoard(),
                        ),
                        const SizedBox(height: 36),
                        
                        // 3. Animasi Muncul: Label Menu
                        _buildAnimatedEntrance(
                          delayIndex: 2,
                          child: const Text(
                            "Pilih Metode Analisis",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: primary,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 4. Animasi Muncul: Card Statistik Provinsi
                        _buildAnimatedEntrance(
                          delayIndex: 3,
                          child: _buildInteractiveMenuCard(
                            id: "provinsi",
                            title: "Statistik Berita Provinsi",
                            desc: "Lihat tabel sebaran informasi dan wawasan aktivitas kepramukaan di setiap wilayah provinsi Indonesia.",
                            icon: Icons.map_rounded,
                            iconBg: const Color(0xFFE0F3F5),
                            iconColor: const Color(0xFF006874),
                            stateRx: activePressedId,
                            onTap: controller.goToBeritaProvinsi,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // 5. Animasi Muncul: Card Berita Populer
                        _buildAnimatedEntrance(
                          delayIndex: 4,
                          child: _buildInteractiveMenuCard(
                            id: "populer",
                            title: "Berita Paling Populer",
                            desc: "Akses kompilasi tabel data berita utama yang paling sering dibaca, disukai, dan trending saat ini.",
                            icon: Icons.auto_graph_rounded,
                            iconBg: const Color(0xFFFFDAD6),
                            iconColor: const Color(0xFFBA1A1A),
                            stateRx: activePressedId,
                            onTap: controller.goToBeritaPopuler,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0x1F827471), width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: primary),
            onPressed: controller.onBack,
          ),
          const SizedBox(width: 8),
          const Text(
            "Beranda Berita",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: secondaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.analytics_rounded, size: 14, color: onSecondaryContainer),
              SizedBox(width: 6),
              Text(
                "DATA VISUALIZATION",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: onSecondaryContainer,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          "Analisis Informasi Pramuka",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: primary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Telusuri sebaran data wawasan pramuka dan berita terpopuler nasional secara terstruktur.",
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 15,
            color: onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBoard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.stacked_bar_chart_rounded, color: secondaryContainer, size: 28),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "38 Wilayah Provinsi",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Cakup pemantauan agregasi infografis data nasional",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveMenuCard({
    required String id,
    required String title,
    required String desc,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required RxString stateRx,
    required VoidCallback onTap,
  }) {
    return Obx(() {
      final bool isPressed = stateRx.value == id;

      return GestureDetector(
        onTapDown: (_) => stateRx.value = id,
        onTapUp: (_) => stateRx.value = '',
        onTapCancel: () => stateRx.value = '',
        onTap: onTap,
        child: AnimatedScale(
          scale: isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isPressed ? secondary : surfaceContainerHighest.withValues(alpha: 0.3),
                width: isPressed ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: isPressed ? 0.04 : 0.08),
                  blurRadius: isPressed ? 10 : 24,
                  offset: isPressed ? const Offset(0, 4) : const Offset(0, 8),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13,
                          color: onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Text(
                            "Buka Analisis Tabel",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: secondary,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.arrow_forward_rounded, size: 14, color: secondary),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // =========================================================
  // SISTEM ANIMASI STAGGERED ENTRANCE KUSTOM
  // =========================================================
  Widget _buildAnimatedEntrance({
    required int delayIndex,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (delayIndex * 120)),
      curve: Curves.easeOutBack, // Menggunakan properti bawaan Flutter yang benarcu, // Menggunakan properti bawaan Flutter yang benar, // Memberikan efek memantul lembut di akhir transisi
      builder: (context, value, animatedChild) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1.0 - value)), // Bergeser ke atas (Slide up)
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}