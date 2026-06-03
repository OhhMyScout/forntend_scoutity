import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 🚨 KUNCI UTAMA: Import app_pages.dart agar GetX mengenali rute dan kelas Routes kamu bray!
import 'app/routes/app_pages.dart'; 

void main() async {
  // 1. Pastikan native engine Flutter siap menerima perintah async bray
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Ambil instansiasi Shared Preferences asli bawaan HP
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // 3. Baca datanya dari storage internal HP fisik
  bool isIntroSeen = prefs.getBool('is_intro_seen') ?? false;
  bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
  String? token = prefs.getString('token');

  // 🕵️‍♂️ PRINT DEBUG: Biar kamu bisa pantau langsung di terminal saat HP dinyalakan bray
  print("=============================================");
  print("🚀 [SCOUTIFY BOOTING INITIALIZE]");
  print("is_intro_seen di HP: $isIntroSeen");
  print("is_logged_in di HP: $isLoggedIn");
  print("token di HP: ${token != null ? 'ADA (Valid)' : 'KOSONG'}");
  print("=============================================");

  // 4. Tentukan rute pertama secara dinamis berdasarkan data di atas
  String penentuRuteAwal = Routes.ONBOARDING; // Nilai default bawaan awal

  if (isLoggedIn && token != null && token.isNotEmpty) {
    penentuRuteAwal = Routes.HOME; // Langsung tembus ke dashboard tanpa login ulang bray!
  } else if (isIntroSeen) {
    penentuRuteAwal = Routes.LOGIN; // Lewati onboarding, langsung masuk form login
  }

  print("🎯 RUTE AWAL YANG DIPILIH APLIKASI: $penentuRuteAwal");
  print("=============================================");

  runApp(
    GetMaterialApp(
      title: "Scoutify",
      debugShowCheckedModeBanner: false,
      initialRoute: penentuRuteAwal, // 🔥 Mengunci rute dinamis hasil seleksi data HP
      getPages: AppPages.routes,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Urbanist',
        colorSchemeSeed: const Color(0xFF361F1A),
      ),
    ),
  );
}