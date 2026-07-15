import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../profile/beranda_profile/controllers/beranda_profile_controller.dart';
import '../../profile/feedback/views/feedback_view.dart';
import '../../privacy_policy/views/privacy_policy_view.dart';
import '../../profile/edit_profile/views/edit_profile_view.dart';
import 'package:http/http.dart' as http;
import '../../data/session_manager.dart';
import '../../data/api_endpoint.dart';
// Sesuaikan path import dengan struktur folder Anda
import '../../reg-pembina/form_pembina/views/form_pembina_view.dart';

class SettingsController extends GetxController {
  RxBool isNotificationActive = false.obs;

  // Mengamati status pendaftaran pembina secara reaktif
  // Nilai default awal bisa kosong '', 'pending', 'approved', atau 'none'
  RxString statusPembina = ''.obs;
  RxBool isLoadingStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStatusPembina(); // Ambil status pembina saat halaman settings dibuka
  }

  // Fungsi untuk mengambil status pengajuan pembina dari backend FastAPI
  Future<void> fetchStatusPembina() async {
    try {
      isLoadingStatus.value = true;

      // Sesuaikan endpoint ini dengan route check status di FastAPI Anda
      // Contoh: /api/pengajuan/pembina/status/{user_id}
      final response = await http.get(
        Uri.parse('${ApiEndpoint.baseUrl}/pengajuan/pembina/status/${SessionManager.userId}'),
        headers: SessionManager.apiHeader,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Misalkan backend mengembalikan field 'status': 'pending' / 'approved' / 'none'
        statusPembina.value = data['status'] ?? 'none';
      }
    } catch (e) {
      print("Error fetching pembina status: $e");
    } finally {
      isLoadingStatus.value = false;
    }
  }

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

  void changeProfile() {
    Get.to(() => const EditProfileView());
  }

  void openPrivacyPolicy() {
    Get.toNamed('/privacy-policy');
  }

  void sendFeedback() {
    Get.toNamed('/feedback');
  }

  void goToFormPembina() async {
    // HARUS pakai Get.to agar halaman settings tidak dihancurkan
    final result = await Get.to(() => const FormPembinaView());
    
    if (result == true) {
      fetchStatusPembina();
    }
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
          Icon(Icons.explore, size: 60, color: secondaryColor.withOpacity(0.8)),
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
        child: const Text(
          'Tutup',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
