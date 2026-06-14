import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../routes/app_pages.dart';
import '../../../data/api_endpoint.dart';
// TODO: Pastikan path import OtpAction ini sesuai dengan lokasi aslinya
import '../../register/controllers/register_controller.dart'; 

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // ======================================================
  // NAVIGASI KEMBALI
  // ======================================================
  void backToLogin() {
    Get.back();
  }

  // ======================================================
  // KIRIM KODE RESET (API CALL)
  // ======================================================
  Future<void> sendResetCode() async {
    // Cegah double-click saat loading
    if (isLoading.value) return;

    final email = emailController.text.trim();

    // 1. Validasi Input
    if (email.isEmpty) {
      _showSnackbar("Perhatian", "Alamat email tidak boleh kosong", Colors.orange);
      return;
    }

    if (!GetUtils.isEmail(email)) {
      _showSnackbar("Perhatian", "Format email tidak valid", Colors.orange);
      return;
    }

    // 2. Eksekusi API
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiEndpoint.forgotPassword),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException("Koneksi internet lambat"),
      );

      debugPrint("FORGOT PASS STATUS : ${response.statusCode}");
      debugPrint("FORGOT PASS BODY   : ${response.body}");

      // Parsing JSON dengan aman (mencegah crash jika server mengembalikan HTML)
      Map<String, dynamic> result = {};
      try {
        result = jsonDecode(response.body);
      } catch (e) {
        debugPrint("Gagal decode JSON: $e");
      }

      // 3. Penanganan Response
      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSnackbar(
          "Berhasil", 
          result["message"] ?? "Kode verifikasi telah dikirim ke email Anda", 
          Colors.green,
        );

        // Arahkan ke halaman OTP dengan mode resetPassword
        Get.toNamed(
          Routes.OTP,
          arguments: {
            "email": email,
            "actionType": OtpAction.resetPassword,
          },
        );
      } else {
        _showSnackbar(
          "Gagal", 
          result["message"] ?? "Email tidak ditemukan atau terjadi kesalahan server", 
          Colors.red,
        );
      }
    } on TimeoutException catch (_) {
      _showSnackbar("Waktu Habis", "Koneksi internet tidak stabil, coba lagi nanti", Colors.red);
    } catch (e) {
      debugPrint("FORGOT PASSWORD ERROR : $e");
      _showSnackbar("Error", "Gagal terhubung ke jaringan", Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // HELPER METHOS UNTUK SNACKBAR
  // ======================================================
  void _showSnackbar(String title, String message, Color bgColor) {
    Get.snackbar(
      title,
      message,
      backgroundColor: bgColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }
}