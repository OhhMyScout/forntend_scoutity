import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../modules/data/session_manager.dart';
import '../../../../modules/data/api_endpoint.dart';
import '../../../../modules/theme/theme.dart';

class PenilaianSkuController extends GetxController {
  var isLoadingSiswa = true.obs;
  var isLoadingDetail = false.obs;
  var isSubmitting = false.obs;

  var daftarSiswaList = [].obs;
  var detailSoalList = [].obs;

  var isDetailMode = false.obs;
  var selectedSiswaName = "".obs;
  var selectedUserId = "".obs;
  var selectedLevelId = "".obs;

  var searchQuery = "".obs;
  var selectedTabFilter = "Sedang Diajukan".obs; // Pilihan: "Sedang Diajukan", "Belum Diajukan", "Semua Soal"

  @override
  void onInit() {
    super.onInit();
    fetchAntrianSiswa();
  }

  Future<void> fetchAntrianSiswa() async {
    isLoadingSiswa(true);
    try {
      // Mengirimkan ID Pembina dari SessionManager secara dinamis
      final response = await http.get(
        Uri.parse(ApiEndpoint.pembinaAntrianSiswa(SessionManager.userId)),
        headers: SessionManager.apiHeader,
      );
      
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        List<dynamic> dataSiswa = resData['data'] ?? [];
        
        // Memaksa UI memperbarui tampilannya secara instan dengan assignAll
        daftarSiswaList.assignAll(dataSiswa);
      }
    } catch (e) {
      Get.snackbar(
        "Gangguan", 
        "Gagal menyambung ke server internal.",
        backgroundColor: Colors.red.shade800,
        colorText: Colors.white
      );
    } finally {
      isLoadingSiswa(false);
    }
  }

  Future<void> fetchDetailSoaSiswa(Map<String, dynamic> siswa) async {
    selectedUserId.value = siswa['user_id'] ?? "";
    selectedLevelId.value = siswa['level_id'] ?? "11111111-1111-1111-1111-111111111111"; 
    selectedSiswaName.value = siswa['fullname'] ?? "Peserta Didik";
    
    isLoadingDetail(true);
    isDetailMode(true);
    searchQuery.value = "";
    
    try {
      final response = await http.get(
        Uri.parse(ApiEndpoint.pembinaDetailProgress(selectedUserId.value, selectedLevelId.value)),
        headers: SessionManager.apiHeader,
      );
      if (response.statusCode == 200) {
        var resData = json.decode(response.body);
        detailSoalList.value = resData['data'] ?? [];
      }
    } catch (e) {
      _showSnackbar("Gangguan", "Gagal memuat butir soal milik siswa.", AppTheme.errorColor);
    } finally {
      isLoadingDetail(false);
    }
  }

  // =========================================================
  // FILTER REAKTIF 3 KATEGORI + SEARCH BAR
  // =========================================================
  List<dynamic> get filteredSoalList {
    return detailSoalList.where((soal) {
      final String deskripsi = (soal['deskripsi'] ?? "").toString().toLowerCase();
      final String nomorPoin = (soal['nomor_poin'] ?? "").toString();
      final String query = searchQuery.value.toLowerCase();
      
      final bool matchesSearch = deskripsi.contains(query) || nomorPoin.contains(query);
      if (!matchesSearch) return false;

      final String status = soal['status'] ?? "Belum Diuji";
      
      switch (selectedTabFilter.value) {
        case "Sedang Diajukan":
          return status == "Menunggu Validasi";
        case "Belum Diajukan":
          return status == "Belum Diuji" || status == "Revisi";
        case "Semua Soal":
        default:
          return true;
      }
    }).toList();
  }

  Future<void> simpanPenilaian(String progressId, String statusHasil, String catatan) async {
    isSubmitting(true);
    Get.back();

    Get.dialog(const Center(child: CircularProgressIndicator(color: AppTheme.secondary)), barrierDismissible: false);

    try {
      final response = await http.put(
        Uri.parse(ApiEndpoint.skuValidasi(progressId)),
        headers: { ...SessionManager.apiHeader, 'Content-Type': 'application/json' },
        body: json.encode({
          "pembina_id": SessionManager.userId,
          "status": statusHasil, // 'Selesai' (Lulus) atau 'Revisi'
          "catatan": catatan.isNotEmpty ? catatan : null
        }),
      );

      Get.back();

      if (response.statusCode == 200) {
        _showSnackbar("Berhasil", "Penilaian SKU berhasil disimpan.", Colors.green);
        
        // Refresh data detail agar status card berubah instan
        fetchDetailSoaSiswa({
          'user_id': selectedUserId.value,
          'level_id': selectedLevelId.value,
          'fullname': selectedSiswaName.value
        });
      }
    } catch (e) {
      Get.back();
      _showSnackbar("Gangguan", "Gagal memproses keputusan verifikasi.", AppTheme.errorColor);
    } finally {
      isSubmitting(false);
    }
  }

  void _showSnackbar(String title, String msg, Color color) {
    Get.snackbar(title, msg, backgroundColor: color.withOpacity(0.9), colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }

  void backToSiswaList() {
    isDetailMode(false);
    fetchAntrianSiswa();
  }
}