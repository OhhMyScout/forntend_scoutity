import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔥 Import wajib untuk cek session di HP fisik
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  // ===========================================================================
  // STATE MANAGEMENT REAKTIF GETX
  // ===========================================================================
  var usernameDisplay = "Kak!".obs; // Menampung nama panggilan user secara dinamis
  var isLoading = true.obs;         // Menangani state loading saat booting data internal

  // ===========================================================================
  // DATA LIST DATASET BAWAAN KAMU BRAY
  // ===========================================================================
  // Menambahkan parameter 'id' yang unik untuk mempermudah routing data
  final List<Map<String, dynamic>> shortcuts = [
    {"id": "leaderboard", "title": "Papan\nPeringkat", "icon": Icons.leaderboard_rounded},
    {"id": "sejarah", "title": "Sejarah", "icon": Icons.history_edu_rounded},
    {"id": "berita", "title": "Berita", "icon": Icons.newspaper_rounded},
    {"id": "permainan", "title": "Permainan", "icon": Icons.sports_esports_rounded},
  ];

  final List<Map<String, String>> activities = [
    {
      "category": "TIPS & TRIK",
      "title": "5 Cara Mengikat Tali yang Benar untuk Tenda",
      "time": "2 jam yang lalu",
      "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuBgIfiIbXaJ-J6kfn_RKdsVq2Ifg3W-__UCZuBmLx39tOfDRQzKUPbtfP-fcvWG-bcdUMvS6Gj4xZdWNrNMTcY4fzH9_J_EcXYXmQKUYgMfZ9zMbuL4yweFT9tTndAHx-wKEhFvhKptWmzDMuGcI1WkNB1LVYgcY790Nj0rsnrr-o2IE0PQCqhhj-LrTI1Om9KHw-US2D0ZN5wTnSWkikS9K79tY3QxxeV18LalsbgGEeQol8iHAZfT_oHKI-mLoOJXOxC5Npt6TsA",
    },
    {
      "category": "PRESTASI",
      "title": "Lencana Penjelajah Rimba Kini Tersedia",
      "time": "Kemarin",
      "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuA52WSpB4LbWkmmrtfiX0jVNqxj14ga6ILQj63YgtlZ4oj32QcJMVMmb_hyf44C-Jg3n2PqpdOBLmNSROs-ei4v3ZSmRZ8NHyLDOLBgEiOXqCxV4i09UwppatZkaPWNTcuNLq4pQ98UqU0rJh0g5DWZqE0rT7jxAEhvKke8l11T4Xv5N-SHzAgVwISUwEv6rrFgKGqxVQqg3CI8WGyCU1tRq5y-CmxlhRBpiD8x80IuIbMONe42uJ_aW7fni8HbZnlfuHFI02sc0iw",
    },
  ];

  // ===========================================================================
  // SIKLUS HIDUP CONTROLLER (LIFECYCLE)
  // ===========================================================================
  @override
  void onInit() {
    super.onInit();
    checkUserSession(); // 🔥 Eksekusi validasi session detik pertama Home dibuka bray!
  }

  // ===========================================================================
  // LOGIKA UTAMA: CEK TOKEN SESSION USER DI HP FISIK
  // ===========================================================================
  void checkUserSession() async {
    try {
      isLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      String? token = prefs.getString('token');
      String? savedEmail = prefs.getString('email');

      // 🔍 JARING KEAMANAN CADANGAN LAPIS KEDUA: Jika token gaib, paksa balik ke login
      if (token == null || token.isEmpty) {
        print("🚨 HOME VALIDATION: Token kosong! Tendang user ke halaman LOGIN.");
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // 1. Ekstrak nama user dari email (Sebagai nama panggilan sementara di UI bray)
      if (savedEmail != null && savedEmail.isNotEmpty) {
        String cleanName = savedEmail.split('@')[0];
        // Mengubah huruf pertama nama panggilan jadi Kapital bray
        usernameDisplay.value = cleanName.length > 1 
            ? cleanName[0].toUpperCase() + cleanName.substring(1)
            : cleanName;
      }

      isLoading.value = false;

      // 2. Tampilkan Notifikasi Selamat Datang khas Scoutify bray
      Get.snackbar(
        "Selamat Datang Kembali!",
        "Halo, Kak ${usernameDisplay.value}! Siap berpetualang hari ini?",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF361F1A), // Sesuai warna tema coklat Scoutify kamu
        colorText: Colors.white,
        icon: const Icon(Icons.sentiment_satisfied_alt, color: Colors.white),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );

    } catch (e) {
      isLoading.value = false;
      print("🚨 Error Session Check di Home: $e");
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // ===========================================================================
  // FUNGSI INTERAKSI NAVIGASI BAWAAN KAMU BRAY
  // ===========================================================================
  void onNotificationTap() {
    Get.toNamed(Routes.SETTINGS);
  }

  // Fungsi routing berdasarkan ID unik yang dikirim oleh View
  void onShortcutTap(String id) {
    switch (id) {
      case 'leaderboard':
        Get.toNamed(Routes.LEADERBOARD);
        break;
      case 'sejarah':
        Get.toNamed(Routes.SEJARAH_PRAMUKA);
        break;
      case 'berita':
        Get.toNamed(Routes.BERANDA_BERITA);
        break;
      case 'permainan':
        Get.toNamed(Routes.BERANDA_GAME);
        break;
      default:
        Get.snackbar(
          "Informasi", 
          "Modul menu belum dikonfigurasi.",
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
    }
  }

  void onStartDetection() {
    Get.toNamed(Routes.SEMAPHORE_DETECT);
  }

  void onSeeAll() {
    Get.toNamed(Routes.BERANDA_BERITA);
  }

  void onActivityTap(Map<String, String> activity) {
    // Logika tambahan jika kartu aktivitas terkini ditekan di kemudian hari
    Get.snackbar(
      activity["category"] ?? "Aktivitas",
      activity["title"] ?? "Detail artikel belum tersedia",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}