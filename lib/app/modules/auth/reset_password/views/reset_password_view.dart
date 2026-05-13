import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

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
              const SizedBox(height: 20),
              // Illustration
              Center(
                child: Image.network(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuBu2ut4_fDquLJIMATbZWuMxgsnYXJ7F6m8ErLjdC-LByhqPJADAKXakDnCrGwhikE8CwrQ27kZ4eKUBGV0BVvwcg4loS9lRozyX1sVISJ2sNUiZxAENyehM6dyyj9kt_7X3YYO5j4nHmXzY1pY4h6j7cCoEgGbp4unO4qzKzrEe9ufGB6YpFORld-iwx1wH6aVO43t0VLJI3V-incH6iUZJNQ5wz_WlwCKajE0K-updimJMWzq-QcE1y-__jYnYtlbzwZIcBA9ryg",
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Atur Ulang Kata Sandi",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Buat kata sandi baru yang kuat untuk akun Anda.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(0xFF504442)),
              ),
              const SizedBox(height: 32),

              // Input Fields
              _buildLabel("Kata Sandi Baru", primaryColor),
              _buildPasswordField(
                controller.passwordController,
                controller.isPasswordVisible,
                controller.togglePasswordVisibility,
                surfaceLow,
              ),

              const SizedBox(height: 16),

              _buildLabel("Konfirmasi Kata Sandi Baru", primaryColor),
              _buildPasswordField(
                controller.confirmPasswordController,
                controller.isConfirmVisible,
                controller.toggleConfirmVisibility,
                surfaceLow,
              ),

              const SizedBox(height: 16),
              // Hint
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info, size: 18, color: secondaryColor),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Gunakan minimal 8 karakter dengan kombinasi angka dan simbol.",
                      style: TextStyle(fontSize: 12, color: Color(0xFF7A532A)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              // Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.savePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Simpan Kata Sandi",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  "Batalkan dan Kembali ke Masuk",
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 40),
              // Secure Badge
              const Opacity(
                opacity: 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user, size: 16),
                    SizedBox(width: 4),
                    Text(
                      "ENKRIPSI AMAN",
                      style: TextStyle(fontSize: 10, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController ctr,
    RxBool visible,
    VoidCallback onToggle,
    Color bg,
  ) {
    return Obx(
      () => TextField(
        controller: ctr,
        obscureText: !visible.value,
        decoration: InputDecoration(
          hintText: "••••••••",
          filled: true,
          fillColor: bg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              visible.value ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: onToggle,
          ),
        ),
      ),
    );
  }
}
