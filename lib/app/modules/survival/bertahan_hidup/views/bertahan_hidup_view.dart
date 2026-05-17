import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bertahan_hidup_controller.dart';

class BertahanHidupView extends GetView<BertahanHidupController> {
  const BertahanHidupView({super.key});

  // Konfigurasi Palet Warna dari Desain Tailwind
  static const Color primary = Color(0xFF361F1A);
  static const Color secondary = Color(0xFF7D562D);
  static const Color secondaryContainer = Color(0xFFFFCA98);
  static const Color onSecondaryContainer = Color(0xFF7A532A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceVariant = Color(0xFFE5E2DD);
  static const Color outline = Color(0xFF827471);
  static const Color onSurfaceVariant = Color(0xFF504442);
  static const Color errorColor = Color(0xFFBA1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          // AppBar dengan efek Blur (Material 3)
          SliverAppBar(
            backgroundColor: background.withValues(alpha: 0.9),
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 4,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: primary),
              onPressed: controller.onBack,
            ),
            title: const Text(
              "Bertahan Hidup",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: primary,
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: 32),
                  
                  // Kumpulan Accordion
                  _buildAccordionItem(
                    index: 0,
                    icon: Icons.local_fire_department_rounded,
                    title: "Teknik Membuat Api",
                    subtitle: "Api unggun, gesekan, lensa",
                    content: _buildApiContent(),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildAccordionItem(
                    index: 1,
                    icon: Icons.map_outlined,
                    title: "Navigasi Peta",
                    subtitle: "Kontur, orientasi, legenda",
                    content: _buildPetaContent(),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildAccordionItem(
                    index: 2,
                    icon: Icons.explore_outlined,
                    title: "Membaca Kompas",
                    subtitle: "Azimuth, arah mata angin",
                    content: _buildKompasContent(),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildAccordionItem(
                    index: 3,
                    icon: Icons.water_drop_outlined,
                    title: "Air & Makanan",
                    subtitle: "Purifikasi, tanaman liar",
                    content: _buildAirMakananContent(),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildAccordionItem(
                    index: 4,
                    icon: Icons.cabin_rounded,
                    title: "Shelter Darurat",
                    subtitle: "A-Frame, Lean-to",
                    content: _buildShelterContent(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HERO SECTION
  // =========================================================
  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 192,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuA_MyrEtHs9kyietLSLECIhiXMv9PuLXfn3gE7urpG5FkP1Bm87etQxglkLEWD8mElerdqgGxG4p0LslUGdkG6_-Qvvp-Bj-gn03SDwb0SuvOp6aA7T01MbH8TexEtbyxorw9wx_kt10UrLuuPeL5qO54XYOMLUn3B6WHLLZDrLcVkJKK5eqABPdUrA5IcJ7BM63d-cY0rYvvSfhwZiw5cehGl3laoBkkEzd3iiXIY06g_bHBOruJxXxJuah_pKjwOmqygxjuaKFi8",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          primary.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Text(
                          "PANDUAN AHLI",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Mastery Rimba",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "Kuasai teknik dasar bertahan hidup di alam liar dengan panduan langkah-demi-langkah yang terstruktur dan praktis.",
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 15,
              color: onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // ACCORDION WIDGET
  // =========================================================
  Widget _buildAccordionItem({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget content,
  }) {
    return Obx(() {
      final isActive = controller.activeAccordionIndex.value == index;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? secondary : Colors.transparent,
            width: isActive ? 1.5 : 1.0,
          ),
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
            // Header Accordion (Bisa diklik)
            InkWell(
              onTap: () => controller.toggleAccordion(index),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: onSecondaryContainer, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: primary,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              color: outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isActive ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.expand_more_rounded, color: outline),
                    ),
                  ],
                ),
              ),
            ),
            
            // Konten Expandable
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: isActive
                  ? Column(
                      children: [
                        const Divider(color: surfaceVariant, height: 1),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: content,
                        ),
                      ],
                    )
                  : const SizedBox(width: double.infinity, height: 0),
            ),
          ],
        ),
      );
    });
  }

  // =========================================================
  // KONTEN: API
  // =========================================================
  Widget _buildApiContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "METODE GESEKAN KAYU (HAND DRILL)",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: secondary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        _buildNumberedList(1, "Siapkan papan kayu lunak yang kering dan batang pemutar (spindle)."),
        const SizedBox(height: 12),
        _buildNumberedList(2, "Buat lekukan kecil pada papan dan putar spindle dengan telapak tangan secara cepat dan konsisten."),
        const SizedBox(height: 12),
        _buildNumberedList(3, "Setelah muncul bara (ember), pindahkan ke sarang burung (tinder bundle) dan tiup perlahan."),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: const Border(left: BorderSide(color: secondary, width: 4)),
          ),
          child: const Text(
            "\"Gunakan kayu yang benar-benar kering untuk hasil maksimal. Kayu cemara atau kayu randu sangat direkomendasikan.\"",
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontStyle: FontStyle.italic,
              fontSize: 13,
              color: secondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberedList(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(color: primary, shape: BoxShape.circle),
          child: Center(
            child: Text(
              "$number",
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14,
              color: onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // KONTEN: PETA
  // =========================================================
  Widget _buildPetaContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Garis Kontur",
                      style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: primary),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Garis yang menghubungkan titik ketinggian yang sama. Semakin rapat garisnya, semakin terjal medannya.",
                      style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Legenda",
                      style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: primary),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Kamus simbol peta. Biru untuk perairan, hijau untuk vegetasi, cokelat untuk kontur tanah.",
                      style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "LANGKAH ORIENTASI MEDAN",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: secondary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Pegang peta secara horizontal, cocokan posisi utara peta dengan utara kompas, kemudian identifikasi bentang alam di sekitar Anda (bukit, sungai, lembah).",
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 14,
            color: onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // =========================================================
  // KONTEN: KOMPAS
  // =========================================================
  Widget _buildKompasContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Ilustrasi Kompas Kustom
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: secondary, width: 4),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: 45 * 3.1415926535 / 180, // Rotate 45 degrees
                child: Container(
                  width: 4,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [outline, errorColor],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const Positioned(top: 4, child: Text("N", style: TextStyle(fontWeight: FontWeight.bold, color: primary))),
              const Positioned(right: 8, child: Text("E", style: TextStyle(fontWeight: FontWeight.bold, color: outline))),
              const Positioned(bottom: 4, child: Text("S", style: TextStyle(fontWeight: FontWeight.bold, color: outline))),
              const Positioned(left: 8, child: Text("W", style: TextStyle(fontWeight: FontWeight.bold, color: outline))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Ilustrasi Penentuan Azimuth",
          style: TextStyle(fontFamily: 'Urbanist', fontSize: 12, color: outline),
        ),
        const SizedBox(height: 24),
        
        SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "CARA MENENTUKAN AZIMUTH",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: secondary,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Bidik objek sasaran menggunakan visir kompas prisma. Baca angka derajat yang sejajar dengan garis rambut di kaca pembesar.",
                style: TextStyle(fontFamily: 'Urbanist', fontSize: 14, color: onSurfaceVariant, height: 1.5),
              ),
              const SizedBox(height: 12),
              _buildBulletPoint("Pastikan kompas dalam posisi datar (horizontal)."),
              _buildBulletPoint("Jauhkan dari benda logam/magnetik."),
              _buildBulletPoint("Gunakan teknik 'Back Azimuth' untuk kembali ke titik awal."),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8),
            child: Icon(Icons.circle, size: 6, color: onSurfaceVariant),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // KONTEN: AIR & MAKANAN
  // =========================================================
  Widget _buildAirMakananContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "FILTRASI AIR DARURAT",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: secondary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Gunakan botol plastik terbalik yang dipotong ujungnya. Lapisi dari atas ke bawah:",
          style: TextStyle(fontFamily: 'Urbanist', fontSize: 14, color: onSurfaceVariant, height: 1.5),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTag("Kapas/Kain"),
            _buildTag("Arang"),
            _buildTag("Pasir Halus"),
            _buildTag("Kerikil"),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          "UJI TANAMAN EDIBLE",
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: secondary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Gunakan \"Universal Edibility Test\": Gosokkan pada kulit, kemudian bibir, kemudian lidah. Tunggu 15 menit setiap tahap untuk reaksi alergi atau pahit berlebihan.",
          style: TextStyle(fontFamily: 'Urbanist', fontSize: 14, color: onSurfaceVariant, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: surfaceVariant,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: primary,
        ),
      ),
    );
  }

  // =========================================================
  // KONTEN: SHELTER
  // =========================================================
  Widget _buildShelterContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Metode Lean-To",
                    style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: primary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Gunakan batang kayu melintang di antara dua pohon, lalu sandarkan ranting-ranting berdaun lebat pada satu sisi untuk menahan angin.",
                    style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: onSurfaceVariant, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "A-Frame",
                    style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: primary),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Mirip dengan Lean-to namun dengan dua sisi miring membentuk huruf 'A'. Sangat efektif untuk mempertahankan panas tubuh.",
                    style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: onSurfaceVariant, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_rounded, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Hindari membangun shelter di dasar lembah (risiko banjir bandang) atau di bawah dahan pohon kering yang rapuh.",
                  style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: Colors.white, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}