// lib/app/modules/beranda_survival/controllers/beranda_survival_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final shortcuts = [
    {"title": "Papan\nPeringkat", "icon": Icons.leaderboard_rounded},
    {"title": "Sejarah", "icon": Icons.history_edu_rounded},
    {"title": "Berita", "icon": Icons.newspaper_rounded},
    {"title": "Permainan", "icon": Icons.sports_esports_rounded},
  ];

  final activities = [
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

  void onNotificationTap() {
    Get.toNamed(Routes.SETTINGS);
  }

  void onShortcutTap(String title) {
    switch (title) {
      case 'Leaderboard':
        Get.toNamed(Routes.LEADERBOARD);
        break;

      case 'Edukasi':
        Get.toNamed(Routes.BERANDA_EDUKASI);
        break;

      case 'Game':
        Get.toNamed(Routes.BERANDA_GAME);
        break;

      case 'Survival':
        Get.toNamed(Routes.BERANDA_SURVIVAL);
        break;

      case 'Profile':
        Get.toNamed(Routes.BERANDA_PROFILE);
        break;

      default:
        Get.snackbar("Error", "Halaman belum tersedia");
    }
  }

  void onStartDetection() {
    Get.toNamed(Routes.SEMAPHORE_DETECT);
  }

  void onSeeAll() {
    Get.toNamed(Routes.BERANDA_EDUKASI);
  }
}
