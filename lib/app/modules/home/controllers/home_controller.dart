import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../routes/app_pages.dart';
import '../../data/api_endpoint.dart';
import '../../data/session_manager.dart';

class HomeController extends GetxController {

  // ======================================================
  // OBSERVABLE STATES
  // ======================================================
  var isLoading = true.obs;
  var usernameDisplay = "Kak!".obs;

  // Static flag agar nilainya bertahan meski controller di-rebuild/direstart
  static bool hasShownWelcome = false;

  // ======================================================
  // USER DATA
  // ======================================================
  var userId = "".obs;
  var username = "".obs;
  var fullname = "".obs;
  var email = "".obs;
  var role = "".obs;
  var province = "".obs;
  var image = "".obs;
  var points = 0.obs;

  // ======================================================
  // SHORTCUT MENU
  // ======================================================
  final List<Map<String, dynamic>> shortcuts = [
    {
      "id": "leaderboard",
      "title": "Papan\nPeringkat",
      "icon": Icons.leaderboard_rounded,
    },
    {
      "id": "sejarah",
      "title": "Sejarah",
      "icon": Icons.history_edu_rounded,
    },
    {
      "id": "berita",
      "title": "Berita",
      "icon": Icons.newspaper_rounded,
    },
    {
      "id": "permainan",
      "title": "Permainan",
      "icon": Icons.sports_esports_rounded,
    },
  ];

  // ======================================================
  // BERITA & AKTIVITAS (LOGS)
  // ======================================================
  final RxList<Map<String, String>> topNews = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> recentLogs = <Map<String, String>>[].obs;

  // KPI untuk tampilan Home
  final RxInt totalTopNews = 0.obs;
  final RxInt totalRecentLogs = 0.obs;

