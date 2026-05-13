import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/beranda_edukasi_controller.dart';
import '../../../theme/tabbar.dart';

class BerandaEdukasiView extends GetView<BerandaEdukasiController> {
  const BerandaEdukasiView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),

      /// ================= APPBAR =================
      body: CustomScrollView(
        slivers: [
          _buildAppBar(primaryColor),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroHeader(),
                  const SizedBox(height: 40),
                  _buildSejarahSection(primaryColor),
                  const SizedBox(height: 40),
                  _buildMateriSection(primaryColor),
                  const SizedBox(height: 40),
                  _buildKarakterSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      /// ================= TABBAR GLOBAL =================
      bottomNavigationBar: const AppTabBar(),
    );
  }

  // ================= APPBAR =================
  Widget _buildAppBar(Color primary) {
    return const SliverAppBar(
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Text(
        "Edukasi",
        style: TextStyle(color: Color(0xFF361F1A), fontWeight: FontWeight.bold),
      ),
    );
  }

  // ================= HERO =================
  Widget _buildHeroHeader() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
            "https://lh3.googleusercontent.com/aida-public/AB6AXuDJoh57AnLCWTF26VzID-EmINUBcA0DVg3FTg29-E5yUsIqWAlzs5k9PCHv9k4OW-Et-_aijErAr1GLQWWnVLoDZssSJ-zE95Red7I5cpKDr6Z8tVotCmBtl1fTLkAUd21pq7rR-FgAs8HplrhpHFxnJwIu1sd_vVT-OYZ-3JMn3EBcHSE5v4dCIcx2uchWrrZJ4V-yp4TdA3x_wRAVs_O5h9_Khetn2AWBsXoMlpMgNSr21DpGDSY03yDUmXq6rO9PIS6S0FArYKw",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ================= SEJARAH =================
  Widget _buildSejarahSection(Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sejarah Kepramukaan",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Gerakan Pramuka berkembang dari gagasan Lord Baden-Powell.",
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }

  // ================= MATERI =================
  Widget _buildMateriSection(Color primary) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Materi Kepramukaan",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF361F1A),
            ),
          ),
        ),
        const SizedBox(height: 16),

        Column(
          children: controller.materiKepramukaan
              .map((materi) => _buildMateriCard(materi, primary))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMateriCard(Map<String, dynamic> materi, Color primary) {
    return InkWell(
      onTap: () => controller.goToDetail(materi['route'] ?? ""),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(materi['color']).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.book, color: Color(0xFF361F1A)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    materi['title'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  Text(
                    materi['desc'],
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= KARAKTER =================
  Widget _buildKarakterSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF361F1A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Text(
        "Pembentukan Karakter & Kepemimpinan",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
