import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../modules/data/session_manager.dart';
import '../../../../modules/data/api_endpoint.dart';

class BerandaSkuUserController extends GetxController {
  var isLoading = true.obs;
  var isLoadingStatus = false.obs;

  // Data User
  var userName = "".obs;
  var userImage = "".obs;
  var userPoints = 0.obs;

  // Progress SKU
  var progressRamu = 0.0.obs;
  var progressRakit = 0.0.obs;
  var progressTerap = 0.0.obs;

  var isRakitUnlocked = false.obs;
  var isTerapUnlocked = false.obs;

  // Mengamati Status Pengajuan SKU dari Server ('pending', 'approved', 'rejected', atau 'none')
  var statusPengajuanSku = "none".obs;
  var tingkatPengajuanSku = "".obs;

  final String idRamu = "11111111-1111-1111-1111-111111111111";
  final String idRakit = "22222222-2222-2222-2222-222222222222";
  final String idTerap = "33333333-3333-3333-3333-333333333333";

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    refreshDataDashboard();
  }

  void _loadUserData() {
    userName.value = SessionManager.fullname.isNotEmpty ? SessionManager.fullname : SessionManager.username;
    userImage.value = SessionManager.image;
    userPoints.value = SessionManager.points;
  }

  // Fungsi wrapper untuk memuat seluruh data secara simultan
  Future<void> refreshDataDashboard() async {
    await Future.wait([
      fetchUserSkuProgress(),
      fetchStatusPengajuanSku(),
    ]);
  }

  Future<void> fetchStatusPengajuanSku() async {
    try {
      isLoadingStatus(true);
      
      // PERBAIKAN: Menggunakan ApiEndpoint.skuStatus secara rapi tanpa hardcoded string
      final response = await http.get(
        Uri.parse(ApiEndpoint.skuStatus(SessionManager.userId)),
        headers: SessionManager.apiHeader,
      );

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        statusPengajuanSku.value = resData['status'] ?? 'none';
        tingkatPengajuanSku.value = resData['tingkat'] ?? '';
      }
    } catch (e) {
      print("Error fetchStatusPengajuanSku: $e");
    } finally {
      isLoadingStatus(false);
    }
  }

  Future<void> fetchUserSkuProgress() async {
    isLoading(true);
    try {
      String userId = SessionManager.userId;
      var results = await Future.wait([
        http.get(Uri.parse(ApiEndpoint.skuProgress(userId, idRamu)), headers: SessionManager.apiHeader),
        http.get(Uri.parse(ApiEndpoint.skuProgress(userId, idRakit)), headers: SessionManager.apiHeader),
        http.get(Uri.parse(ApiEndpoint.skuProgress(userId, idTerap)), headers: SessionManager.apiHeader), // Memperbaiki struktur pembungkusan Uri
      ]);

      if (results[0].statusCode == 200) progressRamu.value = (json.decode(results[0].body)['total_diselesaikan'] ?? 0) / 30.0;
      if (results[1].statusCode == 200) progressRakit.value = (json.decode(results[1].body)['total_diselesaikan'] ?? 0) / 30.0;
      if (results[2].statusCode == 200) progressTerap.value = (json.decode(results[2].body)['total_diselesaikan'] ?? 0) / 30.0;

      if (progressRamu.value >= 1.0) isRakitUnlocked.value = true;
      if (progressRakit.value >= 1.0) isTerapUnlocked.value = true;
    } catch (e) {
      Get.snackbar("Gangguan", "Gagal memuat progress ujian.", backgroundColor: const Color(0xFFBA1A1A).withOpacity(0.9), colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }

  // Mengubah navigasi agar menunggu feedback dari Form saat user sukses submit
  void goToFormPengajuan() async {
    // Membuka form menggunakan named route
    final result = await Get.toNamed('/form-pengajuan-page');
    
    // Jika FormPengajuan sukses mengembalikan data true, refresh dashboard otomatis
    if (result == true) {
      refreshDataDashboard();
    }
  }

}