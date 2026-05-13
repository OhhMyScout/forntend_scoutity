import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/beranda_profile_controller.dart';
import '../../../theme/tabbar.dart';

class BerandaProfileView extends GetView<BerandaProfileController> {
  const BerandaProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const bgColor = Color(0xFFFAF7F2);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: const Text(
          'Scoutify',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      bottomNavigationBar: const AppTabBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Hero Section (Foto & Nama)
            _buildHeroSection(),
            const SizedBox(height: 24),

            // Info Detail & Sidebar Actions
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildInfoCard(primaryColor)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildActionMenu(primaryColor)),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildInfoCard(primaryColor),
                    const SizedBox(height: 20),
                    _buildActionMenu(primaryColor),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBhEh1v1fcpsCJDgbK6XEUEyMWC9-bIl35rhVFrHoXWNs4ciWW0ifwG2DkaPz481o2gd1Z-eqBmFGK4oK42O0I7gnndm9MOEkPj3j1uGy0bn4wUFlB_vvB8Y-4u5MOdn2rrOuoyjCsB4Wv-9YVuqSpxIWK8GXN5OpvtG6z_aqhKuiqvIxtNZgS0-6ZCFV9Fn6Ga-VIBwGf3ExgzrtrV7ukW0Jbz_-6YnoZjxwdubyap7nnvuNaiTZdZP8pjGoUGiT0vnJ4l4QlG0aI'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () => controller.changeProfilePhoto(), // // Ganti Foto
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFF361F1A), shape: BoxShape.circle),
                    child: const Icon(Icons.edit, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(controller.name.value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          Obx(() => Text(controller.email.value, style: const TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Color primary) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Informasi Akun", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
          const SizedBox(height: 20),
          _itemTile("Provinsi", controller.province),
          _itemTile("Gugus Depan", controller.gugusDepan),
          _itemTile("Tanggal Bergabung", controller.joinDate),
        ],
      ),
    );
  }

  Widget _itemTile(String label, RxString value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF7D562D), fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Obx(() => Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFF6F3EE), borderRadius: BorderRadius.circular(10)),
            child: Text(value.value, style: const TextStyle(fontSize: 15)),
          )),
        ],
      ),
    );
  }

  Widget _buildActionMenu(Color primary) {
    return Column(
      children: [
        _btn(Icons.person_outline, "Edit Profile", primary, Colors.white, () => controller.editProfile()), // // Edit Profile
        const SizedBox(height: 12),
        _btn(Icons.settings_outlined, "Settings", Colors.white, Colors.black87, () => controller.openSettings(), border: true), // // Settings
        const SizedBox(height: 16),
        // _buildPremiumBanner(),
        const SizedBox(height: 12),
        _btn(Icons.logout, "Keluar", const Color(0xFFFFDAD6), const Color(0xFF93000A), () => controller.logout()), // // Keluar
      ],
    );
  }

  // Widget _buildPremiumBanner() {
  //   return Container(
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(color: const Color(0xFF513329), borderRadius: BorderRadius.circular(16)),
  //     child: Column(
  //       children: [
  //         const Text("Scoutify Pro", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  //         const SizedBox(height: 12),
  //         ElevatedButton(
  //           onPressed: () => controller.upgradeToPro(), // // Upgrade
  //           style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFCA98), foregroundColor: Colors.brown),
  //           child: const Text("Upgrade Sekarang"),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _btn(IconData icon, String txt, Color bg, Color text, VoidCallback press, {bool border = false}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: press,
        icon: Icon(icon, size: 20),
        label: Text(txt),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: text,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: border ? const BorderSide(color: Color(0xFFD4C3BF)) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}