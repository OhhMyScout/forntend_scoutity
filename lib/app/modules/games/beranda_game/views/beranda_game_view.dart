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
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 140,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  const SizedBox(height: 24),

                  _buildHero(),

                  const SizedBox(height: 24),

                  _buildRankCard(),

                  const SizedBox(height: 32),

                  _buildGamesSection(),
                ],
              ),
            ),

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
              Icons.notifications_none,
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
            color: Colors.black.withValues(alpha: 0.10),
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
                "https://lh3.googleusercontent.com/aida-public/AB6AXuCwCYVn956xruc3S1wM9pX6VW5lGdWzMSM0X7Wsqs_j5oI73KCJUu_-ps013OM-1Ut_eHREBfBr2AJugvUqNy411Pau-5XQ0a-Qt2vYUi4cHhPHi0A-IvLVJmmCoARzbag7QGmYePUkbd4FnOC1sC8ASB4IZpLqKDru_6uxiWvY_Ted493WqhZsHqFHNddDKzz98AV69hA-7pfcsIoVpDitCzl1xh58BIjirNveeY17KihRp7BRYPzgQH_TVR8vPP5oHGMxxskJgak",
                fit: BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF4E342E),
                      const Color(
                        0xFF4E342E,
                      ).withValues(alpha: 0.20),
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
                    "Deteksi Semaphore",
                    style: TextStyle(
                      fontSize: 42,
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
                      fontSize: 18,
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

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Peringkat Kamu: #42",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
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
          itemCount: controller.games.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 0.88,
            mainAxisSpacing: 20,
          ),
          itemBuilder: (context, index) {
            final item = controller.games[index];

            final bool isPrimary =
                item["primary"] as bool;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: const Color(0xFFE5E2DD),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(22),
                    child: Image.network(
                      item["image"].toString(),
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    item["title"].toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item["description"].toString(),
                    style: const TextStyle(
                      color:
                          AppTheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: isPrimary
                            ? AppTheme.primary
                            : const Color(
                                0xFFF6F3EE,
                              ),
                        foregroundColor: isPrimary
                            ? Colors.white
                            : AppTheme.secondary,
                        side: isPrimary
                            ? BorderSide.none
                            : const BorderSide(
                                color:
                                    AppTheme.secondary,
                              ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),

                      onPressed: () {
                        controller.openGame(item);
                      },

                      icon: const Icon(
                        Icons.play_arrow,
                      ),

                      label: Text(
                        item["button"].toString(),
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
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
}