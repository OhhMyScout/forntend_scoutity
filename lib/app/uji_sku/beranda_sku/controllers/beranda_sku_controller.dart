import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Sesuaikan letak path data kamu
import '../../../modules/data/session_manager.dart';
import '../../../modules/data/api_endpoint.dart';

class BerandaSkuController extends GetxController {
  var isLoading = true.obs;

  // Data Lengkap User dari Session
  var userId = "".obs;
  var userName = "".obs;
  var userEmail = "".obs;
  var userRole = "".obs;
  var userProvince = "".obs;
  var userPoints = 0.obs;
  var userImage = "".obs;

  // Progress SKU
  var progressRamu = 0.0.obs;
  var progressRakit = 0.0.obs;
  var progressTerap = 0.0.obs;

  final String idRamu = "11111111-1111-1111-1111-111111111111";
  final String idRakit = "22222222-2222-2222-2222-222222222222";
  final String idTerap = "33333333-3333-3333-3333-333333333333";

  @override
  void onInit() {
    super.onInit();
    _loadSessionData();
    
    // Jika role-nya user biasa, tarik data progress. 
    // Jika Admin/Pembina, bisa langsung kita set loading false karena mereka fokus menguji, bukan diuji.
    if (userRole.value.toLowerCase() == 'user') {
      fetchUserSkuProgress();
    } else {
      isLoading(false);
    }
  }

  void _loadSessionData() {
    userId.value = SessionManager.userId;
    userName.value = SessionManager.fullname.isNotEmpty ? SessionManager.fullname : SessionManager.username;
    userEmail.value = SessionManager.email;
    userRole.value = SessionManager.role.toUpperCase(); // Cth: USER, PEMBINA, ADMIN
    userProvince.value = SessionManager.province;
    userPoints.value = SessionManager.points;
    userImage.value = SessionManager.image;
  }

  Future<void> fetchUserSkuProgress() async {
    isLoading(true);
    try {
      var results = await Future.wait([
        http.get(Uri.parse(ApiEndpoint.skuProgress(userId.value, idRamu)), headers: SessionManager.apiHeader),
        http.get(Uri.parse(ApiEndpoint.skuProgress(userId.value, idRakit)), headers: SessionManager.apiHeader),
        http.get(Uri.parse(ApiEndpoint.skuProgress(userId.value, idTerap)), headers: SessionManager.apiHeader),
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
      Get.snackbar(
        "Koneksi Gagal", 
        "Gagal menyinkronkan data progress SKU.",
        backgroundColor: const Color(0xFFBA1A1A).withValues(alpha: 0.9), 
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Fungsi dinamis untuk berpindah halaman sesuai role
  void goToRoleDashboard() {
    String role = SessionManager.role.toLowerCase();
    
    if (role == 'admin') {
      Get.toNamed('/beranda-sku-admin');
    } else if (role == 'pembina') {
      Get.toNamed('/beranda-sku-pembina');
    } else {
      Get.toNamed('/beranda-sku-user');
    }
  }
}