import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../routes/app_pages.dart';
import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    autoLoginCheck();
  }

  // =========================
  // AUTO LOGIN CHECK
  // =========================
  void autoLoginCheck() {
    if (SessionManager.hasToken() && SessionManager.isLoggedIn) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.offAllNamed(Routes.HOME);
      });
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // =========================
  // LOGIN
  // =========================
  Future<void> login() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          "Error",
          "Email & password wajib diisi",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiEndpoint.login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = result["token"] ?? "";
        final user = result["user"] ?? {};

        await SessionManager.saveSession(
          token: token,
          userId: user["id"],
          username: user["username"] ?? "",
          fullname: user["fullname"] ?? "",
          email: user["email"] ?? email,
          role: user["role"] ?? "user",
          province: user["province"] ?? "",
          image: user["image"] ?? "",
          points: user["points"] ?? 0,
        );

        Get.snackbar(
          "Success",
          "Login berhasil",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          "Login Gagal",
          result["message"] ?? "Invalid credentials",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");

      Get.snackbar(
        "Error",
        "Server tidak dapat dijangkau",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await SessionManager.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}