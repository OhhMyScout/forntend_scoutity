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
      Get.snackbar(
        "Perhatian",
        "Alamat email tidak boleh kosong",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Perhatian",
        "Format email tidak valid",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // 2. Eksekusi API
    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiEndpoint.forgotPassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }),
      );

      final result = jsonDecode(response.body);

      debugPrint("FORGOT PASS STATUS : ${response.statusCode}");
      debugPrint("FORGOT PASS BODY   : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Berhasil",
          result["message"] ?? "Kode OTP telah dikirim ke email Anda",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // 3. Arahkan ke halaman OTP dengan mode resetPassword
        Get.toNamed(
          Routes.OTP,
          arguments: {
            "email": email,
            "actionType": OtpAction.resetPassword,
          },
        );
      } else {
        Get.snackbar(
          "Gagal",
          result["message"] ?? "Email tidak ditemukan atau terjadi kesalahan",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("FORGOT PASSWORD ERROR : $e");
      Get.snackbar(
        "Error",
        "Gagal terhubung ke server",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}