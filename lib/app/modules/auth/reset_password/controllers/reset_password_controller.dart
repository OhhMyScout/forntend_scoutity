import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../routes/app_pages.dart';
import '../../../data/api_endpoint.dart';

class ResetPasswordController extends GetxController {
  // Input Controllers
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // State
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmVisible = false.obs;
  final RxBool isLoading = false.obs;

  // Data dari halaman OTP
  late String email;
  late String otp;

  @override
  void onInit() {
    super.onInit();
    // Mengambil argumen yang dikirim dari OtpController
    email = Get.arguments?['email'] ?? '';
    otp = Get.arguments?['otp'] ?? '';
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ======================================================
  // TOGGLE VISIBILITY
  // ======================================================
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmVisibility() {
    isConfirmVisible.value = !isConfirmVisible.value;
  }

  // ======================================================
  // SAVE PASSWORD (API CALL)
  // ======================================================
  Future<void> savePassword() async {
    if (isLoading.value) return;

    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // 1. Validasi Input
    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        "Perhatian",
        "Kata sandi tidak boleh kosong",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        "Perhatian",
        "Kata sandi harus minimal 8 karakter",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Perhatian",
        "Konfirmasi kata sandi tidak cocok",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // 2. Eksekusi API
    try {
      isLoading.value = true;

      // Sesuai dengan ResetPasswordRequest Schema di FastAPI
      final response = await http.post(
        Uri.parse(ApiEndpoint.resetPassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "new_password": password, 
        }),
      );

      final result = jsonDecode(response.body);

      debugPrint("RESET PASS STATUS : ${response.statusCode}");
      debugPrint("RESET PASS BODY   : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Tutup snackbar yang mungkin masih terbuka
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }

        Get.snackbar(
          "Berhasil",
          result["message"] ?? "Kata sandi berhasil diubah! Silakan login.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // 3. Kembali ke Halaman Login dengan aman
        // Menggunakan Get.until agar tidak terjadi error dispose pada TextField Login
        Get.until((route) => route.settings.name == Routes.LOGIN);
        
      } else {
        Get.snackbar(
          "Gagal",
          result["message"] ?? "Gagal mereset kata sandi",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("RESET PASSWORD ERROR : $e");
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