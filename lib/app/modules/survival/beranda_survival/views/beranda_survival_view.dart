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
      // Warna background bernuansa alam yang lembut (Krem pasir/kertas vintage)
      backgroundColor: const Color(0xFFF9F6F0), 
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 120, // Ruang ekstra untuk TabBar
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildHero(),
                  const SizedBox(height: 24),
                  
                  // Kompas diprioritaskan di tengah atas setelah Hero
                  _buildPriorityCompassCard(),
                  
                  const SizedBox(height: 30),
                  _buildSectionTitle("Kit Bertahan Hidup", Icons.backpack),
                  const SizedBox(height: 16),
                  
                  // Menu dijadikan horizontal agar ringkas dan lucu
                  _buildHorizontalSurvivalMenu(),
                  
                  const SizedBox(height: 30),
                  _buildSectionTitle("Pusat Darurat", Icons.warning_rounded),
                  const SizedBox(height: 16),
                  
                  _buildP3KCard(),
                  const SizedBox(height: 16),
                  _buildEmergencyCard(),
                  const SizedBox(height: 16),
                  _buildTipsCard(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AppTabBar(currentIndex: 3), // Sesuaikan index dengan TabBar kamu
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.park, color: Color(0xFF2E7D32)),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Halo, Petualang!",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF5D4037),
                fontFamily: "Poppins",
              ),
            ),
            Text(
              "Survival Hub",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E2723),
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                "https://sipjkdlfjzmxptldxgxa.supabase.co/storage/v1/object/public/images/survival.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFEFEBE1),
                  child: const Icon(Icons.landscape, size: 50, color: Colors.grey),
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
                      const Color(0xFF1B5E20).withValues(alpha: 0.8), // Nuansa hijau gelap
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Siap Siaga",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Kesiapan Survival",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
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

  // Desain baru untuk kompas yang jauh lebih menonjol
  Widget _buildPriorityCompassCard() {
    return Container(
      // Margin bawah untuk memberi ruang pada bayangan solid
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 105, 66, 3), // Warna hijau ceria & segar
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          // Bayangan solid (tanpa blur) menciptakan efek tombol fisik 3D yang lucu!
          BoxShadow(
            color: Color.fromARGB(255, 72, 41, 0), // Hijau lebih gelap untuk bayangan bawah
            offset: Offset(0, 6),
            blurRadius: 0, 
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.openCompass,
          borderRadius: BorderRadius.circular(24),
          // Percikan warna putih transparan saat diklik
          splashColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                // Ikon Kompas Bulat yang menonjol
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.explore_rounded,
                    color: Color(0xFFFF8F00), // Warna kuning amber ceria
                    size: 34,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Teks yang lebih friendly dan simpel
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Buka Kompas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Poppins",
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Yuk, cari arah jalanmu!",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Ikon Panah Bulat di Ujung
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255), // Warna hijau sedikit lebih gelap dari background
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: const Color.fromARGB(255, 105, 66, 3),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6D4C41), size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723), // Warna coklat gelap
            fontFamily: "Poppins",
          ),
        ),
      ],
    );
  }

  // Perubahan grid menjadi Horizontal List yang lucu
  Widget _buildHorizontalSurvivalMenu() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      // Tambahan padding bawah agar bayangan solid tidak terpotong (ter-clip) oleh ScrollView
      padding: const EdgeInsets.only(bottom: 8), 
      child: Row(
        children: controller.survivalMenus.map((item) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 105, // Sedikit dilebarkan agar teks tidak terlalu sempit
              // Margin bawah untuk memberi ruang bagi bayangan 3D
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFD7CCC8), // Border coklat terang
                  width: 2,
                ),
                boxShadow: const [
                  // Efek 3D timbul (Shadow solid)
                  BoxShadow(
                    color: Color(0xFFA1887F), // Coklat agak gelap untuk bayangan bawah
                    offset: Offset(0, 5),
                    blurRadius: 0, 
                  )
                ]
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  // Radius sedikit lebih kecil dari Container luar agar efek klik tidak menimpa border
                  borderRadius: BorderRadius.circular(18), 
                  onTap: () => controller.openMenu(item["title"].toString()),
                  // Percikan warna saat ditekan (Warna kuning/coklat muda agar senada)
                  splashColor: const Color(0xFFFFE082).withValues(alpha: 0.4),
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFF8E1), // Kuning gading
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIcon(item["icon"].toString()),
                            color: const Color(0xFFFF8F00), // Kuning amber
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item["title"].toString(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D4037), // Coklat gelap
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildP3KCard() {
    return InkWell(
      onTap: () => controller.openMenu("P3K"),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFFFCDD2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medical_services, color: Color(0xFFD32F2F)),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Pertolongan Pertama",
                  style: TextStyle(
                    color: Color(0xFFB71C1C),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFD32F2F),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFEF9A9A),
          width: 1.5,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        leading: const Icon(Icons.emergency_share, color: Color(0xFFD32F2F), size: 28),
        title: const Text(
          "Panggilan Darurat",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFB71C1C),
            fontSize: 16,
          ),
        ),
        children: [
          const Divider(color: Color(0xFFFFCDD2)),
          _buildEmergencyItem("Polisi", "110", Icons.local_police),
          _buildEmergencyItem("Ambulans", "118/119", Icons.local_hospital),
          _buildEmergencyItem("Pemadam Api", "113", Icons.fire_truck),
          _buildEmergencyItem("Tim SAR", "115", Icons.support_agent),
        ],
      ),
    );
  }

  Widget _buildEmergencyItem(String title, String number, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFFD32F2F).withValues(alpha: 0.7)),
              const SizedBox(width: 12),
              Text(
                title, 
                style: const TextStyle(
                  color: Color(0xFF424242),
                  fontWeight: FontWeight.w500,
                )
              ),
            ],
          ),
          InkWell(
            onTap: () => controller.callEmergency(number),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD32F2F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
        color: const Color(0xFFEFEBE1), // Warna tanah muda
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD7CCC8)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wb_incandescent_rounded, color: Color(0xFFFFB300)),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              "Tips: Periksa kotak P3K setiap 6 bulan untuk memastikan obat belum kedaluwarsa.",
              style: TextStyle(
                color: Color(0xFF5D4037), 
                height: 1.5,
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String icon) {
    switch (icon) {
      case "terrain":
        return Icons.terrain_rounded; // Icon dibuat lebih organik dengan versi rounded
      case "cabin":
        return Icons.cabin_rounded;
      case "join_inner":
        return Icons.all_inclusive_rounded; // Mengganti tali dengan icon yang lebih estetik
      case "settings_input_antenna":
        return Icons.cell_tower_rounded;
      default:
        return Icons.nature_people_rounded;
    }
  }
}