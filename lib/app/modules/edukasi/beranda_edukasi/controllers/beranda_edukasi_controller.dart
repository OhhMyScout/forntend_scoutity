import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../data/session_manager.dart';
import '../../../data/api_endpoint.dart';

class BerandaEdukasiController extends GetxController {
  // ==========================================
  // DATA EDUKASI (STATIS / LOKAL)
  // ==========================================
  final materiList = [
    {
      "title": "Sandi Pramuka",
      "description": "Pelajari Sandi Morse, Semaphore, Sandi Kotak, dan Sandi Rumput.",
      "icon": Icons.message_rounded,
      "color": const Color(0xFF7D562D), 
    },
    {
      "title": "Tali Temali Dasar",
      "description": "Kuasai berbagai macam simpul dan ikatan dasar kepramukaan.",
      "icon": Icons.cable_rounded,
      "color": const Color(0xFF4E342E),
    },
    {
      "title": "Kompas & Pemetaan",
      "description": "Navigasi darat, membaca arah mata angin, dan menaksir jarak.",
      "icon": Icons.explore_rounded,
      "color": const Color(0xFF827471), 
    }
  ].obs;

  // ==========================================
  // DATA USER & PROGRESS SKU (REAL API)
  // ==========================================
  var userName = "".obs;
  var userPoints = 0.obs;
  var userImage = "".obs;
  var userRole = "".obs;

  var isLoadingProgress = true.obs;
  var progressRamu = 0.0.obs;
  var progressRakit = 0.0.obs;
  var progressTerap = 0.0.obs;

  final String idRamu = "11111111-1111-1111-1111-111111111111";
  final String idRakit = "22222222-2222-2222-2222-222222222222";
  final String idTerap = "33333333-3333-3333-3333-333333333333";

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    fetchUserSkuProgress(); // Ambil progress di latar belakang
  }

  void _loadUserData() {
    userName.value = SessionManager.fullname.isNotEmpty 
        ? SessionManager.fullname 
        : (SessionManager.username.isNotEmpty ? SessionManager.username : "Pramuka");
    userPoints.value = SessionManager.points;
    userImage.value = SessionManager.image;
    userRole.value = SessionManager.role;
  }

  Future<void> fetchUserSkuProgress() async {
    isLoadingProgress(true);
    try {
      String userId = SessionManager.userId;
      
      // Tembak 3 API Progress SKU secara bersamaan agar super cepat
      var results = await Future.wait([
        http.get(Uri.parse(ApiEndpoint.skuProgress(userId, idRamu)), headers: SessionManager.apiHeader),
        http.get(Uri.parse(ApiEndpoint.skuProgress(userId, idRakit)), headers: SessionManager.apiHeader),
        http.get(Uri.parse(ApiEndpoint.skuProgress(userId, idTerap)), headers: SessionManager.apiHeader),
      ]);

      if (results[0].statusCode == 200) {
        var dataRamu = json.decode(results[0].body);
        progressRamu.value = (dataRamu['total_diselesaikan'] ?? 0) / 30.0;
      }
      if (results[1].statusCode == 200) {
        var dataRakit = json.decode(results[1].body);
        progressRakit.value = (dataRakit['total_diselesaikan'] ?? 0) / 30.0;
      }
      if (results[2].statusCode == 200) {
        var dataTerap = json.decode(results[2].body);
        progressTerap.value = (dataTerap['total_diselesaikan'] ?? 0) / 30.0;
      }
    } catch (e) {
      print("Error fetching SKU: $e");
    } finally {
      isLoadingProgress(false);
    }
  }

  // ==========================================
  // FUNGSI NAVIGASI
  // ==========================================
  void openSejarah() {
    Get.toNamed('/sejarah-pramuka');
  }

  void openMateri(String title) {
    // Mapping materi ke route edukasi yang sudah tersedia.
    // Jika suatu route belum ada untuk materi tsb, fallback ke snackbar.
    final normalized = title.trim().toLowerCase();

    if (normalized.contains('sandi')) {
      // Sandi Pramuka (Morse/Semaphore/Kotak) belum punya route spesifik di beranda edukasi,
      // jadi arahkan ke menu edukasi yang tersedia terdekat.
      Get.toNamed('/');
      return;
    }

    if (normalized.contains('tali')) {
      // Tali Temali
      Get.toNamed('/tali-temali');
      return;
    }

    if (normalized.contains('kompas')) {
      // Kompas & Pemetaan
      Get.toNamed('/beranda-survival');
      return;
    }

    Get.snackbar('Materi Edukasi', 'Belum ada modul untuk "$title"', snackPosition: SnackPosition.BOTTOM);
  }

  void lihatSemua() {
    // Tidak ada route khusus "daftar semua materi" di project ini,
    // jadi fallback ke salah satu modul edukasi yang tersedia.
    Get.toNamed('/sejarah-pramuka');
  }


  void goToUjiSku() {
    Get.toNamed('/beranda-sku');
  }
}