import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔥 Menggunakan SharedPreferences resmi tim Flutter
import '../../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  var currentPage = 0.obs;

  final List<Map<String, String>> data = [
    {
      "title": "Belajar Materi Kepramukaan",
      "desc": "Akses ribuan modul materi pramuka digital.",
      "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDTsMU_N8FWzGlpwHQramZoVICDxpHvujn1EnaX1TUWxBQDveqn1abaNeilkasVxrijexwEA5lSWnHtDHJemZeDL7tz9GbZppQeu9ayzCL5wzww0U071mcnIS2bjjJEa96oB1zsGW_n5XlxXl5ttZoyPgAdnythAQJtQECWaQ5av6IhycQ0fzMaFi3812Z_5BhsdrH7eonSqk5ZqOMJrJMODE5ctuQ7_Aiue-PsyUzCyQhaYp6Vlei0yhPNmhaUXQZvoh2bP2chEkw",
    },
    {
      "title": "Survival & Skill Pramuka",
      "desc": "Tingkatkan keahlian bertahan hidup melalui panduan visual.",
      "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuBzVV0-02EUYdcSw4WZGTLoTrk1MPuPvKbMWXsh13mw-ReMbQbJWYK1YVb7HxkihAEY5uoyZcJ4ztYwxhH74D91N-h8zcJK7qeI78-UC20eUlY7c7cC-mC-lMWzYPmL2kmiAblF4ApZ8rij45-HEOfD_ihdttt5KgStqFazJbH5snBk6r65-ePuYxA72-fb-x4SOzCbWKxktOX_j9y4eogtShLIEyS9gMw8lsEwuTYygd-XTpRBPDoxmDfEuWtpCt31ok8x5LhDrjo",
    },
    {
      "title": "Game Edukasi Interaktif",
      "desc": "Uji pengetahuanmu dengan tantangan seru yang dirancang untuk mengasah ketangkasan pramuka.",
      "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDCrTjKWrOWDX6uTDUvH0nFzInQMU1swBD18GFzKYNA-A5PdfEC5Qjsp1CSKgWA0g9VGAfEGryfzuzFg8Mvmkq6wKJ3EXc0x85VmOweleNeM76UJLiMhmupCfPzbXswVoqgP3yU5O-tnkovHNh5FzsUabQ1yZSV04c7Mc47_KoB7jRthYGns_06KTVVaisM80uEByuE74L6WITbivIocDAyWO9vAtSYjYinOVyvuO6c2vwFKkeGt4TYWQDIRSKrhxcd7LX7sSAM20s",
    },
  ];

  void onPageChanged(int index) => currentPage.value = index;

  // Fungsi Tombol "LANJUT" / "MULAI"
  void next() async {
    if (currentPage.value < data.length - 1) {
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    } else {
      // 🔥 Ambil instansiasi preferensi native HP bray
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Kunci data secara asinkron (wajib await agar benar-benar tertulis di disk HP)
      await prefs.setBool('is_intro_seen', true);

      // Bersihkan stack halaman agar user tidak bisa back lagi ke onboarding
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // Fungsi Tombol "LEWATI" / "SKIP"
  void goToLogin() async {
    // 🔥 Ambil instansiasi preferensi native HP bray
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Kunci status bahwa user sudah melewati intro onboarding
    await prefs.setBool('is_intro_seen', true);

    // Langsung pindahkan ke halaman login tanpa menyisakan ram halaman lama bray
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose(); // Bersihkan controller page agar ram HP gak jebol (memory leak)
    super.onClose();
  }
}