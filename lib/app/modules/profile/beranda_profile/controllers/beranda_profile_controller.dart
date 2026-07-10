import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart'; // IMPORT INI

import '../../../data/api_endpoint.dart';
import '../../../../routes/app_pages.dart';

class BerandaProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GetStorage box = GetStorage();

  var isLoading = false.obs;
  var isGoogleLoading = false.obs; // Loading khusus untuk tombol Google

  // Inisialisasi Google Sign In
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final user = <String, dynamic>{
    "id": 0,
    "username": "",
    "fullname": "",
    "email": "",
    "role": "",
    "points": "0 Points",
    "province": "-",
    "gudep": "isi gudep mu",
    "joined": "-",
    "image": "",
    "google_linked": false, // Status apakah akun google terkait
    "google_email": "",     // Email google yang terkait (jika ada)
  }.obs;

  @override
  void onInit() {
    super.onInit();

    loadUserSession();

    // 🔥 AUTO REFRESH SAAT MASUK PAGE
    Future.delayed(
      const Duration(milliseconds: 200),
      () => getProfile(),
    );
  }

  // =====================================================
  // LOAD LOCAL CACHE (FAST UI FIRST LOAD)
  // =====================================================
  void loadUserSession() {
    user.value = {
      "id": box.read("user_id") ?? 0,
      "username": box.read("username") ?? "",
      "fullname": box.read("fullname") ?? "",
      "email": box.read("email") ?? "",
      "role": box.read("role") ?? "",
      "points": box.read("points") ?? "0 Points",
      "province": box.read("province") ?? "-",
      "gudep": box.read("gudep") ?? "isi gudep mu",
      "joined": box.read("joined") ?? "-",
      "image": box.read("image") ?? "",
      "google_linked": box.read("google_linked") ?? false,
      "google_email": box.read("google_email") ?? "",
    };
  }

  // =====================================================
  // FORCE REFRESH (REAL DATA ALWAYS)
  // =====================================================
  Future<void> getProfile({bool force = true}) async {
    try {
      isLoading.value = true;

      final token = box.read("token");

      if (token == null || token.toString().isEmpty) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoint.profile),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "Cache-Control": "no-cache", // 🔥 force no cache
        },
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final profile = result["user"];

        // Format tanggal bergabung menjadi lebih rapi
        String formattedJoined = "-";
        if (profile["created_at"] != null || profile["joined"] != null) {
           try {
             DateTime dt = DateTime.parse(profile["created_at"] ?? profile["joined"]).toLocal();
             formattedJoined = "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
           } catch (e) {
             formattedJoined = profile["created_at"] ?? profile["joined"];
           }
        }

        // =====================================================
        // NORMALIZE DATA (ANTI NULL + CONSISTENT FIELD)
        // =====================================================
        final freshUser = {
          "id": profile["id"] ?? 0,
          "username": profile["username"] ?? "",
          "fullname": profile["fullname"] ?? "",
          "email": profile["email"] ?? "",
          "role": profile["role"] ?? "",
          "points": profile["points"]?.toString() ?? "0 Points",
          "province": profile["province"] ?? "-",
          "gudep": profile["gudep"] ?? "isi gudep mu",
          "joined": formattedJoined,
          "image": profile["image"] ?? "",
          "google_linked": profile["google_linked"] ?? false, // Ambil dari API
          "google_email": profile["google_email"] ?? "",
        };

        user.value = freshUser;

        // =====================================================
        // UPDATE STORAGE
        // =====================================================
        await box.write("user_id", freshUser["id"]);
        await box.write("username", freshUser["username"]);
        await box.write("fullname", freshUser["fullname"]);
        await box.write("email", freshUser["email"]);
        await box.write("role", freshUser["role"]);
        await box.write("province", freshUser["province"]);
        await box.write("gudep", freshUser["gudep"]);
        await box.write("points", freshUser["points"]);
        await box.write("image", freshUser["image"]);
        await box.write("joined", freshUser["joined"]);
        await box.write("google_linked", freshUser["google_linked"]);
        await box.write("google_email", freshUser["google_email"]);
      } else if (response.statusCode == 401) {
        await logout();
      } else {
        debugPrint("PROFILE ERROR: $result");
      }
    } catch (e) {
      debugPrint("GET PROFILE ERROR : $e");
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // 🔥 AUTO REFRESH SETIAP KEMBALI KE PAGE
  // =====================================================
  @override
  void onReady() {
    super.onReady();
    getProfile(); // refresh saat page ready
  }

  // =====================================================
  // REFRESH MANUAL (PULL TO REFRESH)
  // =====================================================
  Future<void> refreshProfile() async {
    await getProfile();
  }

  // =====================================================
  // NAVIGATION & ACTIONS
  // =====================================================
  void goToEditProfile() {
    Get.toNamed(Routes.EDIT_PROFILE)?.then((_) {
      // 🔥 refresh setelah balik dari edit profile
      getProfile();
    });
  }

  void goToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }

  void goToInfoLogs() {
    // Pastikan '/info-logs' sudah terdaftar di daftar routes Anda (misal: AppPages.dart)
    Get.toNamed('/info-logs'); 
  }

  // =====================================================
  // KONEKSI & LOGIKA GOOGLE SIGN-IN (FUNGSIONAL)
  // =====================================================
  Future<void> handleGoogleConnection() async {
    try {
      isGoogleLoading.value = true;

      // Ambil data link Google yang tersimpan di server (state saat ini)
      final bool isLinked = user["google_linked"] ?? false;
      final String storedGoogleEmail = (user["google_email"] ?? "").toString();

      // 1) Munculkan Pop-up pilihan Akun Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Jika user batal memilih akun
      if (googleUser == null) {
        return;
      }

      final String selectedEmail = (googleUser.email ?? "").toString();

      // 2) Logika "tidak boleh 1 user memiliki 2 akun google"
      // Jika user sudah terhubung dan memilih akun email yang berbeda,
      // logout Google lama di device supaya yang aktif hanya email baru.
      // Penting: jangan signIn lagi, gunakan `googleUser` yang sudah terpilih.
      if (isLinked && selectedEmail.isNotEmpty && storedGoogleEmail.isNotEmpty && selectedEmail != storedGoogleEmail) {
        await _googleSignIn.signOut();
      }

      final token = box.read("token");


      // PANGGIL ENDPOINT BACKEND ANDA UNTUK MENAUTKAN AKUN
      final response = await http.post(
        Uri.parse(ApiEndpoint.linkGoogle),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "google_id": googleUser.id,
          "google_email": selectedEmail,
          "google_name": googleUser.displayName,
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        user["google_linked"] = true;
        user["google_email"] = selectedEmail;
        user.refresh();

        await box.write("google_linked", true);
        await box.write("google_email", selectedEmail);

        Get.snackbar(
          "Berhasil Terhubung",
          "Akun Google (${selectedEmail}) berhasil ditautkan.",
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        // Gagal di sisi server, batalkan autentikasi Google di lokal
        await _googleSignIn.signOut();
        Get.snackbar(
          "Gagal Menghubungkan",
          result["message"] ?? "Terjadi kesalahan pada server.",
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      debugPrint("GOOGLE SIGN IN ERROR: $error");
      Get.snackbar(
        "Error",
        "Terjadi kesalahan pada aplikasi/jaringan.",
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

Future<void> linkGoogle() async {
  try {
    // TODO:
    // Login Google
    // Simpan email ke database
    // Update user

    Get.snackbar(
      "Berhasil",
      "Akun Google berhasil dihubungkan",
    );
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
    );
  }
}

Future<void> unlinkGoogle() async {
  try {
    // TODO:
    // Hapus relasi akun Google
    // Update database

    Get.snackbar(
      "Berhasil",
      "Akun Google berhasil diputuskan",
    );
  } catch (e) {
    Get.snackbar(
      "Error",
      e.toString(),
    );
  }
}


  // =====================================================
  // LOGOUT
  // =====================================================
  Future<void> logout() async {
    try {
      isLoading.value = true;

      final token = box.read("token");

      if (token != null && token.toString().isNotEmpty) {
        try {
          await http.post(
            Uri.parse(ApiEndpoint.logout),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
          );
        } catch (_) {}
      }

      // Sign out dari Google jika sedang login (opsional)
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }

      await box.erase();

      Get.offAllNamed(Routes.LOGIN);

      Get.snackbar(
        "Logout Berhasil",
        "Sampai jumpa kembali di petualangan selanjutnya!",
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      await box.erase();
      Get.offAllNamed(Routes.LOGIN);
      debugPrint("LOGOUT ERROR : $e");
    } finally {
      isLoading.value = false;
    }
  }
}


