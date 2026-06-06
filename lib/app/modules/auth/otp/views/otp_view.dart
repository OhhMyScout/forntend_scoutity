import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/otp_controller.dart';
// TODO: Jangan lupa aktifkan/sesuaikan import enum OtpAction di bawah ini
import '../../register/controllers/register_controller.dart'; 

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF361F1A);
    const Color secondaryColor = Color(0xFF7D562D);
    const Color surfaceLow = Color(0xFFF6F3EE);

    // Menangkap argumen actionType dari controller/routes
    final actionType = Get.arguments?['actionType'] ?? OtpAction.register;
    final bool isForgotPassword = actionType == OtpAction.resetPassword;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
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

              // Dynamic Title
              Text(
                isForgotPassword
                    ? "Verifikasi Reset Password"
                    : "Verifikasi Akun",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),

              const SizedBox(height: 8),

              // Dynamic Subtitle
              Text(
                isForgotPassword
                    ? "Masukkan kode OTP yang dikirim ke email Anda untuk reset password."
                    : "Masukkan 4 digit kode yang telah dikirim ke email Anda.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF504442),
                ),
              ),

              const SizedBox(height: 12),

              // Display User Email
              Text(
                controller.email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
              ),

              const SizedBox(height: 40),

              // OTP Input Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  4,
                  (index) => _buildOtpBox(
                    index,
                    surfaceLow,
                    secondaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.verify,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      disabledBackgroundColor: primaryColor.withOpacity(0.6),
                      shape: const StadiumBorder(),
                      elevation: 6,
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text(
                            isForgotPassword
                                ? "Verifikasi OTP"
                                : "Verifikasi Akun",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Resend Link dengan Proteksi Anti-Spam
              Obx(
                () {
                  final isCooldown = controller.cooldownSeconds.value > 0;

                  return TextButton(
                    onPressed: isCooldown ? null : controller.resendCode,
                    child: Text.rich(
                      TextSpan(
                        text: "Tidak menerima kode? ",
                        style: const TextStyle(
                          color: Color(0xFF504442),
                        ),
                        children: [
                          TextSpan(
                            text: isCooldown
                                ? "Kirim Ulang (${controller.cooldownSeconds.value}s)"
                                : "Kirim Ulang Kode",
                            style: TextStyle(
                              color: isCooldown ? Colors.grey : secondaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: isCooldown
                                  ? TextDecoration.none
                                  : TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Info Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: secondaryColor,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Kode OTP berlaku selama 10 menit. Pastikan Anda memeriksa folder Spam atau Promosi jika email belum masuk.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Method untuk merender kotak OTP
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