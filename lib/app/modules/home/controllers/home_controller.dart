import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../data/session_manager.dart';

class HomeController extends GetxController {



  // ======================================================
  // OBSERVABLE STATES
  // ======================================================
  var isLoading = true.obs;
  var usernameDisplay = "Kak!".obs;

  // Static flag agar nilainya bertahan meski controller di-rebuild/direstart
  static bool hasShownWelcome = false;

  // ======================================================
  // USER DATA
  // ======================================================
  var userId = "".obs;
  var username = "".obs;
  var fullname = "".obs;
  var email = "".obs;
  var role = "".obs;
  var province = "".obs;
  var image = "".obs;
  var points = 0.obs;

  // ======================================================
  // SHORTCUT MENU
  // ======================================================
  final List<Map<String, dynamic>> shortcuts = [
    {
      "id": "leaderboard",
      "title": "Papan\nPeringkat",
      "icon": Icons.leaderboard_rounded,
    },
    {
      "id": "sejarah",
      "title": "Sejarah",
      "icon": Icons.history_edu_rounded,
    },
    {
      "id": "berita",
      "title": "Berita",
      "icon": Icons.newspaper_rounded,
    },
    {
      "id": "permainan",
      "title": "Permainan",
      "icon": Icons.sports_esports_rounded,
    },
  ];





  // ======================================================
  // DUMMY ACTIVITY
  // ======================================================
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

  // ======================================================
  // LIFECYCLE METHOD
  // ======================================================

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  @override
  void onReady() {
    super.onReady();
    // onReady dipanggil tepat setelah frame UI selesai dirender,
    // tempat paling aman untuk memunculkan Snackbar, Dialog, atau BottomSheet.
    _showWelcomeSnackbarIfNeeded();
  }

  // ======================================================
  // CORE FUNCTIONS
  // ======================================================

  Future<void> loadCurrentUser() async {
    try {
      isLoading.value = true;

      // Logika Pengecekan Sesi
      if (!SessionManager.isLoggedIn || !SessionManager.hasToken()) {
        debugPrint("SESSION TIDAK DITEMUKAN - Redirecting to Login");
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // Parsing data aman dari SessionManager
      userId.value = SessionManager.userId;
      username.value = SessionManager.username;
      fullname.value = SessionManager.fullname;
      email.value = SessionManager.email;
      role.value = SessionManager.role;
      province.value = SessionManager.province;
      image.value = SessionManager.image;
      points.value = SessionManager.points;

      // Logika Penentuan Nama Tampilan (Fallback)
      if (fullname.value.isNotEmpty) {
        usernameDisplay.value = fullname.value;
      } else if (username.value.isNotEmpty) {
        usernameDisplay.value = username.value;
      } else {
        usernameDisplay.value = "Kak!";
      }

      debugPrint("========== USER LOADED ==========");
      debugPrint("NAMA TAMPIL : ${usernameDisplay.value}");
      debugPrint("ROLE        : ${role.value}");
      debugPrint("=================================");

    } catch (e) {
      debugPrint("HOME ERROR : $e");
      await SessionManager.clear();
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  // Dipisah agar loadCurrentUser tetap bersih dan fokus pada pengolahan data
  void _showWelcomeSnackbarIfNeeded() {
    // Memastikan data nama sudah ada dan welcome belum pernah ditampilkan
    if (!hasShownWelcome && usernameDisplay.value != "Kak!") {
      hasShownWelcome = true; // Kunci agar tidak muncul lagi

      Get.closeAllSnackbars(); // Tutup snackbar lain yang mungkin sedang aktif

      Get.snackbar(
        "Selamat Datang",
        "Halo ${usernameDisplay.value}, siap untuk berpetualang?",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF361F1A),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        icon: const Icon(Icons.waving_hand_rounded, color: Colors.amber),
        animationDuration: const Duration(milliseconds: 400),
        isDismissible: true,
      );
    }
  }

  Future<void> refreshUser() async {
    await loadCurrentUser();
  }

  Future<void> logout() async {
    // Reset flag agar saat user login dengan akun lain, pesan welcome muncul lagi
    hasShownWelcome = false;
    
    await SessionManager.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

  // ======================================================
  // ROUTING & ACTIONS
  // ======================================================

  void onNotificationTap() {
    Get.toNamed(Routes.SETTINGS);
  }

  void onShortcutTap(String id) {
    switch (id) {
      case "leaderboard":
        Get.toNamed(Routes.LEADERBOARD);
        break;
      case "sejarah":
        Get.toNamed(Routes.SEJARAH_PRAMUKA);
        break;
      case "berita":
        Get.toNamed(Routes.BERANDA_BERITA);
        break;
      case "permainan":
        Get.toNamed(Routes.BERANDA_GAME);
        break;
      default:
        Get.snackbar(
          "Informasi", 
          "Menu belum tersedia",
          backgroundColor: Colors.grey.shade800,
          colorText: Colors.white,
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
    Get.snackbar(
      activity["category"] ?? "Aktivitas",
      activity["title"] ?? "",
      backgroundColor: Colors.white,
      colorText: const Color(0xFF361F1A),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ]
    );
  }
}