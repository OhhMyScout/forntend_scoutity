import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/panduan_tenda_controller.dart';

class PanduanTendaView extends GetView<PanduanTendaController> {
  const PanduanTendaView({super.key});

  // Konfigurasi Palet Warna Tailwind
  static const Color primary = Color(0xFF361F1A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color secondary = Color(0xFF7D562D);
  static const Color secondaryFixed = Color(0xFFFFDCBD);
  static const Color onSecondaryFixed = Color(0xFF2C1600);
  static const Color onSurfaceVariant = Color(0xFF504442);
  static const Color outline = Color(0xFF827471);
  static const Color surfaceContainer = Color(0xFFF0EDE9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          // AppBar dengan efek menghilang saat di-scroll (SliverAppBar)
          SliverAppBar(
            backgroundColor: background,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: primary),
              onPressed: controller.onBack,
            ),
            title: const Text(
              "Panduan Tenda",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: primary,
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(),
                _buildPreparationSection(),
                _buildProTipCard(),
                _buildStepGuide(),
                _buildDrainageTip(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "https://lh3.googleusercontent.com/aida-public/AB6AXuAfWDOHelkyy0pG9vkuQgMerNa_j1SMWVwEa1h8ViOxmQhvpTPJkkCwDhVm8Hhvmlmn8fnHIab1g6VYXO8yRF0WmbO6fvEMYcjcyWRG1bUVymxPvOaB90PZ_KbiEiNLDXq-aOA4RrJJ5khEbgPuJ1goY0LDmNES1tq8gLXxlexcj5q54UV8ao-xE2HJSeOcSnRNSS-jDjKxO7wlMCgXLeC509g6eat2nhBlMtD3UwcMcHSGqHpo0M2kLMEX73g8ekaB7V83i_2Rdbk",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Membangun Tempat Berteduh",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: secondaryFixed,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        "Tingkat: Pemula",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: onSecondaryFixed,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.timer, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            "20 Menit",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreparationSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Peralatan Yang Dibutuhkan",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: primary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildPrepItem(Icons.holiday_village_rounded, "Tenda", "Inner & Flysheet"),
              _buildPrepItem(Icons.architecture, "Tiang", "Rangka Fiber/Alu"),
              _buildPrepItem(Icons.push_pin_rounded, "Pasak", "Min. 8 Buah"),
              _buildPrepItem(Icons.straighten, "Tali", "Guyline Tahan Air"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrepItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: secondaryFixed.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: secondary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: primary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 11,
                    color: onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProTipCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: secondaryFixed.withValues(alpha: 0.2),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            topLeft: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
          border: const Border(
            left: BorderSide(color: secondary, width: 4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: secondary, size: 20),
                SizedBox(width: 8),
                Text(
                  "PRO TIP",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: secondary,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "\"Selalu perhatikan arah angin. Pastikan pintu tenda tidak menghadap langsung ke arah datangnya angin kencang untuk menjaga stabilitas.\"",
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: onSurfaceVariant.withValues(alpha: 0.9),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepGuide() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Langkah-langkah",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: primary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Menggunakan ListView untuk list dengan custom timeline painter
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.steps.length,
            itemBuilder: (context, index) {
              final step = controller.steps[index];
              final isLast = index == controller.steps.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline Line & Number
                    SizedBox(
                      width: 40,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          if (!isLast)
                            Positioned(
                              top: 40,
                              bottom: 0,
                              child: Container(
                                width: 2,
                                color: surfaceContainer, // Garis penghubung abu-abu
                              ),
                            ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Card Konten
                    Expanded(
                      child: Obx(() {
                        final isActive = controller.activeStep.value == index;
                        return GestureDetector(
                          onTap: () => controller.toggleStep(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 32),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: isActive 
                                  ? Border.all(color: secondary, width: 2) 
                                  : Border.all(color: Colors.transparent, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step["title"],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  step["desc"],
                                  style: const TextStyle(
                                    fontFamily: 'Urbanist',
                                    fontSize: 15,
                                    color: onSurfaceVariant,
                                    height: 1.5,
                                  ),
                                ),
                                // Jika ada Single Image
                                if (step["image"] != null) ...[
                                  const SizedBox(height: 16),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      step["image"],
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ],
                                // Jika ada Multi Image (Grid)
                                if (step["images"] != null) ...[
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            step["images"][0],
                                            height: 96,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            step["images"][1],
                                            height: 96,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrainageTip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.water_drop, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Drainase Air",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Jika diprediksi hujan, buatlah parit kecil di sekeliling tenda agar air tidak menggenang di bawah dasar tenda.",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
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
}