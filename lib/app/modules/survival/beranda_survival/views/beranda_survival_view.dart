import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/beranda_survival_controller.dart';
import '../../../theme/tabbar.dart';

class BerandaSurvivalView extends GetView<BerandaSurvivalController> {
  const BerandaSurvivalView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);
    const bgColor = Color(0xFFFCF9F4);
    const accentColor = Color(0xFFFFCA98);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: bgColor,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: primaryColor),
              onPressed: () => controller.goBack(),
            ),
          ),
        ),
        title: const Text(
          'Survival & P3K',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      bottomNavigationBar: const AppTabBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HERO BANNER ---
            _buildModernHero(accentColor, primaryColor),
            const SizedBox(height: 28),

            // --- SECTION TITLE ---
            _buildSectionHeader("Peralatan Utama"),
            const SizedBox(height: 16),
            _buildToolCard(
              "Kompas Digital",
              "Navigasi presisi untuk medan terbuka.",
              Icons.explore_rounded,
              secondaryColor,
              () => controller.openCompass(),
            ),
            const SizedBox(height: 32),

            // --- BENTO GRID SECTION ---
            _buildSectionHeader("Panduan Lapangan"),
            const SizedBox(height: 16),
            _buildBentoGrid(context, primaryColor, secondaryColor, accentColor),
            const SizedBox(height: 32),

            // --- TIPS CARD ---
            _buildPremiumTips(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF361F1A),
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildModernHero(Color accent, Color primary) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD6zF2B-k4zBAFcZ2CDhy-YCEjFO611-0avPHBYhluxwFFRQpVQsos2L0xoXTwcoKBcNW_Fo5Sur4G6R9Xt37rHVNn4ecLzooBuqWmO1ZRdy__alWAEtD0_T6TbLii8UswANCYEaUcKX6I5KZtMWCC56BLmll4bG-0V2aSVBFrh7fpi6hh2x_t2Nc64LC1hINrsn94Nsg5ZMUK_Xpsnq1gpAKkQ0S_1a8UsKjfkc71moZdU0nwUSfGdFBHjps5g1s6y6Sr8SOohAJU',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_rounded, size: 14, color: Color(0xFF7A532A)),
                      SizedBox(width: 4),
                      Text("ESENSIAL", 
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF7A532A))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Kesiapan adalah Kunci", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF361F1A))),
                const SizedBox(height: 8),
                Text(
                  "Pengetahuan P3K bukan sekadar keahlian tambahan, ia adalah garis pertahanan pertama Anda.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildToolCard(String title, String desc, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E2DD), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF361F1A))),
                  const SizedBox(height: 2),
                  Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoGrid(BuildContext context, Color primary, Color secondary, Color accent) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: context.width > 600 ? 3 : 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 0.9,
      children: [
        _buildBentoItem("Prinsip P3K", "P.A.T.U.T", Icons.medical_information_rounded, primary, const Color(0xFFF0EDE9)),
        _buildBentoItem("Luka & Patah", "Penanganan Medis", Icons.healing_rounded, secondary, const Color(0xFFFFDCBD)),
        _buildBentoSurvival(primary),
        _buildBentoEmergency(),
      ],
    );
  }

  Widget _buildBentoItem(String title, String sub, IconData icon, Color color, Color bg) {
    return InkWell(
      onTap: () => controller.openDetail(title),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E2DD), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 24),
            ),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoSurvival(Color primary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: const NetworkImage("https://www.transparenttextures.com/patterns/carbon-fibre.png"),
          opacity: 0.1,
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.terrain_rounded, color: Colors.white70, size: 24),
          Spacer(),
          Text("Survival", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Text("Teknik Shelter", style: TextStyle(color: Colors.white60, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildBentoEmergency() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Darurat", style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF410002))),
          const Spacer(),
          _emergencyMiniRow("SAR", "115"),
          const SizedBox(height: 2),
          _emergencyMiniRow("Polisi", "110"),
        ],
      ),
    );
  }

  Widget _emergencyMiniRow(String label, String num) {
    return InkWell(
      onTap: () => controller.makeCall(num),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          Text(num, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFFBA1A1A))),
        ],
      ),
    );
  }

  Widget _buildPremiumTips() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFDBCF), Color(0xFFFFE5DE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_circle_rounded, color: Color(0xFF513329), size: 40),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pro Tips", style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF381E15))),
                Text("Pastikan kit P3K berada di lokasi yang mudah dijangkau saat darurat.", 
                  style: TextStyle(fontSize: 12, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}