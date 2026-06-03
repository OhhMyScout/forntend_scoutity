// lib/app/modules/auth/register/controllers/register_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../routes/app_pages.dart';
import '../../../data/api_endpoint.dart';

// Definisikan enum action
enum OtpAction { register, resetPassword }

class RegisterController extends GetxController {
  final nicknameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var selectedProvince = "".obs;
  var isPrivacyAccepted = false.obs;
  var isLoading = false.obs; 



  void register() async {
    // 1. Validasi Sederhana
    if (emailController.text.isEmpty || passwordController.text.isEmpty || nicknameController.text.isEmpty) {
      Get.snackbar("Error", "Semua kolom wajib diisi", 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Konfirmasi password tidak cocok", 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (!isPrivacyAccepted.value) {
      Get.snackbar("Perhatian", "Anda harus menyetujui Kebijakan Privasi", 
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      // 2. Siapkan Request Body sesuai API Flask
      final Map<String, dynamic> registerData = {
        "username": nicknameController.text,
        "fullname": fullNameController.text,
        "email": emailController.text.trim(), // Tambahkan .trim() biar spasi gak sengaja keikut bray
        "password": passwordController.text,
        "provinsi": selectedProvince.value,
        "role": "user",
        "images": "default_profile.png" 
      };

      // 3. Eksekusi API Call
      final response = await http.post(
        Uri.parse(ApiEndpoint.register),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(registerData),
      );

      final result = jsonDecode(response.body);

      // Matikan loading spinner sebelum melakukan perpindahan halaman
      isLoading.value = false;

      if (response.statusCode == 201) {
        // Berhasil! Munculkan info untuk cek email
        Get.snackbar("Sukses", "Registrasi berhasil! Silakan cek email kamu untuk kode OTP.", 
            backgroundColor: Colors.green, colorText: Colors.white, duration: const Duration(seconds: 3));
        
        // 4. ALIKHAN KE LAYAR OTP REUSABLE
        // Bawa data email dan actionType agar OtpController tahu harus nembak endpoint verifikasi yang mana
        Get.toNamed(
          Routes.OTP, 
          arguments: {
            "email": emailController.text.trim(),
            "actionType": OtpAction.register
          }
        );
      } else {
        // Gagal dari sisi server (email sudah ada, dsb)
        Get.snackbar("Gagal", result['message'] ?? "Terjadi kesalahan", 
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Tidak dapat terhubung ke server. Cek koneksi & IP API.", 
          backgroundColor: Colors.red, colorText: Colors.white);
      print("Error API: $e");
    }
  }

  void togglePrivacy(bool? value) => isPrivacyAccepted.value = value ?? false;
  void goToLogin() => Get.back();

  @override
  void onClose() {
    nicknameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

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
    "Jawa Tengah",
    "DI Yogyakarta",
    "Jawa Timur",
    "Banten",
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
}