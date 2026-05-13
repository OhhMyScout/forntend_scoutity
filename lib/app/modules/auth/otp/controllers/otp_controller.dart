import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoutify/app/routes/app_pages.dart';

class OtpController extends GetxController {
  // List controller untuk 4 digit OTP
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  // List focus nodes untuk otomatis pindah field
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  void onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void verify() {
    String otp = otpControllers.map((e) => e.text).join();
    if (otp.length < 4) {
      Get.snackbar("Error", "Masukkan 4 digit kode verifikasi");
      return;
    }

    // Jika kode benar (simulasi)
    print("Kode diverifikasi: $otp");

    // PINDAH KE HALAMAN ATUR ULANG KATA SANDI
    Get.toNamed(Routes.RESET_PASSWORD);
  }

  void resendCode() {
    print("Mengirim ulang kode...");
    Get.snackbar("Sukses", "Kode baru telah dikirim ke email Anda");
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
