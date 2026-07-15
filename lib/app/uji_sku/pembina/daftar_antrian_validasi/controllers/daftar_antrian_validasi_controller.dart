import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../modules/data/session_manager.dart';
import '../../../../modules/data/api_endpoint.dart';

class DaftarAntrianValidasiController extends GetxController {
  var antrianList = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAntrianPengajuan();
  }

  // Mengambil berkas pending berdasarkan id pembina saat ini
  Future<void> fetchAntrianPengajuan() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(ApiEndpoint.skuAntrianPembina(SessionManager.userId)),
        headers: SessionManager.apiHeader,
      );

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        if (resData['status'] == 'success') {
          antrianList.assignAll(resData['data']);
        }
      } else {
        Get.snackbar("Gagal", "Tidak dapat mengambil berkas antrian.");
      }
    } catch (e) {
      print("Error fetchAntrianPengajuan: $e");
    } finally {
      isLoading(false);
    }
  }

  // Mengirim aksi Setuju / Tolak ke backend
  Future<void> prosesValidasiBerkas(String pengajuanId, String statusAksi, {String? catatan}) async {
    try {
      isLoading(true);
      final response = await http.put(
        Uri.parse(ApiEndpoint.skuProsesValidasi(pengajuanId)),
        headers: {
          ...SessionManager.apiHeader,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "status": statusAksi,
          "catatan_pembina": catatan ?? ""
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Berhasil", 
          statusAksi == "approved" ? "Berkas siswa berhasil diverifikasi!" : "Berkas siswa ditolak.",
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
        fetchAntrianPengajuan(); // Segarkan list data antrian
      } else {
        Get.snackbar("Gagal", "Sistem gagal memperbarui berkas.");
      }
    } catch (e) {
      print("Error prosesValidasiBerkas: $e");
    } finally {
      isLoading(false);
    }
  }
}