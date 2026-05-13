import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

import '../controllers/home_controller.dart';
import '../../theme/tabbar.dart';


class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),

      /// ================= APPBAR =================
      appBar: _buildAppBar(primaryColor),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildHeroSection(primaryColor),
            const SizedBox(height: 32),

            const Text(
              "Menu",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 16),
            _buildMenuGrid(),

            const SizedBox(height: 32),

            const Text(
              "Rekomendasi Untukmu",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 16),
            _buildRecommendations(primaryColor),

            const SizedBox(height: 100),
          ],
        ),
      ),

      /// ================= TABBAR GLOBAL =================
      bottomNavigationBar: const AppTabBar(),
    );
  }

  // =========================================================
  // APPBAR
  // =========================================================
  PreferredSizeWidget _buildAppBar(Color primary) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              "https://media.licdn.com/dms/image/v2/D5603AQF5yUKaWvZ49w/profile-displayphoto-scale_200_200/B56Zt9qUhVIcAY-/0/1767339805299",
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "Scoutify",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HERO
  // =========================================================
  Widget _buildHeroSection(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PUSAT PENGETAHUAN",
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7D562D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pramuka Jadi Lebih Praktis",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: primary,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // MENU GRID
  // =========================================================
  Widget _buildMenuGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 110,
      ),
      itemCount: controller.menuItems.length,
      itemBuilder: (context, index) {
        final item = controller.menuItems[index];

        return GestureDetector(
          onTap: () {
            _navigateByIndex(item['route']);
          },
          child: Column(
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F3EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Container(
                    height: 52,
                    width: 52,
                    decoration: BoxDecoration(
                      color: Color(item['color']),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      item['icon'],
                      color: const Color(0xFF361F1A),
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['title'],
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // NAVIGATION MENU GRID
  // =========================================================
  void _navigateByIndex(String route) {
    switch (route) {
      case "edukasi":
        Get.toNamed(Routes.BERANDA_EDUKASI);
        break;
      case "game":
        Get.toNamed(Routes.BERANDA_GAME);
        break;
      case "survival":
        Get.toNamed(Routes.BERANDA_SURVIVAL);
        break;
      case "profile":
        Get.toNamed(Routes.BERANDA_PROFILE);
        break;
      default:
        return;
    }
  }

  // =========================================================
  // RECOMMENDATION
  // =========================================================
  Widget _buildRecommendations(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4E342E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Text(
        "Rekomendasi Konten",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}