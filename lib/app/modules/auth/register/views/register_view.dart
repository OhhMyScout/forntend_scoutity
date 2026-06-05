import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';

import '../controllers/register_controller.dart';
import '../../../../routes/app_pages.dart';

class RegisterView extends GetView<RegisterController> {
  RegisterView({super.key});

  // State lokal khusus untuk UI (menyembunyikan/menampilkan teks sandi)
  final RxBool _isPasswordHidden = true.obs;
  final RxBool _isConfirmPasswordHidden = true.obs;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);
    const inputBgColor = Color(0xFFF6F3EE);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),
      body: Stack(
        children: [
          // ================= BACKGROUND ACCENTS =================
          Positioned(
            top: -80,
            right: -50,
            child: _blurAccent(const Color(0xFFFFCA98).withOpacity(0.4), 250),
          ),
          Positioned(
            bottom: -100,
            left: -80,
            child: _blurAccent(const Color(0xFF7D562D).withOpacity(0.15), 300),
          ),
          // Efek Glassmorphism transparan menutupi background accent
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),

          // ================= MAIN CONTENT =================
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(primaryColor),
                      const SizedBox(height: 40),
                      _buildForm(primaryColor, secondaryColor, inputBgColor),
                      const SizedBox(height: 32),
                      _buildFooter(secondaryColor),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFCA98).withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.explore_rounded,
            size: 32,
            color: Color(0xFF7D562D),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Daftar Akun Baru",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Bergabunglah dengan petualangan pramuka modern dan mulai jelajahi berbagai tantangan.",
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF6B5E5B),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ================= FORM =================
  Widget _buildForm(Color primary, Color secondary, Color inputBg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _customField(
          label: "Nama Panggilan",
          hint: "Contoh: Budi",
          icon: Icons.person_outline_rounded,
          ctr: controller.nicknameController,
          bg: inputBg,
          focusColor: secondary,
        ),

        _customField(
          label: "Nama Lengkap",
          hint: "Masukkan nama lengkap",
          icon: Icons.badge_outlined,
          ctr: controller.fullNameController,
          bg: inputBg,
          focusColor: secondary,
        ),

        _customField(
          label: "Alamat Email",
          hint: "nama@email.com",
          icon: Icons.email_outlined,
          ctr: controller.emailController,
          bg: inputBg,
          focusColor: secondary,
          inputType: TextInputType.emailAddress,
        ),

        // ================= DROPDOWN PROVINSI =================
        Text(
          "Provinsi",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: primary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: inputBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: secondary),
                value: controller.selectedProvince.value,
                hint: const Row(
                  children: [
                    Icon(Icons.map_outlined, color: Colors.grey, size: 22),
                    SizedBox(width: 12),
                    Text("Pilih Provinsi", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                onChanged: controller.changeProvince,
                items: controller.provinces
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          p,
                          style: TextStyle(
                            color: p == controller.selectedProvince.value ? primary : Colors.black87,
                            fontWeight: p == controller.selectedProvince.value ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ================= KATA SANDI =================
        Obx(() => _customField(
          label: "Kata Sandi",
          hint: "Masukkan kata sandi",
          icon: Icons.lock_outline_rounded,
          ctr: controller.passwordController,
          bg: inputBg,
          focusColor: secondary,
          isPassword: true,
          isObscured: _isPasswordHidden.value,
          onTogglePassword: () => _isPasswordHidden.toggle(),
        )),

        Obx(() => _customField(
          label: "Konfirmasi Kata Sandi",
          hint: "Ulangi kata sandi",
          icon: Icons.lock_reset_rounded,
          ctr: controller.confirmPasswordController,
          bg: inputBg,
          focusColor: secondary,
          isPassword: true,
          isObscured: _isConfirmPasswordHidden.value,
          onTogglePassword: () => _isConfirmPasswordHidden.toggle(),
        )),

        // ================= PRIVACY CHECKBOX =================
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  value: controller.isPrivacyAccepted.value,
                  onChanged: controller.togglePrivacy,
                  activeColor: secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  side: BorderSide(color: secondary.withOpacity(0.5), width: 1.5),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text.rich(
                  TextSpan(
                    text: "Saya menyetujui ",
                    style: const TextStyle(color: Color(0xFF6B5E5B), fontSize: 13, height: 1.5),
                    children: [
                      TextSpan(
                        text: "Kebijakan Privasi",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: secondary,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(Routes.PRIVACY_POLICY);
                          },
                      ),
                      const TextSpan(text: " yang berlaku di aplikasi Scoutify."),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        // ================= BUTTON REGISTER =================
        SizedBox(
          width: double.infinity,
          height: 56,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.register,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
                  : const Text(
                      "Daftar Sekarang",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= CUSTOM TEXT FIELD =================
  Widget _customField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController ctr,
    required Color bg,
    required Color focusColor,
    bool isPassword = false,
    bool isObscured = false,
    VoidCallback? onTogglePassword,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF361F1A),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: ctr,
            obscureText: isObscured,
            keyboardType: inputType,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              filled: true,
              fillColor: bg,
              prefixIcon: Icon(icon, color: Colors.grey.shade600, size: 22),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: Colors.grey.shade600,
                        size: 22,
                      ),
                      onPressed: onTogglePassword,
                      splashRadius: 24,
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: focusColor, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FOOTER =================
  Widget _buildFooter(Color secondary) {
    return Center(
      child: GestureDetector(
        onTap: controller.goToLogin,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text.rich(
            TextSpan(
              text: "Sudah punya akun? ",
              style: const TextStyle(color: Color(0xFF6B5E5B), fontSize: 14),
              children: [
                TextSpan(
                  text: "Masuk",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= BACKGROUND BLOB =================
  Widget _blurAccent(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}