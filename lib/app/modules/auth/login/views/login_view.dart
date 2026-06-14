import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:scoutify/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {
  final LoginController controller = Get.find<LoginController>();

  // Setup Animasi
  late AnimationController _animationController;
  
  // Header Animations
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _headerScaleAnimation;

  // Card & Footer Animations
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;
  late Animation<double> _footerFadeAnimation;
  late Animation<Offset> _footerSlideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    // ==========================================
    // 1. ANIMASI HEADER 
    // ==========================================
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
      ),
    );
    _headerSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOutCubic),
      ),
    );
    _headerScaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.30, curve: Curves.easeOutBack),
      ),
    );

    // ==========================================
    // 2. ANIMASI FORM
    // ==========================================
    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.70, 0.90, curve: Curves.easeOutCubic),
      ),
    );
    _cardSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.70, 0.90, curve: Curves.easeOutCubic),
      ),
    );

    // ==========================================
    // 3. ANIMASI FOOTER
    // ==========================================
    _footerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _footerSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF361F1A);
    const Color backgroundColor = Color(0xFFFCF9F4);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                
                // 1. TOP BRANDING
                FadeTransition(
                  opacity: _headerFadeAnimation,
                  child: SlideTransition(
                    position: _headerSlideAnimation,
                    child: ScaleTransition(
                      scale: _headerScaleAnimation,
                      child: Column(
                        children: [
                          const Text(
                            "Scoutify",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.brown[50],
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                "https://lh3.googleusercontent.com/aida-public/AB6AXuB-PTDhdxCv0dt68JQNzOFytrTEednrjbaFCCLJQKQDnEx4NRFhfNNGTtolLUKlIYHasBNaXz0Iozref3_49B-HCP6P93JmPjf2zjCYlwwBtKe3ZtvnswsVJS4PNkq9ZvtzM9qsol0IJJ44xytesBJC0jQZd4NwHZmO3GfheLSDJe65POQ02_dssmkzWe6lXbtrJhGIZbMhxaUknLi5xgnd_QcYwESnjZzxBjaGwU0ixlb6EHQ1tv-5uRoaN5UohgSTRZBzsPk9zuU",
                                fit: BoxFit.cover,
                                color: Colors.brown.withOpacity(0.4),
                                colorBlendMode: BlendMode.saturation,
                                errorBuilder: (context, error, stackTrace) => 
                                    const Icon(Icons.person, size: 80, color: Colors.grey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Welcome Back, Scout",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const Text(
                            "Continue your journey into the wild.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 2. LOGIN CARD 
                FadeTransition(
                  opacity: _cardFadeAnimation,
                  child: SlideTransition(
                    position: _cardSlideAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.06),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Email Address",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "scout@wilderness.org",
                              filled: true,
                              fillColor: const Color(0xFFF6F3EE),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                                child: const Text(
                                  "Forgot?",
                                  style: TextStyle(color: Color(0xFF7D562D)),
                                ),
                              ),
                            ],
                          ),
                          
                          Obx(
                            () => TextField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                hintText: "••••••••",
                                filled: true,
                                fillColor: const Color(0xFFF6F3EE),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: controller.togglePasswordVisibility,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Obx(() => ElevatedButton(
                              onPressed: controller.isLoading.value ? null : controller.login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                disabledBackgroundColor: primaryColor.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Sign In",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                            )),
                          ),
                          const SizedBox(height: 24),
                          const Row(
                            children: [
                              Expanded(child: Divider()),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  "or explore via",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // ==========================================
                          // TOMBOL GOOGLE LOGIN (Telah Diperbarui)
                          // ==========================================
                          Obx(
                            () => OutlinedButton.icon(
                              onPressed: controller.isGoogleLoading.value
                                  ? null
                                  : controller.loginWithGoogle,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56),
                                side: const BorderSide(
                                  color: Color(0xFFD4C3BF),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: controller.isGoogleLoading.value
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: primaryColor,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.g_mobiledata,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                              label: Text(
                                controller.isGoogleLoading.value
                                    ? "Loading..."
                                    : "Continue with Google",
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // 3. FOOTER
                FadeTransition(
                  opacity: _footerFadeAnimation,
                  child: SlideTransition(
                    position: _footerSlideAnimation,
                    child: Text.rich(
                      TextSpan(
                        text: "New to the troop? ",
                        style: const TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: "Create an account",
                            style: const TextStyle(
                              color: Color(0xFF7D562D),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed(Routes.REGISTER),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}