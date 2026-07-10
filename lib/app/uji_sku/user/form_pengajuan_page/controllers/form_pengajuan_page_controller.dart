import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../modules/data/session_manager.dart';
import '../../../../modules/data/api_endpoint.dart';
import '../../../../modules/theme/theme.dart';

class FormPengajuanController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  var isSubmitting = false.obs;
  
  // Kontrol Input Text
  final namaController = TextEditingController();
  final provinsiController = TextEditingController();
  final buktiUrlController = TextEditingController();

  // Kontrol Dropdown
  var selectedGolongan = "Penggalang".obs;
  var selectedTingkat = "Ramu".obs;
  var selectedPembina = "".obs;

  // Daftar Pilihan Berdasarkan Aturan Kwartir Nasional
  final List<String> golonganList = ["Siaga", "Penggalang", "Penegak", "Pandega"];
  final List<String> tingkatList = ["Ramu", "Rakit", "Terap"];
  final List<String> pembinaList = [
    "Kak Budi Santoso", 
    "Kak Rina Melati", 
    "Kak Anton Wijaya",
    "Kak Mirza Alim"
  ];

  @override
  void onInit() {
    super.onInit();
    _sinkronisasiDataSesi();
  }

  void _sinkronisasiDataSesi() {
    namaController.text = SessionManager.fullname.isNotEmpty 
        ? SessionManager.fullname 
        : SessionManager.username;
        
    // Membaca provinsi dari SessionManager, jika kosong beri fallback administratif default
    provinsiController.text = SessionManager.province.isNotEmpty 
        ? SessionManager.province 
        : "Jawa Tengah";
    
    if (pembinaList.isNotEmpty) {
      selectedPembina.value = pembinaList[0];
    }
  }

  Future<void> submitPengajuan() async {
    if (!formKey.currentState!.validate()) return;
    
    isSubmitting(true);
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
          "nama": namaController.text.trim(),
          "golongan": selectedGolongan.value,
          "tingkat": selectedTingkat.value,
          "provinsi": provinsiController.text.trim(),
          "nama_pembina": selectedPembina.value,
          "bukti_url": buktiUrlController.text.trim()
        }),
      );

      Get.back(); // Tutup loading dialog

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Sukses Menyerahkan", 
          "Berkas pengajuan ujian berhasil dikirim ke Pembina.", 
          backgroundColor: Colors.green, 
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        
        buktiUrlController.clear();
        Future.delayed(const Duration(seconds: 1), () => Get.back()); 
      } else {
        var error = json.decode(response.body);
        Get.snackbar(
          "Gagal", 
          error['detail']?['message'] ?? "Terjadi penolakan oleh sistem server.", 
          backgroundColor: AppTheme.errorColor.withValues(alpha: 0.9), 
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); 
      Get.snackbar(
        "Koneksi Bermasalah", 
        "Gagal menghubungi server pusat, silakan periksa sirkuit internet Anda.", 
        backgroundColor: AppTheme.errorColor.withValues(alpha: 0.9), 
        colorText: Colors.white,
      );
    } finally {
      isSubmitting(false);
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    provinsiController.dispose();
    buktiUrlController.dispose();
    super.onClose();
  }
}