import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BerandaSurvivalController extends GetxController {
  
  // Data untuk Horizontal Menu Survival Utama
  final List<Map<String, String>> survivalMenus = [
    {
      "title": "Sinyal Darurat",
      "icon": "settings_input_antenna",
      "route": "/sinyal-darurat", 
    },
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

    final menu = survivalMenus.firstWhere(
      (item) => item["title"] == title,
      orElse: () => {"route": ""},
    );

    final route = menu["route"];

    if (route != null && route.isNotEmpty) {
      Get.toNamed(route);
    } else {
      // Snackbar dengan gaya bahasa petualang
      Get.snackbar(
        "Wah, Jalur Belum Terbuka!",
        "Materi untuk $title sedang disiapkan oleh tim penjelajah kami.",
        backgroundColor: const Color(0xFFFFF8E1), // Kuning gading
        colorText: const Color(0xFFFF8F00), // Kuning amber gelap
        icon: const Icon(Icons.construction, color: Color(0xFFFF8F00)),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  // Fungsi untuk melakukan panggilan darurat otomatis
  Future<void> callEmergency(String number) async {
    // Memilah format seperti "118/119" mengambil nomor utama
    String cleanNumber = number.split('/').last.trim();
    
    final Uri url = Uri(scheme: 'tel', path: cleanNumber);
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar(
          "Gagal Memanggil Bantuan",
          "Perangkat kamu tidak dapat menyambungkan panggilan ke $cleanNumber.",
          backgroundColor: const Color(0xFFFFEBEE),
          colorText: const Color(0xFFB71C1C),
          icon: const Icon(Icons.error_outline, color: Color(0xFFB71C1C)),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 16,
        );
      }
    } catch (e) {
      debugPrint("Error launching dialer: $e");
    }
  }
}