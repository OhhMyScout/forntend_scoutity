import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/beranda_game_controller.dart';
import '../../../theme/tabbar.dart';

class BerandaGameView extends GetView<BerandaGameController> {
  const BerandaGameView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);

    // set tab aktif ke "Game"
    final tabController = Get.find<TabBarController>();
    tabController.index.value = 2;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),

      // 🔥 TAMBAHKAN TAB BAR DI SINI
      bottomNavigationBar: const AppTabBar(),

      appBar: _buildAppBar(primaryColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedCard(primaryColor),
            const SizedBox(height: 24),
            _buildLeaderboardBanner(primaryColor),
            const SizedBox(height: 32),
            const Text(
              "Mini Games",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            _buildQuizList(primaryColor, secondaryColor),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(Color primary) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "Scout Games",
        style: TextStyle(
          color: Color(0xFF361F1A),
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => controller.openLeaderboard(),
          icon: Icon(Icons.leaderboard_rounded, color: primary),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "UNGGULAN",
                  style: TextStyle(
                    color: Color(0xFF7D562D),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Deteksi Semaphore",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF361F1A),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Latih kemampuan visualmu dengan AI pendeteksi gerakan bendera semaphore secara real-time.",
                  style: TextStyle(color: Colors.black54, height: 1.5),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => controller.startSemaphore(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Mulai Deteksi",
                      style: TextStyle(
                        color: Colors.white,
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
    );
  }

  Widget _buildLeaderboardBanner(Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCA98),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.emoji_events_rounded,
              color: Color(0xFF361F1A), size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Papan Peringkat",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF361F1A),
                  ),
                ),
                Text(
                  "Lihat siapa pandu terbaik minggu ini.",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: Color(0xFF361F1A)),
        ],
      ),
    );
  }

  Widget _buildQuizList(Color primary, Color secondary) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.quizItems.length,
      itemBuilder: (context, index) {
        final item = controller.quizItems[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F3EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'] as IconData, color: primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF361F1A),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['desc'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () =>
                    controller.playQuiz(item['title'] as String),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: secondary,
                  elevation: 0,
                  side: BorderSide(color: secondary),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Main",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}