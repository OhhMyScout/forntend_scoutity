// lib/modules/login/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/gestures.dart';
import 'package:scoutify/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF361F1A);
    const Color backgroundColor = Color(0xFFFCF9F4);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
          child: Column(
            children: [
              // Top Branding
              Column(
                children: [
                  const Text("Scoutify", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Poppins')),
                  const SizedBox(height: 24),
                  Container(
                    width: 180, height: 180,
                    decoration: BoxDecoration(color: Colors.brown[50], shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.network(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuB-PTDhdxCv0dt68JQNzOFytrTEednrjbaFCCLJQKQDnEx4NRFhfNNGTtolLUKlIYHasBNaXz0Iozref3_49B-HCP6P93JmPjf2zjCYlwwBtKe3ZtvnswsVJS4PNkq9ZvtzM9qsol0IJJ44xytesBJC0jQZd4NwHZmO3GfheLSDJe65POQ02_dssmkzWe6lXbtrJhGIZbMhxaUknLi5xgnd_QcYwESnjZzxBjaGwU0ixlb6EHQ1tv-5uRoaN5UohgSTRZBzsPk9zuU",
                        fit: BoxFit.cover,
                        color: Colors.brown.withOpacity(0.4),
                        colorBlendMode: BlendMode.saturation,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text("Welcome Back, Scout", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor)),
                  const Text("Continue your journey into the wild.", style: TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 40),

              // Login Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.06), blurRadius: 30, offset: const Offset(0, 10))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Email Address", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        hintText: "scout@wilderness.org",
                        filled: true,
                        fillColor: const Color(0xFFF6F3EE),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Di dalam Login View, bagian kolom Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Password", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                        TextButton(
                          onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD), // Tambahkan ini
                          child: const Text("Forgot?", style: TextStyle(color: Color(0xFF7D562D))),
                        ),
                      ],
                    ),
                    Obx(() => TextField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        filled: true,
                        fillColor: const Color(0xFFF6F3EE),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          icon: Icon(controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ),
                    )),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity, height: 56,
                      child: ElevatedButton(
                        onPressed: controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sign In", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("or explore via", style: TextStyle(color: Colors.grey, fontSize: 12))),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        side: const BorderSide(color: Color(0xFFD4C3BF)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("Google", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              
              Text.rich( 
                TextSpan(
                  text: "New to the troop? ",
                  style: const TextStyle(color: Colors.grey), // const boleh tetap ada di sini (TextStyle)
                  children: [
                    TextSpan(
                      text: "Create an account",
                      style: const TextStyle(color: Color(0xFF7D562D), fontWeight: FontWeight.bold),
                      // Lepaskan const, biarkan recognizer dibuat secara dinamis
                      recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed(Routes.REGISTER),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}