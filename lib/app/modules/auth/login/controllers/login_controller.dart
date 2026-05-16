import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  // Gunakan 127.0.0.1 jika sudah jalankan 'adb reverse tcp:5000 tcp:5000'
  final String apiUrl = "http://127.0.0.1:5000/api/login";

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // lib/app/modules/auth/login/controllers/login_controller.dart

void login() async {
  try {
    isLoading.value = true;

    // Kirim password asli, biarkan Backend yang memverifikasi
    Map<String, String> body = {
      "email": emailController.text.trim(),
      "password": passwordController.text, // Teks asli
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Di sini kita terima TOKEN hasil generate backend
      // Simpan token ini untuk akses fitur-fitur Scoutify lainnya
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar("Gagal", "Email atau Password salah");
    }
  } catch (e) {
    Get.snackbar("Error", "Koneksi ke server terputus");
  } finally {
    isLoading.value = false;
  }
}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}