// lib/modules/forgot_password/forgot_password_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoutify/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

void sendResetCode() {
  if (emailController.text.isEmpty) {
    Get.snackbar("Error", "Silakan masukkan alamat email Anda");
    return;
  }
  
  // Simulasi sukses kirim email
  print("Mengirim kode ke: ${emailController.text}");
  
  // PINDAH KE HALAMAN VERIFIKASI
  Get.toNamed(Routes.OTP); 
}

  void backToLogin() => Get.back();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}