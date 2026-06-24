import 'dart:convert';
//DART: lib/app/modules/auth/login/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

    // Catatan: Listener onAuthStateChange dari Supabase DIBUANG/DIHAPUS dari sini
    // Karena kita tidak ingin aplikasi langsung pindah ke HOME sebelum
    // Flutter berhasil mendapatkan Token JWT dari backend FastAPI kita.
    // Logika navigasi dipindah ke dalam fungsi loginWithGoogle() di bawah.
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
  // 1. LOGIN MANUAL (API)
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
          result["detail"]?["message"] ?? result["message"] ?? "Kredensial tidak valid",
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
  // 2. LOGIN GOOGLE (OAUTH SUPABASE + FASTAPI SYNC)
  // ======================================================
  Future<void> loginWithGoogle() async {
    try {
      if (isGoogleLoading.value) return;

      isGoogleLoading.value = true;

      // Web Client ID kamu
      const webClientId = '266565744405-sneglrbbh9aml1hin3qha2tq0nfnrvaf.apps.googleusercontent.com';

      // 1. Munculkan Pop-up Akun Google
      final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);
      final googleUser = await googleSignIn.signIn();
      
      // Jika user batal memilih akun
      if (googleUser == null) {
        return; 
      }

      // Ambil token dari Google
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'Token Google tidak ditemukan. Silakan coba lagi.';
      }

      // 2. Kirim kredensial ke Supabase untuk divalidasi
      final AuthResponse response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;
      if (user == null) throw 'Gagal mendapatkan data user dari Supabase.';

      // Ekstrak data dari profil Google user
      final metadata = user.userMetadata ?? {};
      final fullname = metadata["full_name"] ?? metadata["name"] ?? "Scout";
      final image = metadata["avatar_url"] ?? metadata["picture"] ?? "";
      final email = user.email ?? "";

      // 3. LAPOR KE BACKEND FASTAPI (Untuk dapat JWT Token Custom)
      // Pastikan kamu menambahkan `static const String googleLogin = "$baseUrl/api/google-login";`
      // di file `ApiEndpoint.dart` kamu.
      final backendResponse = await http.post(
        Uri.parse(ApiEndpoint.googleLogin), // <-- Pastikan endpoint ini sudah diset
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "fullname": fullname,
          "supabase_uid": user.id,
          "image": image,
        }),
      );

      final result = jsonDecode(backendResponse.body);

      // Jika Backend berhasil merespons dan memberikan Token
      if (backendResponse.statusCode == 200) {
        final backendToken = result["token"] ?? "";
        final backendUser = result["user"] ?? {};

        // 4. SIMPAN SESI BERDASARKAN DATA DARI BACKEND
        await SessionManager.saveSession(
          token: backendToken, // Ini adalah token dari FastAPI!
          userId: backendUser["id"]?.toString() ?? user.id,
          username: backendUser["username"] ?? email.split("@")[0],
          fullname: backendUser["fullname"] ?? fullname,
          email: backendUser["email"] ?? email,
          role: backendUser["role"] ?? "user",
          province: backendUser["province"] ?? "",
          image: backendUser["image"] ?? image,
          points: backendUser["points"] ?? 0,
        );

        Get.snackbar(
          "Berhasil", 
          "Login Google berhasil", 
          backgroundColor: Colors.green, 
          colorText: Colors.white,
        );
        
        // 5. PINDAH KE HOME SETELAH SEMUANYA SELESAI
        Get.offAllNamed(Routes.HOME);

      } else {
        // Jika Backend FastAPI menolak
        await supabase.auth.signOut();
        await googleSignIn.signOut();
        throw result["detail"]?["message"] ?? result["message"] ?? "Gagal sinkronisasi dengan server.";
      }

    } catch (e) {
      debugPrint("GOOGLE LOGIN ERROR: $e");

      Get.snackbar(
        "Error",
        "Login Google gagal: ${e.toString()}",
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
      // Logout dari Supabase
      await supabase.auth.signOut();
      
      // Logout dari GoogleSignIn agar saat login lagi muncul pilihan akun
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
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
