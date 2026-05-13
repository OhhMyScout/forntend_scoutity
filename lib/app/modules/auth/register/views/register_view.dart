// lib/modules/register/register_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF361F1A);
    const Color secondaryColor = Color(0xFF7D562D);
    const Color inputBgColor = Color(0xFFF6F3EE);

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F4),
      body: Stack(
        children: [
          // Background Decorative Elements
          Positioned(
            top: -100, right: -100,
            child: _blurAccent(const Color(0xFFE5E2DD).withOpacity(0.5)),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 32),
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

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 90, height: 90,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFF6F3EE), width: 4),
            ),
            child: ClipOval(child: Image.network("https://lh3.googleusercontent.com/aida-public/AB6AXuDBlUpWirBBbqgrr8fKUMSTMt4kv0Pa3keckyBpV52O4HmEjPZRIViB6SEqCIZ_j1qCqD9tB8ZbvA2kG70LJV0SzjNLgGwPwqEDgoXqdtZ9wlnUgJ-jyU5UUab-AgcV3YPZU1_TA4xmKB_VWyE4P0_yBuNgYTzqWX9_ffEwW73VSi1HUrVC6vIUwnKdVTbKf3lzxwG1Y22TDhvM0EiJ1I_OyVYqYZGuLHHxgLGFyOgzUVkl5inugMFfpVXZ23At9kM1X___GrnQ_LE", fit: BoxFit.cover)),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Daftar Akun Baru", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF361F1A), fontFamily: 'Poppins')),
        const SizedBox(height: 8),
        const Text("Bergabunglah dengan petualangan pramuka modern.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF504442))),
      ],
    );
  }

  Widget _buildForm(Color primary, Color secondary, Color inputBg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _customField("Nama Panggilan", "Contoh: Budi", controller.nicknameController, inputBg),
        _customField("Nama Lengkap", "Masukkan nama lengkap", controller.fullNameController, inputBg),
        _customField("Alamat Email", "nama@email.com", controller.emailController, inputBg),
        
        // Province Dropdown
        const Text("Provinsi", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF361F1A))),
        const SizedBox(height: 8),
        Obx(() => Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Pilih Provinsi"),
              value: controller.selectedProvince.value.isEmpty ? null : controller.selectedProvince.value,
              items: controller.provinces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) => controller.selectedProvince.value = val!,
            ),
          ),
        )),
        
        const SizedBox(height: 16),
        _customField("Kata Sandi", "Masukkan kata sandi", controller.passwordController, inputBg, isPassword: true),
        _customField("Konfirmasi Kata Sandi", "Ulangi kata sandi", controller.confirmPasswordController, inputBg, isPassword: true),
        
        // Privacy Checkbox
        Row(
          children: [
            Obx(() => Checkbox(
              value: controller.isPrivacyAccepted.value,
              onChanged: controller.togglePrivacy,
              activeColor: secondary,
            )),
            const Expanded(
              child: Text.rich(
                TextSpan(
                  text: "Menyetujui ",
                  style: TextStyle(fontSize: 12),
                  children: [
                    TextSpan(text: "Kebijakan Privasi", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7D562D))),
                    TextSpan(text: " Scoutify."),
                  ],
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(
            onPressed: controller.register,
            style: ElevatedButton.styleFrom(backgroundColor: primary, shape: const StadiumBorder()),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Daftar Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 20, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _customField(String label, String hint, TextEditingController ctr, Color bg, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF361F1A))),
        const SizedBox(height: 8),
        TextField(
          controller: ctr,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: bg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFooter(Color secondary) {
    return Center(
      child: GestureDetector(
        onTap: controller.goToLogin,
        child: Text.rich(
          TextSpan(
            text: "Sudah punya akun? ",
            style: const TextStyle(color: Color(0xFF504442)),
            children: [
              TextSpan(text: "Masuk", style: TextStyle(fontWeight: FontWeight.bold, color: secondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blurAccent(Color color) => Container(width: 300, height: 300, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}