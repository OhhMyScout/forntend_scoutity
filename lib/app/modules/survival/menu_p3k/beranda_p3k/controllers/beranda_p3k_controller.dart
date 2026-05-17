import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BerandaP3KController extends GetxController {
  
  // Kumpulan data penanganan P3K yang dinamis menggunakan pengetikan tipe data yang ketat
  final List<Map<String, dynamic>> penangananList = [
    {
      "id": "luka_ringan",
      "title": "Luka Ringan",
      "icon": Icons.healing,
      "steps": <String>[
        "Bersihkan luka dengan air mengalir atau cairan antiseptik.",
        "Keringkan area sekitar luka menggunakan kasa steril secara perlahan.",
        "Oleskan salep antibiotik jika diperlukan untuk mencegah infeksi.",
        "Tutup luka dengan plester atau kain perban steril agar terhindar dari kotoran.",
      ],
      "pro_tip": "Jangan gunakan kapas langsung pada luka terbuka karena seratnya dapat menempel dan menghambat penyembuhan.",
    },
    {
      "id": "luka_bakar",
      "title": "Luka Bakar",
      "icon": Icons.local_fire_department_rounded,
      "steps": <String>[
        "Dinginkan luka bakar segera dengan air mengalir selama minimal 10-15 menit.",
        "Lepaskan perhiasan atau pakaian di sekitar luka sebelum area mulai membengkak.",
        "Tutup luka bakar secara longgar menggunakan kain bersih atau kasa steril.",
        "Jangan memecahkan lepuhan kulit yang muncul untuk mencegah infeksi bakteri.",
      ],
      "pro_tip": "Hindari mengoleskan odol, mentega, atau es batu langsung pada luka bakar karena dapat merusak jaringan kulit lebih dalam.",
    },
    {
      "id": "patah_tulang",
      "title": "Patah Tulang",
      "icon": Icons.architecture,
      "steps": <String>[
        "Imobilisasi atau jangan gerakkan area tubuh yang dicurigai mengalami patah tulang.",
        "Pasang bidai (spalk) sederhana menggunakan kayu datar dan balut dengan mitela secara erat namun tidak menghentikan nadi.",
        "Jika ada luka terbuka, tutup dengan kain bersih sebelum memasang bidai.",
        "Kompres area yang bengkak dengan es yang dibalut kain untuk mengurangi rasa nyeri.",
      ],
      "pro_tip": "Jangan pernah mencoba memaksa mengembalikan posisi tulang yang bergeser ke bentuk semula secara mandiri.",
    },
    {
      "id": "rjp",
      "title": "Teknik RJP",
      "icon": Icons.monitor_heart_rounded,
      "steps": <String>[
        "Pastikan lingkungan sekitar aman bagi korban dan penolong (Aman Diri, Aman Lingkungan, Aman Pasien).",
        "Cek respon korban dengan menepuk bahu dan panggil dengan lantang.",
        "Jika tidak ada respon dan nadi tidak teraba, lakukan kompresi dada sebanyak 30 kali di pusat dada dengan kedalaman 5-6 cm.",
        "Berikan 2 kali bantuan napas buatan, lalu ulangi siklus kompresi hingga bantuan medis tiba.",
      ],
      "pro_tip": "Kecepatan kompresi dada yang ideal berkisar antara 100 hingga 120 kali per menit (sesuai irama lagu 'Stayin' Alive').",
    },
  ];

  void onBack() {
    Get.back();
  }

  // Fungsi navigasi membawa argumen data item lengkap ke halaman detail
  void goToDetail(Map<String, dynamic> data) {
    Get.toNamed('/detail-p3k', arguments: data);
  }

  // Fungsi panggilan darurat medis 112 otomatis
  Future<void> callEmergency() async {
    final Uri url = Uri(scheme: 'tel', path: '112');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        Get.snackbar(
          "Gagal",
          "Tidak dapat melakukan panggilan otomatis ke nomor 112.",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      debugPrint("Error launching emergency call: $e");
      Get.snackbar(
        "Error",
        "Terjadi kesalahan saat mencoba melakukan panggilan.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void showFullChecklist() {
    // Mengarahkan ke rute halaman checklist P3K
    Get.toNamed('/p3k-checklist');
  }
}