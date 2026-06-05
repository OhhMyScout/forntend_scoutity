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
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
          ),
        ),
        title: const Text(
          'Scout Games',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          /// TAB KATEGORI
          _buildCategorySelector(),

          /// KONTEN UTAMA
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: secondaryColor),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.getLeaderboard();
                },
                color: secondaryColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      /// KARTU POIN SAYA (Berubah jadi Poin Provinsi jika dipilih)
                      _buildMyPointCard(),

                      const SizedBox(height: 35),

                      /// PODIUM TOP 3
                      _buildPodium(),

                      const SizedBox(height: 35),

                      /// LIST LAINNYA
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Column(
                            children: [
                              _buildListHeader(),
                              
                              if (controller.otherRanksList.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Text(
                                    "Belum ada data tersedia",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              else
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.otherRanksList.length,
                                  separatorBuilder: (context, index) => const Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: Color(0xFFF0EAE3),
                                  ),
                                  itemBuilder: (context, index) {
                                    return _buildListRow(
                                        controller.otherRanksList[index]);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            return GestureDetector(
              onTap: () => controller.changeCategory(category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? secondaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? secondaryColor : const Color(0xFFEBE5DB),
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: secondaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? Colors.white : secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildMyPointCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5D4037), Color(0xFF3E2723)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4E342E).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Obx(() {
        final category = controller.selectedCategory.value;
        final isProv = category == 'Provinsi';
        
        final rank = controller.myRank.value;
        final points = controller.myPoint.value;
        
        final displayName = isProv 
            ? (controller.myProvince.value.isNotEmpty && controller.myProvince.value != "-" ? controller.myProvince.value : 'Lainnya')
            : (controller.myName.value.isNotEmpty ? controller.myName.value : 'Scout');
            
        final displaySubtitle = isProv 
            ? 'Total Poin Provinsi Kamu'
            : (category == 'Global' ? 'Peringkat Global' : 'Peringkat $category');
            
        final image = controller.myImage.value;

        return Row(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Color(0xFFFFCA98),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                backgroundImage: (!isProv && image.isNotEmpty && image != 'default_profile.png')
                    ? NetworkImage(image)
                    : null,
                child: isProv
                    ? const Icon(Icons.map_rounded, color: secondaryColor, size: 28)
                    : (image.isEmpty || image == 'default_profile.png')
                        ? const Icon(Icons.person, color: Colors.grey, size: 30)
                        : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    displaySubtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: rank > 0 ? const Color(0xFFFFCA98) : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events_rounded,
                        size: 16,
                        color: rank > 0 ? const Color(0xFF7A532A) : Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rank > 0 ? '#$rank' : '-',
                        style: TextStyle(
                          color: rank > 0 ? const Color(0xFF7A532A) : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$points Pts',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPodium() {
    if (controller.topThree.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "Belum ada data podium",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final topData = controller.topThree;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (topData.length >= 2)
          Expanded(
            child: _podiumCard(
              data: topData[1],
              targetHeight: 140,
              position: 2,
            ),
          )
        else
          const Expanded(child: SizedBox()),

        const SizedBox(width: 12),

        if (topData.isNotEmpty)
          Expanded(
            child: _podiumCard(
              data: topData[0],
              targetHeight: 190,
              position: 1,
            ),
          )
        else
          const Expanded(child: SizedBox()),

        const SizedBox(width: 12),

        if (topData.length >= 3)
          Expanded(
            child: _podiumCard(
              data: topData[2],
              targetHeight: 110,
              position: 3,
            ),
          )
        else
          const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _podiumCard({
    required Map data,
    required double targetHeight,
    required int position,
  }) {
    final isProv = data['isProvince'] == true;
    final image = data['image']?.toString() ?? '';
    final isFirst = position == 1;

    Color baseColor;
    Color iconColor;
    if (position == 1) {
      baseColor = const Color(0xFFFFD700);
      iconColor = const Color(0xFFB8860B);
    } else if (position == 2) {
      baseColor = const Color(0xFFE0E0E0);
      iconColor = const Color(0xFF757575);
    } else {
      baseColor = const Color(0xFFCD7F32);
      iconColor = const Color(0xFF8D4004);
    }

    return GestureDetector(
      onTap: isProv ? null : () => _showParticipantDetails(data),
      child: Column(
        children: [
          if (isFirst)
            const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFFFD700),
              size: 36,
            ),
          const SizedBox(height: 4),
          Container(
            padding: EdgeInsets.all(isFirst ? 4 : 3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: baseColor,
              boxShadow: [
                if (isFirst)
                  BoxShadow(
                    color: baseColor.withOpacity(0.5),
                    blurRadius: 15,
                  ),
              ],
            ),
            child: CircleAvatar(
              radius: isFirst ? 38 : 30,
              backgroundColor: Colors.white,
              backgroundImage: (!isProv && image.isNotEmpty && image != 'default_profile.png') 
                  ? NetworkImage(image) 
                  : null,
              child: isProv
                  ? Icon(Icons.location_city_rounded, color: iconColor)
                  : (image.isEmpty || image == 'default_profile.png')
                      ? Icon(Icons.person, color: Colors.grey.shade400)
                      : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['name']?.toString() ?? '-',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${data['point']} pts',
            style: const TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: targetHeight),
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutQuart,
            builder: (context, height, child) {
              return Container(
                height: height,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      baseColor.withOpacity(0.8),
                      baseColor.withOpacity(0.3),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: height > 30
                    ? Center(
                        child: Text(
                          '$position',
                          style: TextStyle(
                            fontSize: isFirst ? 42 : 32,
                            fontWeight: FontWeight.w900,
                            color: iconColor.withOpacity(0.5),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListHeader() {
    final isProv = controller.selectedCategory.value == 'Provinsi';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF6F3EE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Rank',
              style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor),
            ),
          ),
          Expanded(
            flex: isProv ? 7 : 4,
            child: Text(
              isProv ? 'Nama Provinsi' : 'Nama',
              style: const TextStyle(fontWeight: FontWeight.bold, color: secondaryColor),
            ),
          ),
          if (!isProv)
            const Expanded(
              flex: 3,
              child: Text(
                'Provinsi',
                style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor),
              ),
            ),
          const Expanded(
            flex: 3,
            child: Text(
              'Poin',
              textAlign: TextAlign.end,
              style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListRow(Map item) {
    final isProv = item['isProvince'] == true;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isProv ? null : () => _showParticipantDetails(item),
        highlightColor: const Color(0xFFF0EAE3).withOpacity(0.5),
        splashColor: const Color(0xFFFFCA98).withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFEBE5DB)),
                    ),
                    child: Text(
                      '${item['rank']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: isProv ? 7 : 4,
                child: Text(
                  item['name']?.toString() ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                  ),
                ),
              ),
              if (!isProv)
                Expanded(
                  flex: 3,
                  child: Text(
                    item['province']?.toString() ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              Expanded(
                flex: 3,
                child: Text(
                  item['point'].toString(),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // ACTION METHODS
  // ==========================================================
  
  void _showParticipantDetails(Map item) {
    controller.loadParticipantStats(item['email']?.toString() ?? '');

    final image = item['image']?.toString() ?? '';
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            CircleAvatar(
              radius: 45,
              backgroundColor: backgroundColor,
              backgroundImage: image.isNotEmpty && image != 'default_profile.png' 
                  ? NetworkImage(image) 
                  : null,
              child: image.isEmpty || image == 'default_profile.png'
                  ? const Icon(Icons.person, size: 45, color: secondaryColor)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              item['name']?.toString() ?? '-',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  item['province']?.toString() ?? 'Tidak diketahui',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Obx(() {
              if (controller.participantDetailLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: CircularProgressIndicator(color: secondaryColor),
                );
              }

              final stats = controller.participantDetailStats;

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailCard(
                          title: "Global",
                          rank: stats['Global']?['rank'] ?? 0,
                          point: stats['Global']?['point'] ?? 0,
                          color: const Color(0xFFFFCA98),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailCard(
                          title: "Sandi Kotak 1",
                          rank: stats['Sandi Kotak 1']?['rank'] ?? 0,
                          point: stats['Sandi Kotak 1']?['point'] ?? 0,
                          color: const Color(0xFFF0EAE3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailCard(
                          title: "Sandi Kotak 2",
                          rank: stats['Sandi Kotak 2']?['rank'] ?? 0,
                          point: stats['Sandi Kotak 2']?['point'] ?? 0,
                          color: const Color(0xFFF0EAE3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailCard(
                          title: "Morse",
                          rank: stats['Morse']?['rank'] ?? 0,
                          point: stats['Morse']?['point'] ?? 0,
                          color: const Color(0xFFF0EAE3),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailCard({
    required String title,
    required int rank,
    required int point,
    required Color color,
  }) {
    final hasPlayed = rank > 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: secondaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events_rounded, color: secondaryColor, size: 16),
              const SizedBox(width: 4),
              Text(
                hasPlayed ? "#$rank" : "-",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star_rounded, color: secondaryColor, size: 16),
              const SizedBox(width: 4),
              Text(
                hasPlayed ? "$point Pts" : "-",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}