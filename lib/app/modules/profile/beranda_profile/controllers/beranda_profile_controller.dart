import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:scoutify/app/routes/app_pages.dart';
import '../../../data/api_endpoint.dart'; // Pastikan path import ApiEndpoint kamu tepat bray

class BerandaProfileController extends GetxController {
  var isLoading = false.obs;

  // Data user reaktif (Nanti bisa diisi via fungsi Get Profile dari Flask bray)
  final user = {
    "name": "Arkan Pratama",
    "email": "aditya.pratama@scoutify.id",
    "points": "1.250 Points",
    "province": "Jawa Barat",
    "gudep": "01.023",
    "joined": "12 Maret 2023",
    "image":
        "https://lh3.googleusercontent.com/aida-public/AB6AXuBhEh1v1fcpsCJDgbK6XEUEyMWC9-bIl35rhVFrHoXWNs4ciWW0ifwG2DkaPz481o2gd1Z-eqBmFGK4oK42O0I7gnndm9MOEkPj3j1uGy0bn4wUFlB_vvB8Y-4u5MOdn2rrOuoyjCsB4Wv-9YVuqSpxIWK8GXN5OpvtG6z_aqhKuiqvIxtNZgS0-6ZCFV9Fn6Ga-VIBwGf3ExgzrtrV7ukW0Jbz_-6YnoZjxwdubyap7nnvuNaiTZdZP8pjGoUGiT0vnJ4l4QlG0aI",
  }.obs;

  // --- FUNGSI LOGOUT INTEGRASI BACKEND + LOCAL STORAGE BRAY ---
  void logout() async {
    final box = GetStorage();
    String? token = box.read('token');

    try {
      isLoading.value = true;

      // 1. Kirim sinyal logout ke backend Flask bray
      if (token != null) {
        print("--- DEBUG: MENCOBA TEMBAK API LOGOUT FLASK ---");
        await http
            .post(
              Uri.parse("${ApiEndpoint.baseUrl}/logout"),
              headers: {
                "Content-Type": "application/json",
                "Authorization":
                    "Bearer $token", // Sesuai dengan request.headers.get di Flask bray
              },
            )
            .timeout(
              const Duration(seconds: 5),
            ); // Batasi waktu tunggu biar gak hang
      }

      // 2. BERSIHKAN LOCAL STORAGE HP SAMPAI AMNESIA BRAY
      await box.remove('token');
      await box.remove('is_logged_in');
      await box.save(); // Kunci pembersihan memori detik ini juga

      isLoading.value = false;

      Get.snackbar(
        "Logout Sukses",
        "Kamu telah keluar dari akun Scoutify.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.logout, color: Colors.white),
      );

      // 3. TENDANG USER BALIK KE GERBANG LOGIN & HANCURKAN STACK NAVIGASI
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      isLoading.value = false;
      print("🚨 Error Pas Proses Logout: $e");

      // JALUR AMAN CADANGAN: Kalau server Flask mati/koneksi putus, tetep paksa logout di HP
      // Biar user kamu gak terjebak/stuck di halaman profile bray!
      await box.remove('token');
      await box.remove('is_logged_in');
      await box.save();
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
