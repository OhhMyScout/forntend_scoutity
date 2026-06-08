import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // =====================================================
  // INISIALISASI GET STORAGE
  // =====================================================

  await GetStorage.init();

  final box = GetStorage();

  // =====================================================
  // BACA DATA SESSION
  // =====================================================

  final bool isIntroSeen =
      box.read('is_intro_seen') ?? false;

  final bool isLoggedIn =
      box.read('is_logged_in') ?? false;

  final String? token =
      box.read('token');

  // =====================================================
  // DEBUG LOG
  // =====================================================

  debugPrint("=============================================");
  debugPrint("🚀 [SCOUTIFY BOOTING INITIALIZE]");
  debugPrint("is_intro_seen : $isIntroSeen");
  debugPrint("is_logged_in  : $isLoggedIn");
  debugPrint(
    "token         : ${token != null && token.isNotEmpty ? 'ADA' : 'KOSONG'}",
  );
  debugPrint("=============================================");

  // =====================================================
  // PENENTUAN HALAMAN AWAL
  // =====================================================

  String initialRoute = Routes.ONBOARDING;

  if (isLoggedIn &&
      token != null &&
      token.isNotEmpty) {
    initialRoute = Routes.HOME;
  } else if (isIntroSeen) {
    initialRoute = Routes.LOGIN;
  }

  debugPrint(
    "🎯 RUTE AWAL YANG DIPILIH: $initialRoute",
  );

  debugPrint("=============================================");

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