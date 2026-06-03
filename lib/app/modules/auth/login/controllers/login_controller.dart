import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import 'package:http/http.dart' as http;
import '../../../data/api_endpoint.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // lib/app/modules/auth/login/controllers/login_controller.dart

  // Di dalam LoginController kamu bray
  void login() async {
    try {
      isLoading.value = true;
      
      // Anggaplah ini proses nembak API Login kamu ke Flask
      final response = await http.post(
        Uri.parse(ApiEndpoint.login), // Sesuai file pusat API kita kemarin bray
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final result = jsonDecode(response.body);
      isLoading.value = false;

      if (response.statusCode == 200) {
        // --- KUNCI PENYELAMATNYA DI SINI BRAY! ---
        final box = GetStorage();
        
        // Wajib pakai await dan ambil token hasil generate login dari Flask bray
        await box.write('token', result['token']); 
        await box.write('is_logged_in', true);
        
        // Ambil data email buat cadangan jika ada bray
        if (result['data'] != null) {
          await box.write('email', result['data']['email']);
        }
        
        // Paksa simpan detik ini juga ke memori HP bray
        await box.save();

        Get.snackbar(
          "Login Sukses",
          "Selamat datang kembali di Scoutify!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Pindahkan langsung ke HOME tanpa sisa stack halaman lama bray
        Get.offAllNamed(Routes.HOME);

      } else {
        Get.snackbar(
          "Login Gagal",
          result['message'] ?? "Email atau password salah bray!",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      print("Error Login: $e");
    }
  }
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
