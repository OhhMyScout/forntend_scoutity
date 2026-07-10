// lib/app/modules/beranda_game/views/beranda_game_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/theme.dart';
import '../../../theme/tabbar.dart';
import '../controllers/beranda_game_controller.dart';

class BerandaGameView extends GetView<BerandaGameController> {
  const BerandaGameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppTheme.secondary,
              onRefresh: () async {
                if (controller.initialized) {
                  await controller.fetchData(); 
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 140, // Ruang untuk TabBar di bawah
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildHero(),
                    const SizedBox(height: 24),
                    
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.secondary,
                            ),
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRankCard(),
                          const SizedBox(height: 32),
                          _buildGamesSection(),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Tab Bar menempel di bawah
            const Align(
              alignment: Alignment.bottomCenter,
              child: AppTabBar(currentIndex: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Scout Games",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primary,
              fontFamily: "Poppins",
            ),
          ),
          IconButton(
            onPressed: controller.openNotification,
            icon: const Icon(
              Icons.settings,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      height: 340,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: const Color(0xFF4E342E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                "https://sipjkdlfjzmxptldxgxa.supabase.co/storage/v1/object/public/images/kompress_squere.jpg", 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: const Color(0xFF4E342E));
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF4E342E).withOpacity(0.9),
                      const Color(0xFF4E342E).withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "AI FEATURE",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Deteksi\nSemaphore",
                    style: TextStyle(
                      fontSize: 38,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Belajar Semaphore jadi lebih seru dengan AI",
                    style: TextStyle(
                      color: Color(0xFFE5BEB5),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: controller.openSemaphoreDetection,
                      icon: const Icon(Icons.videocam),
                      label: const Text(
                        "Mulai Sekarang",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3EE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFD4C3BF),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDCBD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.myRank.value > 0
                        ? "Peringkat Kamu: #${controller.myRank.value}"
                        : "Peringkat Kamu: -",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Total: ${controller.myPoint.value} Poin",
                    style: const TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: controller.openLeaderboard,
            child: const Row(
              children: [
                Text(
                  "Detail",
                  style: TextStyle(
                    color: AppTheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mini Games",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
            fontFamily: "Poppins",
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Mainkan Mini games dan raih point tertinggi dan jadikan kamu menjadi top #1",
          style: TextStyle(
            color: AppTheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),

        GridView.builder(
          // Tambah +1 agar kotak Coming Soon otomatis muncul di akhir list
          itemCount: controller.games.length + 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Diubah menjadi 2 kolom
            childAspectRatio: 0.53, // Disesuaikan untuk memuat 2 tombol di dalam kolom sempit
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            
            // JIKA INDEX MENCAPAI AKHIR LIST DATA DARI DB, TAMPILKAN COMING SOON
            if (index == controller.games.length) {
              return _buildComingSoonCard();
            }

            // KARTU GAME NORMAL
            final item = controller.games[index];
            final bool isPrimary = (item["primary"] ?? false) as bool;

            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFE5E2DD),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      item["image"].toString(),
                      height: 100, // Diperkecil karena layarnya dibagi 2
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 10,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item["title"]?.toString() ?? "Game Title",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["description"]?.toString() ?? "Game description",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  // const Spacer(),
                  const SizedBox(height: 15),
                  
                  // ==========================================
                  // 1. TOMBOL LEADERBOARD
                  // ==========================================
                  SizedBox(
                    width: double.infinity,
                    height: 38, // Diperkecil agar proporsional
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: AppTheme.secondary,
                        side: const BorderSide(color: AppTheme.secondary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Mengarah ke leaderboard dan melempar game_name spesifik
                        Get.toNamed(
                          '/leaderboard', 
                          arguments: {
                            'game_id': item['id'] ?? item['title'], 
                            'game_name': item['title'] ?? 'Mini Game'
                          },
                        );
                      },
                      icon: const Icon(Icons.leaderboard, size: 16),
                      label: const Text(
                        "Peringkat",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),

                  // ==========================================
                  // 2. TOMBOL MULAI BERMAIN
                  // ==========================================
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        backgroundColor: isPrimary ? AppTheme.primary : const Color(0xFFF6F3EE),
                        foregroundColor: isPrimary ? Colors.white : AppTheme.secondary,
                        side: isPrimary ? BorderSide.none : const BorderSide(color: AppTheme.secondary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        controller.openGame(item);
                      },
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: Text(
                        item["button"]?.toString() ?? "Mainkan",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ==========================================================
  // WIDGET KARTU COMING SOON
  // ==========================================================
  Widget _buildComingSoonCard() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Abu-abu muda
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.lock_clock_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Coming Soon",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Nantikan tantangan seru lainnya yang akan segera hadir!",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
          const Spacer(),
          
          // Tombol Disabled
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: null, // Disabled
              icon: const Icon(Icons.lock, size: 16),
              label: const Text(
                "Terkunci",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}