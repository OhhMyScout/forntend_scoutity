import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/tabbar.dart';
import '../../theme/theme.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Memantau status loading
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primary,
                  ),
                );
              }

              // Jika loading selesai, tampilkan dashboard dengan animasi
              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  bottom: 120, // Ruang agar konten tidak terpotong TabBar
                ),
                child: Column(
                  children: [
                    FadeInSlide(
                      delay: 0,
                      child: _buildHeader(),
                    ),
                    FadeInSlide(
                      delay: 150,
                      child: _buildHero(),
                    ),
                    FadeInSlide(
                      delay: 300,
                      child: _buildShortcuts(),
                    ),
                    const SizedBox(height: 32),
                    FadeInSlide(
                      delay: 450,
                      child: _buildAIFeature(),
                    ),
                    const SizedBox(height: 8),
                    FadeInSlide(
                      delay: 600,
                      child: _buildActivities(),
                    ),
                  ],
                ),
              );
            }),
            
            // Animasi TabBar dari bawah
            Obx(() => AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              bottom: controller.isLoading.value ? -100 : 0, // Sembunyikan saat loading
              left: 0,
              right: 0,
              child: const AppTabBar(currentIndex: 0),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: const Color(0xFFFFDAD2), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuCO6SwgDcXiSEZt2p81N3EGNfZ411awRII5qqZIjZYt64IC51nQAZEOFz4F88OAEg8420a4bnKCtxL9WMeGqEhEOUef9Q_Bbos3howCFOKGNuGV3wqWYEsxbxkcWteztEgfhOOU3HkH5bw9VQja75kQLGTImNtPoKoHycgopkJ606Yb7lkiWIQK3VvzqImjlFyI1DWKE8LE-rsSCXR5zKCG3X3R_S5fkfBR-YXQ3l-Rjm29-M43_hzxn7YTOZjGK6dyEoAIO-Ns8N4",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.account_circle, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        "Halo, Kak ${controller.usernameDisplay.value}!",
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      )),
                  const SizedBox(height: 2),
                  const Text(
                    "Scoutify",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: controller.onNotificationTap,
            icon: const Icon(
              Icons.notifications,
              size: 30,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 240,
        margin: const EdgeInsets.only(bottom: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuCmvnNGiNaQb30r5rKcTEAzNDbTAM2bqXg1xtX-HX_iYdvqZjvFww6Z7MgHdC1axe0ALqcHJ6sFMTStTUlPEesq4Lxwakk-mxaAhE2p1VDmlL_Haq1fGE1U74fuCXD_WYhQNoW8S5L843iCfW5hU2478F1UpH-t284YXbn9ZQSjNBIPMse86j2ZWc-uGUk2SFL0zedSFNOwiQUUnxPrfthkWVfJ222pIP8PbAK7D7L9VSyqBkzv6zDJV7qCawt_TvqqVH1dE_iwQDo",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                      Container(color: Colors.grey.shade300),
                ),
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
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCA98),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        "HIGHLIGHT",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7A532A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Jambore Nasional 2024",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Persiapkan dirimu untuk petualangan terbesar tahun ini.",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShortcuts() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: GridView.builder(
      itemCount: controller.shortcuts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.72,
        crossAxisSpacing: 14,
      ),
      itemBuilder: (context, index) {
        final item = controller.shortcuts[index];

        return Column(
          children: [
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => controller.onShortcutTap(
                  item["id"].toString(),
                ),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    color: AppTheme.secondary,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item["title"].toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    ),
  );
}

  Widget _buildAIFeature() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDAD2),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Color(0xFF2B1611)),
                  SizedBox(width: 6),
                  Text(
                    "TEKNOLOGI AI",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B1611),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuDUIH3Kz3lCqoaGvQ7lTdtU0iaVNpP1H2JzSL6ZmecE8cFHO6m4RIK-Lw7AT86L-DQVeG0swfi6SjOcmoUMNU4RzLdZcJg1eOX1fL1B0lMtt6yQ4qXEc6TKFh2-wkNX3t3B039rXh4TUYEvbXc7piTzdK37sjvGS__4Xs1_owQ41ggogixv-Pm_SlqhTxuDIQ9ISqOHwjrfBA0_4gHlgNnnJmwqkRJN4ShA7WWpiPm2He3b5JWH0z4Fu61T-UnfjiVvdLi5oD3USH8",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: Colors.grey.shade300),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "ANALYZING...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Deteksi Semaphore AI",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Identifikasi gerakan bendera semaphore secara real-time menggunakan kamera ponselmu dengan akurasi tinggi.",
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.6, color: AppTheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: controller.onStartDetection,
                child: const Text(
                  "Mulai Deteksi",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActivities() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Aktivitas Terkini",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                  fontFamily: "Poppins",
                ),
              ),
              TextButton(
                onPressed: controller.onSeeAll,
                child: const Text(
                  "Lihat Semua",
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            itemCount: controller.activities.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = controller.activities[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    onTap: () => controller.onActivityTap(item),
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppTheme.surfaceContainerHighest.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              item["image"].toString(),
                              width: 68,
                              height: 68,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 68,
                                height: 68,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["category"].toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF0BD8B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["title"].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item["time"].toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} // <--- PENUTUP CLASS HomeView ADA DI SINI

// ====================================================================
// WIDGET CUSTOM: FADE IN SLIDE ANIMATION
// Berada di luar class HomeView
// ====================================================================
class FadeInSlide extends StatefulWidget {
  final Widget child;
  final int delay;
  final bool slideUp;

  const FadeInSlide({
    super.key,
    required this.child,
    required this.delay,
    this.slideUp = true,
  });

  @override
  State<FadeInSlide> createState() => _FadeInSlideState();
}

class _FadeInSlideState extends State<FadeInSlide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _offset = Tween<Offset>(
      begin: widget.slideUp ? const Offset(0, 0.3) : const Offset(0, -0.3), 
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _timer = Timer(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}