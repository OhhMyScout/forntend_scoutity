import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF361F1A);
    const Color secondaryColor = Color(0xFF7D562D);
    const Color surfaceLow = Color(0xFFF6F3EE);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Scoutify",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Illustration Section
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuDdIoWvNDK9W70Yg7pqurnD0MYHcyePgYf0gz01MVvBVGymK98T-EgR90j4pp075GTw2oJbLcxYyr_gkI9n_BXa7V4e4s4-vYDE4WFjmQYAgqmpOq6VFdlQVFqpR0V7ldVlQixsC44O1m8u77GE9I5sJe1DD5T6LnC1z-ihG1z-EprrgEDVfrD4pcJ0Oe_Re0unEerNNdUITTW1iq5q1HvjI6O7XsDZADqEvW-msjyb8X3SiYSMxGkHlVH_ZqhUiAs828VPuspVyRs",
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Verifikasi Kode",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Masukkan 4 digit kode yang telah dikirim ke email Anda.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF504442)),
              ),
              const SizedBox(height: 40),

              // OTP Input Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => _buildOtpBox(index, surfaceLow, secondaryColor),
                ),
              ),

              const SizedBox(height: 40),

              // Button
              SizedBox(
                width: double.infinity,
                height: 52,
                // Kita bungkus pakai Obx agar tombolnya mendeteksi perubahan status isLoading secara real-time bray
                child: Obx(() => ElevatedButton(
                  // Kunci tombol: kalau lagi loading, set jadi null (tombol otomatis mati/disabled)
                  onPressed: controller.isLoading.value ? null : controller.verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: const StadiumBorder(),
                    elevation: 6,
                    shadowColor: primaryColor.withOpacity(0.3),
                    // Tambahkan warna ini agar saat loading/disabled, tombolnya agak redup estetik bray
                    disabledBackgroundColor: primaryColor.withOpacity(0.6), 
                  ),
                  // Logika pergantian widget di dalam tombol
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text(
                          "Verifikasi",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                )),
              ),

              const SizedBox(height: 24),

              // Resend Link
              // Resend Link dengan Proteksi Anti-Spam 60 Detik
              Obx(() {
                // Cek apakah statusnya sedang dikunci (cooldown masih di atas 0)
                final bool isCooldown = controller.cooldownSeconds.value > 0;

                return TextButton(
                  // Jika masih cooldown, set onPressed ke null biar tombol otomatis kekunci (disabled) bray
                  onPressed: isCooldown ? null : controller.resendCode,
                  child: Text.rich(
                    TextSpan(
                      text: "Tidak menerima kode? ",
                      style: const TextStyle(color: Color(0xFF504442)),
                      children: [
                        TextSpan(
                          // Teks otomatis berubah memunculkan sisa detik kalau lagi cooldown bray
                          text: isCooldown 
                              ? "Kirim Ulang Kode (${controller.cooldownSeconds.value}s)" 
                              : "Kirim Ulang Kode",
                          style: TextStyle(
                            // Warnanya otomatis abu-abu redup kalau kekunci, dan cokelat kalau aktif kembali
                            color: isCooldown ? Colors.grey : secondaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: isCooldown ? TextDecoration.none : TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 40),
              const Text(
                "Pastikan Anda memeriksa folder spam jika kode tidak segera muncul.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index, Color bg, Color active) {
    return SizedBox(
      width: 64,
      height: 64,
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        onChanged: (v) => controller.onOtpChanged(v, index),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: bg,
          hintText: "•",
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: active, width: 2),
          ),
        ),
      ),
    );
  }
}
