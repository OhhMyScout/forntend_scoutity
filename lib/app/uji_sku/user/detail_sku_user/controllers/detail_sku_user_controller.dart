import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../modules/data/session_manager.dart';
import '../../../../modules/data/api_endpoint.dart';
import '../../../../modules/theme/theme.dart';

class DetailSkuUserController extends GetxController {
  var isLoading = true.obs;
  var isSubmitting = false.obs;

  var title = "".obs;
  var levelId = "".obs;

  var skuMasterList = [].obs;
  var userProgressList = [].obs;

  // State untuk Fitur Search & Filter Tambahan
  var searchQuery = "".obs;
  var selectedFilter = "Semua".obs; // Pilihan: "Semua", "Lulus", "Menunggu Verifikasi", "Belum Uji"

  @override
  void onInit() {
    super.onInit();
    levelId.value = Get.arguments?['level_id'] ?? "";
    title.value = Get.arguments?['title'] ?? "Buku Saku SKU";
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading(true);
    try {
      String userId = SessionManager.userId;

      var results = await Future.wait([
        http.get(
          Uri.parse('${ApiEndpoint.skuMaster}/${levelId.value}'), 
          headers: SessionManager.apiHeader
        ),
        http.get(
          Uri.parse(ApiEndpoint.skuProgress(userId, levelId.value)), 
          headers: SessionManager.apiHeader
        ),
      ]);

      if (results[0].statusCode == 200) {
        var dataMaster = json.decode(results[0].body);
        skuMasterList.value = dataMaster['data'] ?? [];
      }

      if (results[1].statusCode == 200) {
        var dataProgress = json.decode(results[1].body);
        userProgressList.value = dataProgress['data'] ?? [];
      }
    } catch (e) {
      Get.snackbar(
        "Koneksi Terputus", 
        "Gagal memuat daftar tugas SKU.",
        backgroundColor: AppTheme.errorColor.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  String getStatusPoin(String skuId) {
    var progress = userProgressList.firstWhere(
      (p) => p['uji_sku_id'] == skuId, 
      orElse: () => null
    );
    if (progress == null) return "Belum Diuji";
    return progress['status'] ?? "Belum Diuji";
  }

  // =========================================================
  // LOGIKA FILTER & SEARCH REAKTIF (COMPUTED LIST)
  // =========================================================
  List<dynamic> get filteredSkuMasterList {
    return skuMasterList.where((soal) {
      // 1. Filter Berdasarkan Text Search (Mencari nomor poin atau isi deskripsi)
      final String deskripsi = (soal['deskripsi'] ?? "").toString().toLowerCase();
      final String nomorPoin = (soal['nomor_poin'] ?? "").toString();
      final String query = searchQuery.value.toLowerCase();
      
      final bool matchesSearch = deskripsi.contains(query) || nomorPoin.contains(query);

      if (!matchesSearch) return false;

      // 2. Filter Berdasarkan Pilihan Tab Status
      final String status = getStatusPoin(soal['id']);
      
      switch (selectedFilter.value) {
        case "Lulus":
          return status == "Selesai";
        case "Menunggu Verifikasi":
          return status == "Menunggu Validasi";
        case "Belum Uji":
          return status == "Belum Diuji" || status == "Revisi";
        case "Semua":
        default:
          return true;
      }
    }).toList();
  }

  Future<void> ajukanUjian(String skuId, String buktiUrl) async {
    isSubmitting(true);
    Get.back(); // Tutup dialog input

    Get.dialog(
      const Center(child: CircularProgressIndicator(color: AppTheme.secondary)), 
      barrierDismissible: false
    );

    try {
      // PERHATIKAN: Pastikan endpoint mengarah ke '/api/uji-sku/ajukan'
      final response = await http.post(
        Uri.parse(ApiEndpoint.skuAjukan), 
        headers: {
          ...SessionManager.apiHeader,
          'Content-Type': 'application/json', // Wajib sertakan content-type agar Pydantic lancar membaca
        },
        body: json.encode({
          "user_id": SessionManager.userId,
          "uji_sku_id": skuId,
          "bukti_url": buktiUrl.isNotEmpty ? buktiUrl : null
        }),
      );

      Get.back(); // Tutup loading

      final resData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Berhasil!", 
          resData['message'] ?? "Laporanmu sudah diserahkan ke Kakak Pembina.",
          backgroundColor: Colors.green.withOpacity(0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        fetchData(); // Muat ulang data halaman agar status kartu berubah
      } else {
        // Mencegah crash jika error terlempar dari skema FastAPI
        String pesanGagal = "Terjadi kesalahan sistem.";
        if (resData['detail'] != null) {
          pesanGagal = resData['detail']['message'] ?? resData['detail'].toString();
        }
        
        Get.snackbar(
          "Gagal Mengajukan", 
          pesanGagal,
          backgroundColor: AppTheme.errorColor.withOpacity(0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Jaga-jaga tutup loading jika error client-side
      print("Error saat kirim berkas: $e");
      Get.snackbar(
        "Gangguan Sistem", 
        "Terjadi kesalahan koneksi lokal aplikasi Anda.",
        backgroundColor: AppTheme.errorColor.withOpacity(0.9),
        colorText: Colors.white,
      );
    } finally {
      isSubmitting(false);
    }
  }
}