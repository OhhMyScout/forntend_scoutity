import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../routes/app_pages.dart';
import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final isGoogleLoading = false.obs;

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();

    autoLoginCheck();

    // Listener otomatis untuk menangkap callback redirect dari Google OAuth
    supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      final user = session?.user;

      if (session == null || user == null) {
        return;
      }

      final metadata = user.userMetadata ?? {};

      final fullname =
          metadata["full_name"] ??
          metadata["name"] ??
          "Scout";

      final image =
          metadata["avatar_url"] ??
          metadata["picture"] ??
          "";

      final email = user.email ?? "";

      final username = email.isNotEmpty
          ? email.split("@")[0]
          : "scout";

      // Simpan data otomatis ke SessionManager
      await SessionManager.saveSession(
        token: session.accessToken,
        userId: user.id,
        username: username,
        fullname: fullname,
        email: email,
        role: "user",
        province: "",
        image: image,
        points: 0,
      );

      Get.offAllNamed(Routes.HOME);
    });
  }

  // =========================
  // AUTO LOGIN CHECK
  // =========================
  void autoLoginCheck() {
    if (SessionManager.hasToken() && SessionManager.isLoggedIn) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () => Get.offAllNamed(Routes.HOME),
      );
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // =========================
  // LOGIN MANUAL
  // =========================
  Future<void> login() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          "Perhatian",
          "Email & password wajib diisi",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiEndpoint.login),
        headers: {
          "Content-Type": "application/json",
        },
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
          userId: user["id"]?.toString() ?? "",
          username: user["username"] ?? "",
          fullname: user["fullname"] ?? "",
          email: user["email"] ?? email,
          role: user["role"] ?? "user",
          province: user["province"] ?? "",
          image: user["image"] ?? "",
          points: user["points"] ?? 0,
        );

        Get.snackbar(
          "Berhasil",
          "Login berhasil",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          "Login Gagal",
          result["message"] ?? "Kredensial tidak valid",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("LOGIN ERROR : $e");

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

  // ======================================================
  // LOGIN GOOGLE VIA OAUTH SUPABASE
  // ======================================================
  Future<void> loginWithGoogle() async {
    try {
      if (isGoogleLoading.value) return;

      isGoogleLoading.value = true;

      // Supabase akan membuka browser/webview untuk login Google
      // dan mengembalikan token ke deep link 'io.supabase.flutter://login-callback'
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      debugPrint("GOOGLE LOGIN ERROR: $e");

      Get.snackbar(
        "Error",
        "Login Google gagal",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    await SessionManager.clear();

    try {
      await supabase.auth.signOut();
    } catch (_) {}

    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}