import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/tabbar.dart';
import '../../../theme/theme.dart';
import '../controllers/beranda_survival_controller.dart';

class BerandaSurvivalView extends GetView<BerandaSurvivalController> {
  const BerandaSurvivalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 120, // Memberikan ruang ekstra agar tidak tertutup TabBar
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildHero(),
                  const SizedBox(height: 20),
                  _buildCompassCard(),
                  const SizedBox(height: 28),
                  const Text(
                    "Menu Survival",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildSurvivalGrid(),
                  const SizedBox(height: 28),
                  const Text(
                    "Menu Darurat",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildP3KCard(),
                  const SizedBox(height: 20),
                  _buildEmergencyCard(),
                  const SizedBox(height: 20),
                  _buildTipsCard(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AppTabBar(currentIndex: 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        
        const SizedBox(width: 4),
        const Text(
          "Survival Hub",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      height: 170,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
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
                "https://lh3.googleusercontent.com/aida-public/AB6AXuD6zF2B-k4zBAFcZ2CDhy-YCEjFO611-0avPHBYhluxwFFRQpVQsos2L0xoXTwcoKBcNW_Fo5Sur4G6R9Xt37rHVNn4ecLzooBuqWmO1ZRdy__alWAEtD0_T6TbLii8UswANCYEaUcKX6I5KZtMWCC56BLmll4bG-0V2aSVBFrh7fpi6hh2x_t2Nc64LC1hINrsn94Nsg5ZMUK_Xpsnq1gpAKkQ0S_1a8UsKjfkc71moZdU0nwUSfGdFBHjps5g1s6y6Sr8SOohAJU",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
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
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kesiapan Survival",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Teknik dasar & pertolongan pertama.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
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

  Widget _buildCompassCard() {
    return InkWell(
      onTap: controller.openCompass,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFCA98),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.explore, color: AppTheme.secondary),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Kompas Digital",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A532A),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF7A532A)),
          ],
        ),
      ),
    );
  }

  Widget _buildSurvivalGrid() {
    return GridView.builder(
      itemCount: controller.survivalMenus.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final item = controller.survivalMenus[index];
        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            controller.openMenu(item["title"].toString());
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD4C3BF).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIcon(item["icon"].toString()),
                  color: AppTheme.primary,
                  size: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  item["title"].toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildP3KCard() {
    return InkWell(
      onTap: () {
        controller.openMenu("P3K");
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF4E342E),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.medical_services, color: Color(0xFFC19C94)),
                    SizedBox(width: 8),
                    Text(
                      "Pertolongan Pertama (P3K)",
                      style: TextStyle(
                        color: Color(0xFFC19C94),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFBA1A1A).withValues(alpha: 0.2),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        leading: const Icon(Icons.emergency_share, color: Color(0xFFBA1A1A)),
        title: const Text(
          "Kontak Darurat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primary,
          ),
        ),
        children: [
          _buildEmergencyItem("Polisi", "110"),
          _buildEmergencyItem("Ambulans / Rumah Sakit", "118/119"),
          _buildEmergencyItem("Pemadam Kebakaran", "113"),
          _buildEmergencyItem("Tim SAR", "115"),
        ],
      ),
    );
  }

  Widget _buildEmergencyItem(String title, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: AppTheme.onSurfaceVariant)),
          InkWell(
            onTap: () {
              controller.callEmergency(number);
            },
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFFBA1A1A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDBCF).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb, color: AppTheme.primary),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              "Periksa kotak P3K setiap 6 bulan untuk memastikan obat belum kedaluwarsa.",
              style: TextStyle(color: Color(0xFF5E3F35), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case "terrain":
        return Icons.terrain;
      case "cabin":
        return Icons.cabin;
      case "join_inner":
        return Icons.join_inner;
      case "settings_input_antenna":
        return Icons.settings_input_antenna;
      case "healing":
        return Icons.healing;
      case "personal_injury":
        return Icons.personal_injury;
      case "pest_control_rodent":
        return Icons.pest_control_rodent;
      case "medical_information":
        return Icons.medical_information;
      default:
        return Icons.circle;
    }
  }
}