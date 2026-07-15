import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../modules/data/api_endpoint.dart'; // Sesuaikan path ApiEndpoint Anda
import '../../../modules/data/session_manager.dart'; 

class BerandaSkuAdminController extends GetxController {
  var listPengajuan = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getDaftarPengajuan();
  }

  // Mengambil daftar pengajuan pembina yang berstatus 'pending'
  Future<void> getDaftarPengajuan() async {
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse('${ApiEndpoint.baseUrl}/pengajuan/admin/pengajuan-pembina'),
        headers: SessionManager.apiHeader,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          listPengajuan.assignAll(responseData['data']);
        }
      } else {
        Get.snackbar('Gagal', 'Gagal memuat data pengajuan dari server.',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      print("Error getDaftarPengajuan: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi untuk memproses Aksi Setuju atau Tolak
  Future<void> prosesVerifikasi(String pengajuanId, String statusDecision, {String? catatan}) async {
    try {
      isLoading.value = true;
      
      final response = await http.put(
        Uri.parse('${ApiEndpoint.baseUrl}/pengajuan/admin/pengajuan-pembina/$pengajuanId'),
        headers: {
          ...SessionManager.apiHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': statusDecision,
          'catatan_admin': catatan ?? '',
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses', 
          statusDecision == 'approved' ? 'Pengajuan disetujui!' : 'Pengajuan ditolak.',
          backgroundColor: Colors.green, 
          colorText: Colors.white
        );
        // Segera segarkan data list pengajuan di halaman admin
        getDaftarPengajuan();
      } else {
        final errorBody = jsonDecode(response.body);
        Get.snackbar('Gagal', errorBody['detail']['message'] ?? 'Gagal memproses aksi.',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      print("Error prosesVerifikasi: $e");
    } finally {
      isLoading.value = false;
    }
  }
}