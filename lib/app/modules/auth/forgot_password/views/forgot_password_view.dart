import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // Definisi Warna
    const Color primaryColor = Color(0xFF361F1A);
    const Color secondaryColor = Color(0xFF7D562D);
    const Color inputBgColor = Color(0xFFF5EEE6);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF504442)),
          onPressed: controller.backToLogin,
        ),
        title: const Text(
          "Scoutify",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // --- Bagian Ilustrasi ---
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F3EE),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withOpacity(0.06),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Image.network(
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuBGusxjQOdUbHMTxLHdptc6boiy0vbTicrYmJd3i3rMHeYbcd2nleWJKkfbfbgSOo9TmwMA4icjT2JAZAA6CiFRHsqE6FgVYawvNTlKTvf5Mo0B7cgcUZPUA3EbN6it80QL8TLAyWYU2HYaUMg3mXvaCIFheOFYTL3BIV_IgYsfkCyQB1WmxRv7M5aHYrXw-AhZXqhhsMCc3rDXSNBq1kDlzGHxSuOmJIMX_QWzQG-D8eZuBKfcl1Ze3oc-5n3VKLXaaPQxzSMrTQI",
                    fit: BoxFit.contain,
                    // Fallback jika URL gambar gagal dimuat
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 80, color: Color(0xFFD4C3BF)),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // --- Bagian Tipografi (Judul & Deskripsi) ---
              const Text(
                "Lupa Kata Sandi?",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Masukkan email Anda untuk menerima kode verifikasi.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF504442)),
                ),
              ),

              const SizedBox(height: 40),

              // --- Bagian Form (Input & Tombol) ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.06),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Alamat Email",
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
                        hintText: "nama@email.com",
                        filled: true,
                        fillColor: inputBgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // --- Tombol dengan Animasi Loading ---
                    Obx(() {
                      return SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          // Disable tombol saat loading agar tidak ter-klik dua kali
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.sendResetCode,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            // Menjaga warna background saat tombol berstatus disabled
                            disabledBackgroundColor: primaryColor.withOpacity(0.8),
                            shape: const StadiumBorder(),
                            // Hilangkan bayangan saat loading
                            elevation: controller.isLoading.value ? 0 : 4,
                            shadowColor: primaryColor.withOpacity(0.4),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              // Animasi zoom in/out (scale)
                              return ScaleTransition(scale: animation, child: child);
                            },
                            // Logika pergantian widget di dalam tombol
                            child: controller.isLoading.value
                                ? const Row(
                                    key: ValueKey('loading_state'),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        "Memproses...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(
                                    key: ValueKey('idle_state'),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Kirim Kode",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.send, size: 18, color: Colors.white),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- Link Kembali ke Login ---
              GestureDetector(
                onTap: controller.backToLogin,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_left, color: secondaryColor),
                    Text(
                      "Kembali ke halaman masuk",
                      style: TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- Dekorasi Footer ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 1, width: 40, color: const Color(0xFFD4C3BF)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.park, color: Color(0xFFD4C3BF), size: 20),
                  ),
                  Container(height: 1, width: 40, color: const Color(0xFFD4C3BF)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}