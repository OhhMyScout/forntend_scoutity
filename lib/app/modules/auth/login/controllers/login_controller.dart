import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() {
    // Logic login di sini
    print("Login dengan: ${emailController.text}");
    Get.offAllNamed(Routes.HOME);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
