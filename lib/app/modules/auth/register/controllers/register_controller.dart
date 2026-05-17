// lib/app/modules/auth/register/controllers/register_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final nicknameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var selectedProvince = "".obs;
  var isPrivacyAccepted = false.obs;
  var isLoading = false.obs; // Observable untuk loading state

  // Ganti IP ini dengan IP Laptop kamu (contoh: 192.168.1.5)
  // Jika pakai emulator Android standar, gunakan 10.0.2.2
  final String baseUrl = "http://127.0.0.1:5000/api/register";

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
        "email": emailController.text,
        "password": passwordController.text,
        "provinsi": selectedProvince.value,
        "role": "user",
        "images": "default_profile.png" // Sesuai default di backend
      };

      // 3. Eksekusi API Call
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(registerData),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Berhasil! 
        Get.snackbar("Sukses", "Akun berhasil didaftarkan!", 
            backgroundColor: Colors.green, colorText: Colors.white);
        
        // Simpan token ke local storage jika perlu sebelum pindah
        // Contoh: GetStorage().write('token', result['token']);
        
        Get.offAllNamed(Routes.HOME);
      } else {
        // Gagal dari sisi server (email sudah ada, dsb)
        Get.snackbar("Gagal", result['message'] ?? "Terjadi kesalahan", 
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat terhubung ke server. Cek koneksi & IP API.", 
          backgroundColor: Colors.red, colorText: Colors.white);
      print("Error API: $e");
    } finally {
      isLoading.value = false;
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

  final List<String> provinces = ["Jawa Tengah", "Jawa Barat", "Jawa Timur", "DKI Jakarta", "Bali", "Sumatera Utara"]; 
}