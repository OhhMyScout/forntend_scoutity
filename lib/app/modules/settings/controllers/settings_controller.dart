import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../profile/beranda_profile/controllers/beranda_profile_controller.dart';
import '../../profile/feedback/views/feedback_view.dart';
import '../../privacy_policy/views/privacy_policy_view.dart';
import '../../profile/edit_profile/views/edit_profile_view.dart';
// Sesuaikan path import dengan struktur folder Anda
import '../../reg-pembina/form_pembina/views/form_pembina_view.dart';


class SettingsController extends GetxController {
  RxBool isNotificationActive = false.obs;

  void toggleNotification(bool value) {
    isNotificationActive.value = value;
    Get.snackbar(
      'Notifikasi',
      value ? 'Notifikasi diaktifkan' : 'Notifikasi dimatikan',
      backgroundColor: Colors.white,
      colorText: const Color(0xFF361F1A),
      snackPosition: SnackPosition.TOP,
    );
  }

// Pastikan Anda mengimpor file halamannya di bagian atas
// Contoh:
// import '../../profile/views/edit_profile_view.dart';
// import '../../privacy/views/privacy_policy_view.dart';
// import '../../feedback/views/feedback_view.dart';

  void changeProfile() {
    // Navigasi ke halaman Ubah Profil
    Get.to(() => const EditProfileView()); 
    
    // Catatan: Jika Anda menggunakan named routes di GetMaterialApp, 
    // Anda bisa menggunakan kode ini:
    // Get.toNamed('/edit-profile');
  }

  void openPrivacyPolicy() {
    // Navigasi ke halaman Kebijakan & Privasi (pakai named route agar binding controller aktif)
Get.toNamed('/privacy-policy');
  }

  void sendFeedback() {
    // Navigasi ke halaman Formulir Umpan Balik (pakai named route agar binding controller aktif)
    Get.toNamed('/feedback');
  }



  void goToFormPembina() {
    Get.to(() => const FormPembinaView());
  }

  Future<void> openScoutifyWebsite() async {
    const url = 'https://scoutify.trycenter.my.id/';
    final Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Gagal',
          'Tidak dapat membuka website saat ini.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat membuka tautan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  void openAboutApp() {
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);

    Get.defaultDialog(
      title: 'Tentang Scoutify',
      titleStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      titlePadding: const EdgeInsets.only(top: 24, bottom: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      radius: 16,
      barrierDismissible: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.explore,
            size: 60,
            color: secondaryColor.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          const Text(
            'Versi 1.0.0',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: secondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Buku Saku Pramuka Digital (Scoutify) hadir untuk memudahkan kegiatan kepramukaan. Saat ini, fitur yang tersedia mencakup menu Pengaturan, Edukasi, Survival, dan Games.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF504442),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: () => Get.back(),
        child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}