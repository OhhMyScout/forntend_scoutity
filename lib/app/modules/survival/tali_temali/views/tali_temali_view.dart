import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tali_temali_controller.dart';

class TaliTemaliView extends GetView<TaliTemaliController> {
  const TaliTemaliView({super.key});

  // Konfigurasi Palet Warna dari Tailwind Design
  static const Color primary = Color(0xFF361F1A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color onSurfaceVariant = Color(0xFF504442);
  static const Color outline = Color(0xFF827471);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(),
                    const SizedBox(height: 32),
                    _buildKnotsGrid(),
                    const SizedBox(height: 40),
                    _buildTipsBanner(),
                    const SizedBox(height: 40),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: background,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: primary),
                onPressed: controller.onBack,
              ),
              const SizedBox(width: 8),
              const Text(
                "Scoutify",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: primary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          // Navigasi Top Menu bisa diletakkan di sini jika diperlukan
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tali Temali",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 40,
            color: primary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Kumpulan simpul dan ikatan dasar hingga mahir dalam pramuka. Pelajari seni mengikat yang kokoh dan estetis untuk kebutuhan petualanganmu.",
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16,
            color: onSurfaceVariant.withValues(alpha: 0.9),
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildKnotsGrid() {
    // Memecah list simpul menjadi per baris (2 simpul tiap baris) untuk mengatasi overflow tinggi konten
    List<Widget> rows = [];
    for (int i = 0; i < controller.listSimpul.length; i += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildKnotCard(controller.listSimpul[i])),
              const SizedBox(width: 16),
              if (i + 1 < controller.listSimpul.length)
                Expanded(child: _buildKnotCard(controller.listSimpul[i + 1]))
              else
                Expanded(child: Container()), 
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildKnotCard(Map<String, dynamic> knot) {
    return InkWell(
      onTap: () => controller.openDetailSimpul(knot),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  knot['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          knot['title'],
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: primary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: knot['levelColor'],
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          knot['level'],
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: knot['levelTextColor'],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    knot['desc'],
                    style: const TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 13,
                      color: onSurfaceVariant,
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

  Widget _buildTipsBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tips Merawat Tali",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Pastikan perlengkapan scouting-mu selalu dalam kondisi prima. Tali yang terawat adalah kunci keamanan di alam bebas.",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildTipItem("Simpan di tempat yang kering dan teduh"),
              const SizedBox(height: 12),
              _buildTipItem("Bersihkan dari kotoran atau lumpur"),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.openTipsMerawatTali,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Pelajari Lebih Lanjut",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFFFFCA98), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        "Scoutify © 2024 • Refined Wilderness Design System",
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: outline.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}