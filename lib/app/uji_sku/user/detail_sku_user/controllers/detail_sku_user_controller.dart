import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Sesuaikan path jika letak folder data kamu berbeda level
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

  @override
  void onInit() {
    super.onInit();
    // Mengambil argumen dari routing Get.toNamed()
    levelId.value = Get.arguments?['level_id'] ?? "";
    title.value = Get.arguments?['title'] ?? "Buku Saku SKU";
    
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading(true);
    try {
      String userId = SessionManager.userId;
      // Catatan: Jika ada data Agama di profil user, bisa diambil dari SessionManager. 
      // Untuk sementara kita gunakan default "Umum" atau "Islam" (API akan mengembalikan Umum + Agama Terkait)
      String agamaUser = "Islam"; 

      // 1. Ambil Master Data Soal dan Progress secara bersamaan (Concurrent)
      var results = await Future.wait([
        http.get(
          Uri.parse('${ApiEndpoint.skuMaster}/${levelId.value}?agama=$agamaUser'), 
          headers: SessionManager.apiHeader
        ),
        http.get(
          Uri.parse(ApiEndpoint.skuProgress(userId, levelId.value)), 
          headers: SessionManager.apiHeader
        ),
      ]);

      // 2. Mapping Data Soal
      if (results[0].statusCode == 200) {
        var dataMaster = json.decode(results[0].body);
        skuMasterList.value = dataMaster['data'] ?? [];
      }

      // 3. Mapping Progress User
      if (results[1].statusCode == 200) {
        var dataProgress = json.decode(results[1].body);
        userProgressList.value = dataProgress['data'] ?? [];
      }

    } catch (e) {
      Get.snackbar(
        "Koneksi Terputus", 
        "Gagal memuat daftar tugas SKU.",
        backgroundColor: AppTheme.errorColor.withValues(alpha: 0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk mendapatkan status suatu poin SKU
  String getStatusPoin(String skuId) {
    var progress = userProgressList.firstWhere(
      (p) => p['uji_sku_id'] == skuId, 
      orElse: () => null
    );
    if (progress == null) return "Belum Diuji";
    return progress['status'] ?? "Belum Diuji";
  }

  // Fungsi untuk mengirim Pengajuan Ujian ke API
  Future<void> ajukanUjian(String skuId, String buktiUrl) async {
    isSubmitting(true);
    Get.back(); // Tutup dialog input terlebih dahulu

    // Munculkan indikator loading (non-dismissible)
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: AppTheme.secondary)), 
      barrierDismissible: false
    );

    try {
      final response = await http.post(
        Uri.parse(ApiEndpoint.skuAjukan),
        headers: SessionManager.apiHeader,
        body: json.encode({
          "user_id": SessionManager.userId,
          "uji_sku_id": skuId,
          "bukti_url": buktiUrl.isNotEmpty ? buktiUrl : null
        }),
      );

      Get.back(); // Tutup indikator loading

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Berhasil!", 
          "Laporanmu sudah diserahkan ke Kakak Pembina.",
          backgroundColor: Colors.green.withValues(alpha: 0.9),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        // Refresh data agar statusnya berubah menjadi "Menunggu Validasi"
        fetchData(); 
      } else {
        var error = json.decode(response.body);
        Get.snackbar(
          "Gagal Mengajukan", 
          error['detail']['message'] ?? "Terjadi kesalahan sistem.",
          backgroundColor: AppTheme.errorColor.withValues(alpha: 0.9),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); // Tutup indikator loading
      Get.snackbar(
        "Error", 
        "Cek kembali koneksi internetmu.",
        backgroundColor: AppTheme.errorColor.withValues(alpha: 0.9),
        colorText: Colors.white,
      );
    } finally {
      isSubmitting(false);
    }
  }
}