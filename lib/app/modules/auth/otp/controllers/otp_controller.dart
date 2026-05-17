import 'dart:async'; // Wajib untuk mengelola Timer hitung mundur bray
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:scoutify/app/routes/app_pages.dart';
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
  void verify() async {
    String otp = otpControllers.map((e) => e.text.trim()).join();
    
    if (otp.length < 4) {
      Get.snackbar(
        "Perhatian", 
        "Masukkan 4 digit kode verifikasi dengan lengkap bray!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      const String apiUrl = "http://127.0.0.1:5000/api/verify-otp";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp.trim(),
        }),
      );

      final result = jsonDecode(response.body);
      isLoading.value = false;

      if (response.statusCode == 200) {
        Get.snackbar(
          "Verifikasi Sukses", 
          "Akun Scoutify kamu telah aktif. Selamat berpetualang!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );

        if (actionType == OtpAction.register) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.offAllNamed(Routes.HOME); // Langsung jebol ke Home utama bray
          });
        } else {
          // Skenario reset password di masa depan
          Get.offNamed(Routes.RESET_PASSWORD, arguments: {"email": email});
        }
      } else {
        Get.snackbar(
          "Verifikasi Gagal", 
          result['message'] ?? "Kode OTP salah atau sudah hangus!",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error", 
        "Tidak dapat terhubung ke server. Pastikan adb reverse aktif bray!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
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

      // JALUR SAKLAR DINAMIS BERDASARKAN EMIT/ASAL HALAMAN:
      String apiUrl = "http://127.0.0.1:5000/api/resend-otp"; // Jalur default Registrasi
      
      if (actionType != OtpAction.register) {
        // Kalau tipenya BUKAN register (alias reset password), belokin ke endpoint reset bray!
        apiUrl = "http://127.0.0.1:5000/api/resend-otp-reset";
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