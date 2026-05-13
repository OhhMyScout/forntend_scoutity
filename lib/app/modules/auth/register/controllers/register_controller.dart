// lib/modules/register/register_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  // TextEditingControllers
  final nicknameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  var selectedProvince = "".obs;
  var isPrivacyAccepted = false.obs;
  var isPasswordVisible = false.obs;

  final List<String> provinces = [
    "Aceh",
    "Sumatera Utara",
    "Sumatera Barat",
    "Riau",
    "Kepulauan Riau",
    "Jambi",
    "Sumatera Selatan",
    "Kepulauan Bangka Belitung",
    "Bengkulu",
    "Lampung",
    "DKI Jakarta",
    "Jawa Barat",
    "Banten",
    "Jawa Tengah",
    "DI Yogyakarta",
    "Jawa Timur",
    "Bali",
    "Nusa Tenggara Barat",
    "Nusa Tenggara Timur",
    "Kalimantan Barat",
    "Kalimantan Tengah",
    "Kalimantan Selatan",
    "Kalimantan Timur",
    "Kalimantan Utara",
    "Sulawesi Utara",
    "Gorontalo",
    "Sulawesi Tengah",
    "Sulawesi Barat",
    "Sulawesi Selatan",
    "Sulawesi Tenggara",
    "Maluku",
    "Maluku Utara",
    "Papua",
    "Papua Barat",
    "Papua Selatan",
    "Papua Tengah",
    "Papua Pegunungan",
    "Papua Barat Daya"
  ];

  void togglePrivacy(bool? value) {
    isPrivacyAccepted.value = value ?? false;
  }

  void register() {
    if (!isPrivacyAccepted.value) {
      Get.snackbar("Perhatian", "Anda harus menyetujui Kebijakan Privasi");
      return;
    }
    // Implementasi logika pendaftaran (API Call)
    print("Daftar: ${nicknameController.text}");
    Get.offAllNamed(Routes.HOME);
  }

  void goToLogin() => Get.back(); // Kembali ke halaman sebelumnya (Login)

  @override
  void onClose() {
    nicknameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}