import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../data/api_endpoint.dart';
import '../../../../routes/app_pages.dart';

class BerandaProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final GetStorage box = GetStorage();

  var isLoading = false.obs;

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
          "joined": profile["created_at"] ?? profile["joined"] ?? "-",
          "image": profile["image"] ?? "",
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
  // NAVIGATION
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

      await box.erase();

      Get.offAllNamed(Routes.LOGIN);

      Get.snackbar(
        "Logout Berhasil",
        "Sampai jumpa kembali",
        backgroundColor: Colors.green,
        colorText: Colors.white,
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