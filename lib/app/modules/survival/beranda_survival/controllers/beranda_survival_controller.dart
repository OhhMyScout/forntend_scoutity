import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BerandaSurvivalController extends GetxController {
  
  // Data untuk Grid Menu Survival Utama
  // Menggunakan icon string yang sudah kamu daftarkan di switch-case View
  final List<Map<String, String>> survivalMenus = [
    {
      "title": "Bertahan Hidup",
      "icon": "terrain",
      "route": "/bertahan-hidup",
    },
    {
      "title": "Panduan Tenda",
      "icon": "cabin",
      "route": "/panduan-tenda",
    },
    {
      "title": "Tali Temali",
      "icon": "join_inner",
      "route": "/tali-temali",
    },
    {
      "title": "Sinyal Darurat",
      "icon": "settings_input_antenna",
      "route": "/sinyal-darurat", // Kosongkan atau isi rute jika ada
    },
  ];

  // Data sub-menu P3K untuk ditampilkan di dalam Card P3K
  final List<Map<String, String>> p3kMenus = [
    {
      "title": "Luka", 
      "icon": "healing"
    },
    {
      "title": "Cedera", 
      "icon": "personal_injury"
    },
    {
      "title": "Gigitan", 
      "icon": "pest_control_rodent"
    },
    {
      "title": "Obat", 
      "icon": "medical_information"
    },
  ];

  // Fungsi untuk kembali ke halaman sebelumnya
  void onBack() {
    Get.back();
  }

  // Fungsi untuk membuka halaman Kompas Digital
  void openCompass() {
    Get.toNamed('/kompas');
  }

  // Fungsi dinamis untuk membuka menu berdasarkan judul (title)
  void openMenu(String title) {
    if (title == "P3K") {
      Get.toNamed('/beranda-p3k');
      return;
    }

    // Mencari rute dari list survivalMenus berdasarkan title
    final menu = survivalMenus.firstWhere(
      (item) => item["title"] == title,
      orElse: () => {"route": ""},
    );

    final route = menu["route"];

    if (route != null && route.isNotEmpty) {
      Get.toNamed(route);
    } else {
      // Jika rute belum tersedia
      Get.snackbar(
        "Segera Hadir",
        "Materi untuk $title sedang dalam tahap pengembangan.",
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // Fungsi untuk melakukan panggilan darurat otomatis
  Future<void> callEmergency(String number) async {
    // Jika nomor memiliki format opsi seperti "118/119", kita ambil nomor utamanya saja (119)
    String cleanNumber = number.split('/').last.trim();
    
    final Uri url = Uri(scheme: 'tel', path: cleanNumber);
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar(
          "Panggilan Gagal",
          "Perangkat kamu tidak mendukung panggilan langsung ke $cleanNumber.",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }
}