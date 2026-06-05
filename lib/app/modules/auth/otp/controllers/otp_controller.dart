import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../routes/app_pages.dart';
import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart';
import '../../register/controllers/register_controller.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  final List<FocusNode> focusNodes =
      List.generate(4, (_) => FocusNode());

  final RxBool isLoading = false.obs;
  final RxInt cooldownSeconds = 0.obs;

  Timer? _timer;

  late String email;
  late OtpAction actionType;

  @override
  void onInit() {
    super.onInit();

    email = Get.arguments?['email'] ?? '';
    actionType = Get.arguments?['actionType'] ?? OtpAction.register;

    startCooldown();
  }

  // ======================================================
  // COOLDOWN
  // ======================================================
  void startCooldown() {
    _timer?.cancel();
    cooldownSeconds.value = 60;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (cooldownSeconds.value > 0) {
          cooldownSeconds.value--;
        } else {
          timer.cancel();
        }
      },
    );
  }

  // ======================================================
  // OTP INPUT (AUTO VERIFY)
  // ======================================================
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < focusNodes.length - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        focusNodes[index].unfocus();
      }
    }

    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }

    final allFilled = otpControllers.every(
      (e) => e.text.trim().isNotEmpty,
    );

    if (allFilled && !isLoading.value) {
      Future.delayed(
        const Duration(milliseconds: 200),
        () {
          if (!isLoading.value) {
            verify();
          }
        },
      );
    }
  }

  // ======================================================
  // VERIFY OTP API CALL
  // ======================================================
  Future<void> verify() async {
    if (isLoading.value) return;

    final otp = otpControllers.map((e) => e.text.trim()).join();

    if (otp.length != 4) {
      Get.snackbar("Perhatian", "Masukkan 4 digit kode OTP");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiEndpoint.verifyOtp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );

      final result = jsonDecode(response.body);

      debugPrint("VERIFY STATUS : ${response.statusCode}");
      debugPrint("VERIFY BODY   : ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = result["token"];

        if (token == null || token.toString().isEmpty) {
          Get.snackbar("Error", "Token tidak ditemukan dari server");
          return;
        }

        // Fallback objek user jika dari backend kosong
        final user = result["user"] ?? {};

        // Simpan sesi ke HP menggunakan SessionManager yang sudah diupdate (String UUID)
        await SessionManager.saveSession(
          token: token,
          userId: user["id"]?.toString() ?? "", 
          username: user["username"]?.toString() ?? "Scout",
          fullname: user["fullname"]?.toString() ?? "Scout",
          email: email, 
          role: user["role"]?.toString() ?? "user",
          province: user["province"]?.toString() ?? "-",
          points: int.tryParse(user["points"]?.toString() ?? "0") ?? 0,
          image: user["image"]?.toString() ?? "default_profile.png",
        );

        debugPrint("TOKEN STORED : ${SessionManager.token}");
        debugPrint("LOGIN STATUS : ${SessionManager.isLoggedIn}");

        Get.snackbar(
          "Berhasil",
          result["message"] ?? "Verifikasi OTP berhasil",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (actionType == OtpAction.register) {
          // OffAllNamed mematikan rute balik agar aman
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offNamed(
            Routes.RESET_PASSWORD,
            arguments: {"email": email},
          );
        }
      } else {
        Get.snackbar(
          "Gagal",
          result["message"] ?? "OTP tidak valid",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        
        // Bersihkan kotak agar user bisa input ulang
        for (var controller in otpControllers) {
          controller.clear();
        }
        focusNodes[0].requestFocus();
      }
    } catch (e) {
      debugPrint("VERIFY OTP ERROR : $e");
      Get.snackbar("Error", "Gagal terhubung ke server");
    } finally {
      isLoading.value = false;
    }
  }

  // ======================================================
  // RESEND OTP
  // ======================================================
  Future<void> resendCode() async {
    if (cooldownSeconds.value > 0) return;

    try {
      final apiUrl = actionType == OtpAction.register
          ? ApiEndpoint.resendOtpRegister
          : ApiEndpoint.resendOtpReset;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Berhasil",
          result["message"] ?? "OTP berhasil dikirim ulang",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        for (var controller in otpControllers) {
          controller.clear();
        }
        focusNodes[0].requestFocus();
        startCooldown();
      } else {
        Get.snackbar("Gagal", result["message"] ?? "Gagal mengirim OTP");
      }
    } catch (e) {
      debugPrint("RESEND OTP ERROR : $e");
      Get.snackbar("Error", "Gagal terhubung ke server");
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (final controller in otpControllers) controller.dispose();
    for (final node in focusNodes) node.dispose();
    super.onClose();
  }
}