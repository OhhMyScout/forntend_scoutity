// lib/app/modules/detail_morse/views/detail_morse_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_morse_controller.dart';

class DetailMorseView extends GetView<DetailMorseController> {
  const DetailMorseView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: controller.back,
        ),
        title: const Text(
          "Detail Sandi Morse",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            const SizedBox(height: 24),
            _buildIntroCard(primaryColor),
            const SizedBox(height: 32),
            _buildHistorySection(primaryColor),
            const SizedBox(height: 32),
            _buildMorseGrid(primaryColor, secondaryColor),
            const SizedBox(height: 32),
            _buildMethodsSection(primaryColor, secondaryColor),
            const SizedBox(height: 32),
            _buildCTA(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuA-HgCooyXBwk2VC7bPpHmqAVh62W31IAQPR0SaxsC4xh2R4R9Q_4xKUCLGfQCGqReJCjxVwBwE4DMr4-LMAaVBK20pv8SSVnuoscUePEBn3OUtdPsixXqM6mCqRNhYbzM6nqdEbJRl7upqrlcjU_4umOi2YtcTpc45hnq4J1Pf_B1Bryv2RlaF42pylDCLK4Fsz5LEs8QrKDwuSZSrFUMlcrUYFWfu-FUMrHtD7H38uYqX0sl6yy8He3gycbxKbqPb200paiY6bDo"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, const Color(0xFF361F1A).withOpacity(0.7)],
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(20),
        child: const Text(
          "Bahasa Dalam Ketukan",
          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  Widget _buildIntroCard(Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mengenal Sandi Morse", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
          const SizedBox(height: 12),
          const Text(
            "Sandi Morse adalah sistem representasi huruf, angka, dan tanda baca menggunakan kode titik dan garis. Dalam pramuka, ini adalah simbol ketangguhan.",
            style: TextStyle(color: Colors.black54, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(Color primary) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Sejarah Singkat", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
              const SizedBox(height: 12),
              const Text(
                "Diciptakan oleh Samuel F.B. Morse tahun 1830-an. Penemuan ini merevolusi cara manusia berkomunikasi jarak jauh.",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network("https://lh3.googleusercontent.com/aida-public/AB6AXuA8uFI1D8qIjD2-tC-XQP0l1njSZ6lRjm1LLQXfCwLERv66T1Yg24PMq4deTIOb9IdpeWtLYAigNWMJFdDPJvh_l5sP9lDRs7kR2p_6OS6XsQrKNsuAE_j3rZBMcZBbavJIIJRsEZJSRABoz6LEHnPNGMKnNt0YQdxPKF0DJpXCZm9l-Db0eWNju9rmYg0jvdlEm6cORBZrHKp0Sfrb4cQCYos9FhddzvO2h7nzckCmLDW5s95Vxf4lzqaKVByMWEo6ZuBZT-LNFjE", width: 120, height: 120, fit: BoxFit.cover),
        )
      ],
    );
  }

  Widget _buildMorseGrid(Color primary, Color secondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Daftar Karakter Morse", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF361F1A))),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: controller.alfabetMorse.length,
          itemBuilder: (context, index) {
            final item = controller.alfabetMorse[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item['char']!, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primary)),
                  const SizedBox(height: 4),
                  Text(item['code']!, style: TextStyle(fontSize: 16, color: secondary, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMethodsSection(Color primary, Color secondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Metode Penggunaan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
        const SizedBox(height: 16),
        _methodTile(Icons.flashlight_on, "Cahaya", "Gunakan senter. Ketukan pendek untuk titik, panjang untuk garis.", secondary),
        _methodTile(Icons.campaign, "Suara", "Gunakan peluit. Tiupan pendek untuk titik, tiupan panjang untuk garis.", secondary),
      ],
    );
  }

  Widget _methodTile(IconData icon, String title, String desc, Color secondary) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: secondary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: secondary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCTA(Color primary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF4e342e),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text("Ingin Mencoba Latihan?", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Uji kemampuanmu dengan mini-game tebak sandi morse.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: primary, shape: const StadiumBorder()),
            child: const Text("Mulai Game Sekarang"),
          )
        ],
      ),
    );
  }
}