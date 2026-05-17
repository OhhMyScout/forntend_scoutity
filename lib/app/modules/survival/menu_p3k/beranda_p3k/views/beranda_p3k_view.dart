import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/beranda_p3k_controller.dart';

class BerandaP3KView extends GetView<BerandaP3KController> {
  const BerandaP3KView({super.key});

  static const Color primary = Color(0xFF361F1A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color secondary = Color(0xFF7D562D);
  static const Color secondaryContainer = Color(0xFFFFCA98);
  static const Color onSecondaryContainer = Color(0xFF7A532A);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceContainerHighest = Color(0xFFE5E2DD);
  static const Color outlineVariant = Color(0xFFD4C3BF);
  static const Color onSurfaceVariant = Color(0xFF504442);
  static const Color errorColor = Color(0xFFBA1A1A);

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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroBanner(),
                    _buildEmergencyButton(),
                    const SizedBox(height: 24),
                    const Text(
                      "Kategori Penanganan",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCategoriesGrid(),
                    const SizedBox(height: 32),
                    _buildKitChecklistSection(),
                    const SizedBox(height: 24),
                    _buildQuickTipsSection(),
                    const SizedBox(height: 32),
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0x1F827471), width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: primary),
            onPressed: controller.onBack,
          ),
          const SizedBox(width: 8),
          const Text(
            "Pertolongan Pertama",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuCsfAwFKr8uc79J4Ml8KPNR4YPxXJhwQJbMUFSCn-CHwSxAOb4OGLD7mL4_fywoLV-e7osUVZ3-PP9TZRcZC9qi5l6o-FjFQ6JhKwEHvo9HT0Zz6VSqUQ8V7mHfZgGjwE0bM3iXGtccbYBI1DCGF11voEtkcKDNccDqfHgaiQkEWOpuhgCnSBJPTvNJ9duErK-En5ozMqCujBfakLbTW1B_LbVg60sB2Gvhbn6S6u3MhxcKNld-5CvlyJoJxcc0MTv-ec2ifzz8p04",
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
                      primary.withValues(alpha: 0.8),
                      primary.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Siap Sedia di Setiap Kondisi",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Panduan darurat pramuka modern.",
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
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

  Widget _buildEmergencyButton() {
    return Material(
      color: errorColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      shadowColor: errorColor.withValues(alpha: 0.3),
      child: InkWell(
        onTap: controller.callEmergency,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emergency, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                "PANGGIL BANTUAN (112)",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      itemCount: controller.penangananList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (context, index) {
        final item = controller.penangananList[index];
        final bool isRjp = item["id"] == "rjp";

        return Material(
          color: isRjp ? const Color(0xFF4E342E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => controller.goToDetail(item),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isRjp ? Colors.transparent : outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isRjp ? const Color(0xFFE5BEB5) : secondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      item["icon"],
                      color: isRjp ? primary : onSecondaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item["title"],
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isRjp ? const Color(0xFFC19C94) : primary,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildKitChecklistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Isi Tas P3K",
              style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20, color: primary),
            ),
            Text(
              "12 Item Esensial",
              style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w600, fontSize: 13, color: secondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildChecklistItem("Kasa Steril & Perban", "Berbagai ukuran untuk menutup luka."),
        _buildChecklistItem("Antiseptik & Alkohol", "Membersihkan area sekitar luka."),
        _buildChecklistItem("Gunting & Pinset", "Alat pemotong dan pengambil serpihan."),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: controller.showFullChecklist,
            child: const Text(
              "Lihat Checklist Lengkap",
              style: TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: secondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistItem(String title, String desc) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x1F827471), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: secondary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 14, color: primary)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(fontFamily: 'Urbanist', fontSize: 12, color: onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tip Cepat",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20, color: primary),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: Color(0xFFFFDBCF), shape: BoxShape.circle),
                child: const Icon(Icons.lightbulb, color: Color(0xFF381E15), size: 20),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Menangani Orang Pingsan",
                      style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 14, color: primary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Baringkan telentang, angkat kaki 30cm lebih tinggi dari jantung. Pastikan sirkulasi udara berjalan dengan baik.",
                      style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: onSurfaceVariant, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}