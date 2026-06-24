import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Pastikan sudah di-install


import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load file .env
  // Pastikan file .env ada di root project (sejajar dengan pubspec.yaml)
  await dotenv.load(fileName: ".env");

  // 2. Inisialisasi GetStorage
  await GetStorage.init();

  // 3. SUPABASE INIT (Menggunakan .env)
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  final box = GetStorage();

  final bool isIntroSeen = box.read('is_intro_seen') ?? false;
  final bool isLoggedIn = box.read('is_logged_in') ?? false;
  final String? token = box.read('token');

  debugPrint("=============================================");
  debugPrint("🚀 [SCOUTIFY BOOTING INITIALIZE]");
  debugPrint("is_intro_seen : $isIntroSeen");
  debugPrint("is_logged_in  : $isLoggedIn");
  debugPrint("token         : ${token != null && token.isNotEmpty ? 'ADA' : 'KOSONG'}");
  debugPrint("=============================================");

  String initialRoute = Routes.ONBOARDING;

  if (isLoggedIn && token != null && token.isNotEmpty) {
    initialRoute = Routes.HOME;
  } else if (isIntroSeen) {
    initialRoute = Routes.LOGIN;
  }

  debugPrint("🎯 RUTE AWAL YANG DIPILIH: $initialRoute");

  runApp(
    GetMaterialApp(
      title: "Scoutify",
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Urbanist",
        colorSchemeSeed: const Color(0xFF361F1A),
      ),
    ),
  );
}