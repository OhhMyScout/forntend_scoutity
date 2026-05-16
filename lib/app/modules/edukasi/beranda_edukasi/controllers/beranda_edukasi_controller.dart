// lib/app/modules/edukasi/beranda_edukasi/controllers/beranda_edukasi_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BerandaEdukasiController extends GetxController {
  final materiList = [
    {
      "title": "Sandi Morse",
      "description":
          "Seni berkomunikasi menggunakan titik dan garis untuk mengirimkan pesan rahasia.",
      "icon": Icons.radio,
      "color": const Color(0xFF4E342E),
    },
    {
      "title": "Semaphore",
      "description":
          "Teknik pengiriman sandi jarak jauh menggunakan sepasang bendera berwarna mencolok.",
      "icon": Icons.flag,
      "color": const Color(0xFFFFCA98),
    },
    {
      "title": "Tali Temali",
      "description":
          "Keterampilan dasar menyambung tali dan membuat ikatan untuk berbagai kebutuhan.",
      "icon": Icons.straighten,
      "color": const Color(0xFFE5E2DD),
    },
  ];

  void openSejarah() {
    Get.snackbar(
      "Sejarah",
      "Membuka halaman sejarah kepramukaan",
    );
  }

  void openMateri(String title) {
    Get.snackbar(
      "Materi",
      "Membuka materi $title",
    );
  }

  void lihatSemua() {
    Get.snackbar(
      "Materi",
      "Menampilkan semua materi",
    );
  }
}