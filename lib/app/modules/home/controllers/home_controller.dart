import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../data/session_manager.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;

  var usernameDisplay = "Kak!".obs;

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
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuBgIfiIbXaJ-J6kfn_RKdsVq2Ifg3W-__UCZuBmLx39tOfDRQzKUPbtfP-fcvWG-bcdUMvS6Gj4xZdWNrNMTcY4fzH9_J_EcXYXmQKUYgMfZ9zMbuL4yweFT9tTndAHx-wKEhFvhKptWmzDMuGcI1WkNB1LVYgcY790Nj0rsnrr-o2IE0PQCqhhj-LrTI1Om9KHw-US2D0ZN5wTnSWkikS9K79tY3QxxeV18LalsbgGEeQol8iHAZfT_oHKI-mLoOJXOxC5Npt6TsA",
    },
    {
      "category": "PRESTASI",
      "title": "Lencana Penjelajah Rimba Kini Tersedia",
      "time": "Kemarin",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuA52WSpB4LbWkmmrtfiX0jVNqxj14ga6ILQj63YgtlZ4oj32QcJMVMmb_hyf44C-Jg3n2PqpdOBLmNSROs-ei4v3ZSmRZ8NHyLDOLBgEiOXqCxV4i09UwppatZkaPWNTcuNLq4pQ98UqU0rJh0g5DWZqE0rT7jxAEhvKke8l11T4Xv5N-SHzAgVwISUwEv6rrFgKGqxVQqg3CI8WGyCU1tRq5y-CmxlhRBpiD8x80IuIbMONe42uJ_aW7fni8HbZnlfuHFI02sc0iw",
    },
  ];

  // ======================================================
  // INIT
  // ======================================================

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  @override
  void onReady() {
    super.onReady();

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (fullname.value.isNotEmpty) {
          Get.snackbar(
            "Selamat Datang",
            "Halo ${fullname.value}",
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF361F1A),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      },
    );
  }

  // ======================================================
  // LOAD CURRENT USER
  // ======================================================

  Future<void> loadCurrentUser() async {
    try {
      isLoading.value = true;

      debugPrint("========== SESSION CHECK ==========");
      debugPrint("TOKEN      : ${SessionManager.token}");
      debugPrint("HAS TOKEN  : ${SessionManager.hasToken()}");
      debugPrint("LOGGED IN  : ${SessionManager.isLoggedIn}");
      debugPrint("USER ID    : ${SessionManager.userId}");
      debugPrint("USERNAME   : ${SessionManager.username}");
      debugPrint("FULLNAME   : ${SessionManager.fullname}");
      debugPrint("EMAIL      : ${SessionManager.email}");
      debugPrint("ROLE       : ${SessionManager.role}");
      debugPrint("POINTS     : ${SessionManager.points}");
      debugPrint("===================================");

      if (!SessionManager.isLoggedIn ||
          !SessionManager.hasToken()) {
        debugPrint("SESSION TIDAK DITEMUKAN");

        Get.offAllNamed(
          Routes.LOGIN,
        );

        return;
      }

      // PERBAIKAN: Gunakan .toString() dan int.tryParse() untuk mencegah crash tipe data
      userId.value = SessionManager.userId?.toString() ?? "";
      username.value = SessionManager.username?.toString() ?? "";
      fullname.value = SessionManager.fullname?.toString() ?? "";
      email.value = SessionManager.email?.toString() ?? "";
      role.value = SessionManager.role?.toString() ?? "";
      province.value = SessionManager.province?.toString() ?? "";
      image.value = SessionManager.image?.toString() ?? "";
      points.value = int.tryParse(SessionManager.points?.toString() ?? "0") ?? 0;

      usernameDisplay.value =
          fullname.value.isNotEmpty
              ? fullname.value
              : username.value.isNotEmpty
                  ? username.value
                  : "Kak!";

      debugPrint("========== USER LOADED ==========");
      debugPrint("ID       : ${userId.value}");
      debugPrint("USERNAME : ${username.value}");
      debugPrint("FULLNAME : ${fullname.value}");
      debugPrint("EMAIL    : ${email.value}");
      debugPrint("ROLE     : ${role.value}");
      debugPrint("POINTS   : ${points.value}");
      debugPrint("=================================");
    } catch (e) {
      debugPrint("HOME ERROR : $e");

      await SessionManager.clear();

      Get.offAllNamed(
        Routes.LOGIN,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // REFRESH USER
  // ======================================================

  Future<void> refreshUser() async {
    await loadCurrentUser();
  }

  // ======================================================
  // LOGOUT
  // ======================================================

  Future<void> logout() async {
    await SessionManager.clear();

    Get.offAllNamed(
      Routes.LOGIN,
    );
  }

  // ======================================================
  // ACTIONS
  // ======================================================

  void onNotificationTap() {
    Get.toNamed(
      Routes.SETTINGS,
    );
  }

  void onShortcutTap(String id) {
    switch (id) {
      case "leaderboard":
        Get.toNamed(
          Routes.LEADERBOARD,
        );
        break;

      case "sejarah":
        Get.toNamed(
          Routes.SEJARAH_PRAMUKA,
        );
        break;

      case "berita":
        Get.toNamed(
          Routes.BERANDA_BERITA,
        );
        break;

      case "permainan":
        Get.toNamed(
          Routes.BERANDA_GAME,
        );
        break;

      default:
        Get.snackbar(
          "Informasi",
          "Menu belum tersedia",
        );
    }
  }

  void onStartDetection() {
    Get.toNamed(
      Routes.SEMAPHORE_DETECT,
    );
  }

  void onSeeAll() {
    Get.toNamed(
      Routes.BERANDA_BERITA,
    );
  }

  void onActivityTap(
    Map<String, String> activity,
  ) {
    Get.snackbar(
      activity["category"] ?? "Aktivitas",
      activity["title"] ?? "",
    );
  }
}