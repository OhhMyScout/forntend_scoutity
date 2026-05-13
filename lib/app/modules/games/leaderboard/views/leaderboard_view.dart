import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  static const Color primaryColor = Color(0xFF361F1A);
  static const Color secondaryColor = Color(0xFF7D562D);
  static const Color backgroundColor = Color(0xFFFCF9F4);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),

        title: const Text(
          'Scout Games',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// POINT CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: const Color(0xFF4E342E),
                borderRadius: BorderRadius.circular(28),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Poin Saya',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Obx(
                    () => Text(
                      '${controller.myPoint.value} Poin',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFCA98),
                        borderRadius: BorderRadius.circular(100),
                      ),

                      child: Text(
                        'Peringkat #${controller.myRank.value}',
                        style: const TextStyle(
                          color: Color(0xFF7A532A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// PODIUM
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Expanded(
                  child: podiumCard(
                    data: controller.topThree[0],
                    height: 140,
                    crown: false,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: podiumCard(
                    data: controller.topThree[1],
                    height: 190,
                    crown: true,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: podiumCard(
                    data: controller.topThree[2],
                    height: 110,
                    crown: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// LEADERBOARD
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                children: [

                  buildHeader(),

                  ...controller.leaderboard.map(
                    (item) => buildRow(item),
                  ),

                  buildMyRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget podiumCard({
    required Map data,
    required double height,
    bool crown = false,
  }) {

    return Column(
      children: [

        if (crown)
          const Icon(
            Icons.workspace_premium,
            color: Colors.amber,
            size: 32,
          ),

        CircleAvatar(
          radius: crown ? 40 : 32,
          backgroundImage: NetworkImage(
            data['image'],
          ),
        ),

        const SizedBox(height: 10),

        Text(
          data['name'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '${data['point']} pts',
          style: const TextStyle(
            color: secondaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          height: height,
          width: double.infinity,

          decoration: BoxDecoration(
            color: crown
                ? const Color(0xFFFFCA98)
                : const Color(0xFFF0EAE3),

            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),

          child: Center(
            child: Text(
              '#${data['rank']}',
              style: TextStyle(
                fontSize: crown ? 28 : 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {

    return Container(
      padding: const EdgeInsets.all(18),

      decoration: const BoxDecoration(
        color: Color(0xFFF6F3EE),

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),

      child: const Row(
        children: [

          Expanded(
            flex: 2,
            child: Text(
              'Rank',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Text(
              'Nama',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              'Provinsi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              'Poin',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRow(Map item) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),

      child: Row(
        children: [

          Expanded(
            flex: 2,
            child: Text(
              '#${item['rank']}',
            ),
          ),

          Expanded(
            flex: 4,
            child: Text(
              item['name'],
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              item['province'],
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              item['point'],
              textAlign: TextAlign.end,

              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMyRow() {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 20,
      ),

      decoration: BoxDecoration(
        color: const Color(0xFFFFCA98).withOpacity(0.2),

        borderRadius: BorderRadius.circular(20),
      ),

      child: const Row(
        children: [

          Expanded(
            flex: 2,
            child: Text(
              '#12',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Text(
              'Anda (Saya)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              'DKI Jakarta',
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              '1.250',
              textAlign: TextAlign.end,

              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}