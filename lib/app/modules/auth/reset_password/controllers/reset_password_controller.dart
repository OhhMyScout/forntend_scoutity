import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isConfirmVisible = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmVisibility() => isConfirmVisible.toggle();

  void savePassword() {
    String pass = passwordController.text;
    String confirm = confirmPasswordController.text;

    if (pass.length < 8) {
      Get.snackbar("Lemah", "Kata sandi minimal 8 karakter");
      return;
    }

    if (pass != confirm) {
      Get.snackbar("Meleset", "Konfirmasi kata sandi tidak cocok");
      return;
    }

    // Simulasi Berhasil
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF7D562D),
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                "Berhasil Diperbarui",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF361F1A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Kata sandi Anda telah berhasil diperbarui. Silakan masuk kembali.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(Routes.LOGIN),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF361F1A),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Masuk Sekarang",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