  // ======================================================
  // LIFECYCLE METHOD
  // ======================================================
  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
    fetchTopActivities();
  }

  @override
  void onReady() {
    super.onReady();
    _showWelcomeSnackbarIfNeeded();
  }

  // ======================================================
  // CORE FUNCTIONS
  // ======================================================
  Future<void> loadCurrentUser() async {
    try {
      isLoading.value = true;

      if (!SessionManager.isLoggedIn || !SessionManager.hasToken()) {
        debugPrint("SESSION TIDAK DITEMUKAN - Redirecting to Login");
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      userId.value = SessionManager.userId;
      username.value = SessionManager.username;
      fullname.value = SessionManager.fullname;
      email.value = SessionManager.email;
      role.value = SessionManager.role;
      province.value = SessionManager.province;
      image.value = SessionManager.image;
      points.value = SessionManager.points;

      if (fullname.value.isNotEmpty) {
        usernameDisplay.value = fullname.value;
      } else if (username.value.isNotEmpty) {
        usernameDisplay.value = username.value;
      } else {
        usernameDisplay.value = "Kak!";
      }

      debugPrint("========== USER LOADED ==========");
      debugPrint("NAMA TAMPIL : ${usernameDisplay.value}");
      debugPrint("ROLE        : ${role.value}");
      debugPrint("=================================");

    } catch (e) {
      debugPrint("HOME ERROR : $e");
      await SessionManager.clear();
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  void _showWelcomeSnackbarIfNeeded() {
    if (!hasShownWelcome && usernameDisplay.value != "Kak!") {
      hasShownWelcome = true;

      Get.closeAllSnackbars();

      Get.snackbar(
        "Selamat Datang",
        "Halo ${usernameDisplay.value}, siap untuk berpetualang?",
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF361F1A),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        icon: const Icon(Icons.waving_hand_rounded, color: Colors.amber),
        animationDuration: const Duration(milliseconds: 400),
        isDismissible: true,
      );
    }
  }

  Future<void> refreshUser() async {
    await loadCurrentUser();
  }

  Future<void> logout() async {
    hasShownWelcome = false;
    await SessionManager.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

  // ======================================================
  // TOP ACTIVITIES (BERITA PROVINSI + INFO LOGS)
  // ======================================================
  Future<void> fetchTopActivities() async {
    try {
      final token = SessionManager.getToken();
      if (token.isEmpty) return;

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Fetch secara paralel
      final responses = await Future.wait([
        http.get(Uri.parse(ApiEndpoint.beritaProvinsiTop10), headers: headers),
        http.get(Uri.parse(ApiEndpoint.infoLogs), headers: headers),
      ]);

      final beritaRes = responses[0];
      final infoLogsRes = responses[1];

      // Helper untuk parsing tanggal
      DateTime? tryParseDate(dynamic v) {
        if (v == null) return null;
        try {
          if (v is int) {
            final ms = v > 10000000000 ? v : v * 1000;
            return DateTime.fromMillisecondsSinceEpoch(ms);
          }
          return DateTime.parse(v.toString()).toLocal();
        } catch (_) {
          return null;
        }
      }

      // Helper untuk format waktu
      String toTimeAgo(DateTime dt) {
        final diff = DateTime.now().difference(dt);
        if (diff.inMinutes < 60) return '${diff.inMinutes} menit yang lalu';
        if (diff.inHours < 24) return '${diff.inHours} jam yang lalu';
        if (diff.inDays < 7) return '${diff.inDays} hari yang lalu';
        return '${dt.day}/${dt.month}/${dt.year}';
      }

      // 1. PROSES BERITA TOP (Ambil 3 saja)
      if (beritaRes.statusCode == 200) {
        final body = jsonDecode(beritaRes.body);
        final list = body['data'] ?? body['berita'] ?? [];
        if (list is List) {
          var rawBerita = list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
          
          final mappedBerita = rawBerita.map((item) {
            final dt = tryParseDate(item['created_at'] ?? item['createdAt'] ?? item['waktu'] ?? item['time'] ?? item['tanggal']);
            return {
              'category': (item['category'] ?? item['kategori'] ?? 'BERITA').toString().toUpperCase(),
              'title': (item['title'] ?? item['judul'] ?? '').toString(),
              'image': (item['image'] ?? item['gambar'] ?? item['thumbnail'] ?? '').toString(),
              'createdAt': dt,
            };
          }).toList();

          // Sorting terbaru
          mappedBerita.sort((a, b) {
            final ad = a['createdAt'] as DateTime?;
            final bd = b['createdAt'] as DateTime?;
            if (ad == null && bd == null) return 0;
            if (ad == null) return 1;
            if (bd == null) return -1;
            return bd.compareTo(ad);
          });

          // Ambil 3 berita saja
          topNews.assignAll(mappedBerita.take(3).map((e) => <String, String>{
            'category': e['category'] as String,
            'title': e['title'] as String,
            'image': e['image'] as String,
            'time': e['createdAt'] != null ? toTimeAgo(e['createdAt'] as DateTime) : 'Baru saja',
          }));
          totalTopNews.value = topNews.length;
        }
      }

      // 2. PROSES LOG TERBARU
      if (infoLogsRes.statusCode == 200) {
        final body = jsonDecode(infoLogsRes.body);
        final list = body['data'] ?? body['logs'] ?? [];
        if (list is List) {
          var rawLogs = list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();

          final mappedLogs = rawLogs.map((item) {
            final dt = tryParseDate(item['created_at'] ?? item['createdAt'] ?? item['waktu'] ?? item['time'] ?? item['tanggal']);
            return {
              'category': (item['category'] ?? item['jenis'] ?? 'LOG SISTEM').toString().toUpperCase(),
              'title': (item['title'] ?? item['name'] ?? item['heading'] ?? item['pesan'] ?? '').toString(),
              'image': (item['image'] ?? item['icon'] ?? '').toString(),
              'createdAt': dt,
            };
          }).toList();

          // Sorting terbaru
          mappedLogs.sort((a, b) {
            final ad = a['createdAt'] as DateTime?;
            final bd = b['createdAt'] as DateTime?;
            if (ad == null && bd == null) return 0;
            if (ad == null) return 1;
            if (bd == null) return -1;
            return bd.compareTo(ad);
          });

          // Ambil log secukupnya (misal 5 log terbaru)
          recentLogs.assignAll(mappedLogs.take(5).map((e) => <String, String>{
            'category': e['category'] as String,
            'title': e['title'] as String,
            'image': e['image'] as String,
            'time': e['createdAt'] != null ? toTimeAgo(e['createdAt'] as DateTime) : 'Baru saja',
          }));
          totalRecentLogs.value = recentLogs.length;
        }
      }

    } catch (e) {
      debugPrint('HOME fetchTopActivities ERROR: $e');
    }
  }

  // ======================================================
  // ROUTING & ACTIONS
  // ======================================================
  void onNotificationTap() {
    Get.toNamed(Routes.SETTINGS);
  }

  void onShortcutTap(String id) {
    switch (id) {
      case "leaderboard":
        Get.toNamed(Routes.LEADERBOARD);
        break;
      case "sejarah":
        Get.toNamed(Routes.SEJARAH_PRAMUKA);
        break;
      case "berita":
        Get.toNamed(Routes.BERANDA_BERITA);
        break;
      case "permainan":
        Get.toNamed(Routes.BERANDA_GAME);
        break;
      default:
        Get.snackbar(
          "Informasi", 
          "Menu belum tersedia",
          backgroundColor: Colors.grey.shade800,
          colorText: Colors.white,
        );
    }
  }

  void onStartDetection() {
    Get.toNamed(Routes.SEMAPHORE_DETECT);
  }

  void onSeeAllNews() {
    Get.toNamed(Routes.BERANDA_BERITA);
  }




  void onActivityTap(Map<String, String> item) {
    Get.snackbar(
      item["category"] ?? "Info",
      item["title"] ?? "",
      backgroundColor: Colors.white,
      colorText: const Color(0xFF361F1A),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ]
    );
  }
}