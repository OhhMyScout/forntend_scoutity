import 'dart:async'; // Wajib untuk mengelola Timer hitung mundur bray
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scoutify/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/api_endpoint.dart';
import '../../register/controllers/register_controller.dart'; // Import enum OtpAction dari register

class OtpController extends GetxController {
  // List controller untuk 4 kotak input OTP terpisah di View kamu bray
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  // List focus nodes untuk otomatis pindah kursor/kotak secara interaktif
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  // State management reaktif GetX
  var isLoading = false.obs;
  var cooldownSeconds = 0.obs; // Menyimpan sisa waktu pembatasan kirim ulang
  Timer? _timer;
  String apiUrl = ApiEndpoint.resendOtpRegister;

  late String email;
  late OtpAction actionType;

  @override
  void onInit() {
    super.onInit();
    // Tangkap data email dan tipe aksi yang dilempar dari halaman sebelumnya bray
    email = Get.arguments['email'] ?? '';
    actionType = Get.arguments['actionType'] ?? OtpAction.register;

    // Otomatis jalankan hitung mundur 60 detik begitu user mendarat di halaman OTP
    startCooldown();
  }

  // Fungsi pengelola hitung mundur 60 detik
  void startCooldown() {
    cooldownSeconds.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (cooldownSeconds.value > 0) {
        cooldownSeconds.value--;
      } else {
        _timer?.cancel(); // Stop timer kalau sudah menyentuh angka 0
      }
    });
  }

  // Mengatur perpindahan fokus otomatis antar-kotak input OTP
  void onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  // Fungsi utama untuk verifikasi kode ke Flask
  // Fungsi utama untuk verifikasi kode ke Flask (VERSI UPDATE ANTI-MENTAL BRAY)
  void verify() async {
    String otp = otpControllers.map((e) => e.text.trim()).join();

    if (otp.length < 4) {
      Get.snackbar("Perhatian", "Masukkan 4 digit kode verifikasi bray!", 
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiEndpoint.verifyOtp),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp.trim()}),
      );

      final result = jsonDecode(response.body);
      isLoading.value = false;

      if (response.statusCode == 200) {
        // 1. Ambil instansiasi preferensi lokal HP bray
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        
        String? tokenDariServer = result['token'];

        if (tokenDariServer != null && tokenDariServer.isNotEmpty) {
          // 2. Kunci data secara asinkron ke dalam hardisk HP fisik bray
          await prefs.setString('token', tokenDariServer);
          await prefs.setBool('is_logged_in', true);
          await prefs.setBool('is_intro_seen', true); // Jaring pengaman mutlak
          await prefs.setString('email', email);

          Get.snackbar(
            "Verifikasi Sukses",
            "Akun Scoutify kamu telah aktif bray!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          if (actionType == OtpAction.register) {
            // Kasih jeda 1.2 detik biar user sempet baca snackbar dan data kelar ditulis ke disk HP
            Future.delayed(const Duration(milliseconds: 1200), () {
              Get.offAllNamed(Routes.HOME); 
            });
          } else {
            Get.offNamed(Routes.RESET_PASSWORD, arguments: {"email": email});
          }
        } else {
          Get.snackbar("Error", "Token dari server kosong bray!", backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar("Verifikasi Gagal", result['message'] ?? "OTP salah!", backgroundColor: Colors.redAccent);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Gagal terhubung ke server bray!", backgroundColor: Colors.red);
    }
  }

  // --- DI SINI LOGIKA UTAMA RESEND OTP YANG FLEKSIBEL BRAY ---
  void resendCode() async {
    // Proteksi di level fungsi: Cegah klik jika waktu cooldown masih berjalan
    if (cooldownSeconds.value > 0) return;

    try {
      Get.rawSnackbar(
        message: "Sedang mengirim ulang kode OTP...",
        backgroundColor: Colors.blueGrey,
        duration: const Duration(seconds: 2),
      );

      if (actionType != OtpAction.register) {
        apiUrl = ApiEndpoint.resendOtpReset; // Jalur reset dari pusat bray
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Get.snackbar(
          "Sukses",
          result['message'] ?? "Kode baru telah dikirim ke email Anda!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Picu kembali hitung mundur 60 detik dari nol biar aman dari spam klik bray
        startCooldown();
      } else {
        Get.snackbar(
          "Gagal",
          result['message'] ?? "Gagal mengirim ulang kode.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal terhubung ke server. Periksa kembali status adb reverse bray!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Error Resend API: $e");
    }
  }

  @override
  void onClose() {
    _timer?.cancel(); // Bersihkan timer biar ram laptop gak jebol (leak memory)
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
