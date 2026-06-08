import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../routes/app_pages.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // 1. Ambil instansiasi GetStorage yang sudah di-init di main.dart secara aman bray
    final box = GetStorage();
    
    // 2. Baca datanya dengan fallback nilai default yang jelas
    final bool isIntroSeen = box.read('is_intro_seen') ?? false;
    final bool isLoggedIn = box.read('is_logged_in') ?? false;
    final String? token = box.read('token');

    // 🔍 KUNCI UTAMA: PRINT DEBUG BIAR KELIHATAN DI TERMINAL LAPTOP KAMU BRAY
    print("=============================================");
    print("🛡️ [SCOUTIFY DEBUG MIDDLEWARE]");
    print("Target Rute: $route");
    print("Status is_intro_seen di HP: $isIntroSeen");
    print("Status is_logged_in di HP: $isLoggedIn");
    print("Token di HP: ${token != null ? 'ADA (Valid)' : 'KOSONG/NULL'}");
    print("=============================================");

    // JIKA USER SUDAH LOGIN, TAPI MAU COBA-COBA AKSES HALAMAN ONBOARDING ATAU LOGIN, LEMPAR KE HOME!
    if ((route == Routes.LOGIN || route == Routes.ONBOARDING) && isLoggedIn && token != null) {
      return const RouteSettings(name: Routes.HOME);
    }

    // JIKA USER MAU MASUK KE HOME TAPI BELUM LOGIN / TOKEN GAIB
    if (route == Routes.HOME && (!isLoggedIn || token == null)) {
      if (isIntroSeen) {
        print("🚨 ACTION: User sudah lihat intro tapi belum login. Tendang ke LOGIN!");
        return const RouteSettings(name: Routes.LOGIN);
      } else {
        print("🚨 ACTION: User bener-bener baru / data kosong. Tendang ke ONBOARDING!");
        return const RouteSettings(name: Routes.ONBOARDING);
      }
    }

    // Lolos tanpa hambatan bray!
    return null;
  }
}