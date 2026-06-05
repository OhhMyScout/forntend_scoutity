import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../routes/app_pages.dart';
import '../../../data/api_endpoint.dart';

enum OtpAction {
  register,
  resetPassword,
}

class RegisterController extends GetxController {
  final nicknameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var selectedProvince = RxnString();
  var isPrivacyAccepted = false.obs;
  var isLoading = false.obs;

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
    "Sulawesi Tengah",
    "Sulawesi Barat",
    "Sulawesi Selatan",
    "Sulawesi Tenggara",
    "Gorontalo",
    "Maluku",
    "Maluku Utara",
    "Papua",
    "Papua Barat",
    "Papua Selatan",
    "Papua Tengah",
    "Papua Pegunungan",
    "Papua Barat Daya",
  ];

  Future<void> register() async {
    try {
      final username = nicknameController.text.trim();
      final fullname = fullNameController.text.trim();
      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      if (username.isEmpty ||
          fullname.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        Get.snackbar(
          "Error",
          "Semua kolom wajib diisi",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (selectedProvince.value == null ||
          selectedProvince.value!.isEmpty) {
        Get.snackbar(
          "Error",
          "Pilih provinsi terlebih dahulu",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (password != confirmPassword) {
        Get.snackbar(
          "Error",
          "Password tidak cocok",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (!isPrivacyAccepted.value) {
        Get.snackbar(
          "Perhatian",
          "Harap setujui kebijakan privasi !",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;

      final body = {
        "username": username,
        "fullname": fullname,
        "email": email,
        "password": password,
        "provinsi": selectedProvince.value,
        "role": "user",
        "image": "default_profile.png",
      };

      final response = await http.post(
        Uri.parse(ApiEndpoint.register),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint("REGISTER STATUS : ${response.statusCode}");
      debugPrint("REGISTER BODY   : ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 201 &&
          result["status"] == "success") {
        Get.snackbar(
          "Sukses",
          result["message"] ?? "Registrasi berhasil",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.toNamed(
          Routes.OTP,
          arguments: {
            "email": email,
            "actionType": OtpAction.register,
            "token": result["token"],
          },
        );

        return;
      }

      Get.snackbar(
        "Gagal",
        result["message"] ?? "Registrasi gagal",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint("REGISTER ERROR: $e");

      Get.snackbar(
        "Error",
        "Server tidak merespon",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void togglePrivacy(bool? value) {
    isPrivacyAccepted.value = value ?? false;
  }

  void changeProvince(String? value) {
    if (value != null) {
      selectedProvince.value = value;
    }
  }

  void goToLogin() {
    Get.back();
  }

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