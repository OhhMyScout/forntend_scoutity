import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../profile/beranda_profile/controllers/beranda_profile_controller.dart';
import '../controllers/settings_controller.dart';


class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  // Fungsi untuk membuat efek timbul (Neumorphism)
  BoxDecoration _embossedDecoration(Color bgColor) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        // Bayangan gelap di kanan bawah
        BoxShadow(
          color: Colors.brown.withOpacity(0.15),
          blurRadius: 15,
          offset: const Offset(5, 5),
        ),
        // Bayangan terang (putih) di kiri atas
        const BoxShadow(
          color: Colors.white,
          blurRadius: 15,
          offset: Offset(-5, -5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);
    const backgroundColor = Color(0xFFF3EBE1);
    const textSecondary = Color(0xFF504442);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: primaryColor),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE (Timbul)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: _embossedDecoration(backgroundColor),
              child: Row(
                children: [
                  // ambil data user dari controller profile beranda (biar tampil sama seperti halaman profile)
                  Obx(() {
                    final String fullname = (Get.find<BerandaProfileController>().user["fullname"] ?? "").toString().trim();
                    final String role = (Get.find<BerandaProfileController>().user["role"] ?? "").toString().trim();
                    final String imageUrl = (Get.find<BerandaProfileController>().user["image"] ?? "").toString().trim();

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.network(
                                'https://ui-avatars.com/api/?name=Unknown&background=7D562D&color=fff',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.network(
                              'https://ui-avatars.com/api/?name=${Uri.encodeComponent(fullname.isNotEmpty ? fullname : "Unknown")}&background=7D562D&color=fff',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                    );
                  }),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(() {
                      final String fullname = (Get.find<BerandaProfileController>().user["fullname"] ?? "").toString().trim();
                      final String role = (Get.find<BerandaProfileController>().user["role"] ?? "").toString().trim();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullname.isNotEmpty ? fullname : '-',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role.isNotEmpty ? role : '-',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  IconButton(
                    onPressed: controller.changeProfile,
                    icon: const Icon(Icons.edit, color: secondaryColor),
                    tooltip: 'Ubah Profil',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// TOMBOL DAFTAR PEMBINA (Timbul)
            Obx(() {
              // Tampilkan loading kecil jika status sedang dimuat dari backend
              if (controller.isLoadingStatus.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(color: secondaryColor),
                  ),
                );
              }

              // Kondisi 1: Jika berstatus 'pending' (Menunggu Verifikasi) -> Tombol Dinonaktifkan (Disabled)
              if (controller.statusPembina.value == 'pending') {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300, // Warna abu-abu mati menandakan disabled
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.hourglass_empty, color: Colors.black45),
                      SizedBox(width: 12),
                      Text(
                        'Menunggu Verifikasi Pembina',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Kondisi 2: Jika sudah di-approve (Bisa disembunyikan tombolnya atau ganti keterangan)
              if (controller.statusPembina.value == 'approved') {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 12),
                      Text(
                        'Anda Adalah Pembina',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Kondisi Default: Jika belum mendaftar ('none' atau '') -> Tombol Aktif
              return GestureDetector(
                onTap: controller.goToFormPembina,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: _embossedDecoration(backgroundColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.assignment_ind, color: secondaryColor),
                      SizedBox(width: 12),
                      Text(
                        'Daftar Sebagai Pembina',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 32),

            /// PERSONALISASI
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Personalisasi',
                style: TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              decoration: _embossedDecoration(backgroundColor),
              child: Column(
                children: [
                  /// NOTIFICATION TOGGLE
                  Obx(
                    () => SwitchListTile(
                      value: controller.isNotificationActive.value,
                      onChanged: controller.toggleNotification,
                      activeColor: secondaryColor,
                      title: const Text('Notifikasi', style: TextStyle(fontWeight: FontWeight.w500)),
                      secondary: const Icon(Icons.notifications_active, color: secondaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            /// INFORMASI & BANTUAN
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Informasi & Bantuan',
                style: TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              decoration: _embossedDecoration(backgroundColor),
              child: Column(
                children: [
                  ListTile(
                    onTap: controller.openPrivacyPolicy,
                    leading: const Icon(Icons.gavel, color: secondaryColor),
                    title: const Text('Kebijakan & Privasi', style: TextStyle(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  ),
                  Divider(color: primaryColor.withOpacity(0.1), height: 1),
                  ListTile(
                    onTap: controller.sendFeedback,
                    leading: const Icon(Icons.chat_bubble, color: secondaryColor),
                    title: const Text('Umpan Balik', style: TextStyle(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// LINK WEBSITE & ABOUT
            Container(
              decoration: _embossedDecoration(backgroundColor),
              child: Column(
                children: [
                  ListTile(
                    onTap: controller.openScoutifyWebsite,
                    leading: const Icon(Icons.language, color: secondaryColor),
                    title: const Text('Kunjungi Website', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.open_in_new),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  ),
                  Divider(color: primaryColor.withOpacity(0.1), height: 1),
                  ListTile(
                    onTap: controller.openAboutApp,
                    leading: const Icon(Icons.info_outline, color: secondaryColor),
                    title: const Text('Tentang Aplikasi', style: TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// VERSION
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.explore,
                    size: 40,
                    color: primaryColor.withOpacity(0.2),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versi Aplikasi 1.0.0',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}