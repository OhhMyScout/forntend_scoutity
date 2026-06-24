import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


import '../../../../routes/app_pages.dart';
import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart';

class BerandaGameController extends GetxController {
  // ==========================================
  // STATE
  // ==========================================
  final selectedIndex = 2.obs;
  final isLoading = false.obs;

  final myPoint = 0.obs;
  final myRank = 0.obs;

  final games = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  // ==========================================
  // FETCH DATA
  // ==========================================
  Future<void> fetchData() async {
    try {
      isLoading.value = true;

      final token = SessionManager.token ?? '';
      final email = SessionManager.email;

      debugPrint("TOKEN GAME: $token");
      debugPrint("EMAIL GAME: $email");

      // =====================================================
      // VALIDASI SESSION
      // =====================================================
      if (token.isEmpty) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final response = await http.get(
        Uri.parse(ApiEndpoint.leaderboard),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final List<dynamic> users = result["data"] ?? [];

        // SORT RANK
        users.sort((a, b) {
          final aPoint = int.tryParse(a["points"].toString()) ?? 0;
          final bPoint = int.tryParse(b["points"].toString()) ?? 0;
          return bPoint.compareTo(aPoint);
        });

        // FIND USER
        final myIndex = users.indexWhere(
          (u) => (u["email"] ?? "").toString().toLowerCase() ==
                 email.toLowerCase(),
        );

        if (myIndex != -1) {
          myRank.value = myIndex + 1;
          myPoint.value =
              int.tryParse(users[myIndex]["points"].toString()) ?? 0;
        } else {
          myRank.value = 0;
          myPoint.value = 0;
        }
      }

      // =====================================================
      // STATIC GAME LIST (SAFE IMAGE + CLEAN)
      // =====================================================
      games.assignAll([
        {
          "title": "Sandi Kotak I",
          "description": "Menebak kata sandi kotak 1 dan dapatkan poin.",
          "image":
              "assets/images/games/sandi_kotak1.jpg",
          "button": "Main Sekarang",
          "route": Routes.KOTAK1_CHALLENGE,
        },
        {
          "title": "Sandi Kotak II",
          "description": "Level lanjutan sandi kotak.",
          "image":
              "assets/images/games/sandi_kotak2.jpg",
          "button": "Main Sekarang",
          "route": Routes.KOTAK2_CHALLENGE,
        },
        {
          "title": "Sandi Morse",
          "description": "Latihan sandi morse interaktif.",
          "image":
              "assets/images/games/sandi_morse.jpg",
          "button": "Main Sekarang",
          "route": Routes.MORSE_CHALLENGE,
        },
      ]);
    } catch (e) {
      debugPrint("[BERANDA GAME ERROR] $e");

      Get.snackbar(
        "Error",
        "Gagal memuat data game",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================
  // ACTIONS
  // ==========================================
  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void openNotification() {
    Get.toNamed(Routes.SETTINGS);
  }

  void openSemaphoreDetection() {
    Get.toNamed(Routes.SEMAPHORE_DETECT);
  }

  void openLeaderboard() {
    Get.toNamed(Routes.LEADERBOARD);
  }

  void openGame(Map<String, dynamic> game) {
    final route = game["route"];

    if (route != null) {
      Get.toNamed(route);
    } else {
      Get.snackbar(
        "Info",
        "Game belum tersedia",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}