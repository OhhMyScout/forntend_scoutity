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
  var isLoadingPembina = false.obs;
  var isGudepValid = true.obs;
  
  // Kontrol Input Text
  final namaController = TextEditingController();
  final provinsiController = TextEditingController();
  final buktiUrlController = TextEditingController();

  // Kontrol Dropdown & Pilihan
  var selectedGolongan = "Penggalang".obs;
  var selectedTingkat = "Ramu".obs;
  
  // Tampungan Objek Pembina dinamis dari database (menyimpan ID & Nama)
  var pembinaDinamisList = <dynamic>[].obs;
  var selectedPembinaId = "".obs;

  final List<String> golonganList = ["Siaga", "Penggalang", "Penegak", "Pandega"];
  final List<String> tingkatList = ["Ramu", "Rakit", "Terap"];

  @override
  void onInit() {
    super.onInit();
    _periksaAksesGudepDanSinkronisasi();
  }

  void _periksaAksesGudepDanSinkronisasi() {
    // 1. Validasi Keberadaan Gudep Siswa secara Real-time
    if (SessionManager.gudep.isEmpty || SessionManager.gudep == '-') {
      isGudepValid.value = false;
      
      // Menggunakan Scheduler agar tidak bentrok saat rendering frame pertama
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.back(); // Tutup halaman form pengajuan kembali ke halaman sebelumnya
        
        Get.snackbar(
          "Gugus Depan Kosong",
          "Silakan lengkapi nomor Gudep di Profil Anda terlebih dahulu sebelum mengajukan SKU.",
          backgroundColor: Colors.orange.shade800,
          colorText: Colors.white,
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );
        
        // Arahkan otomatis (Direct) ke halaman Profile
        // Sesuaikan nama rute profile aplikasi Anda (misal: '/profile' atau nama kelas viewnya)
        Get.toNamed('/profile'); 
      });
      return;
    }

    // 2. Jika Gudep Terisi, Lakukan Sinkronisasi Form
    namaController.text = SessionManager.fullname.isNotEmpty 
        ? SessionManager.fullname 
        : SessionManager.username;
        
    provinsiController.text = SessionManager.province.isNotEmpty 
        ? SessionManager.province 
        : "Jawa Tengah";

    // 3. Panggil API pembina berdasarkan gudep siswa
    fetchPembinaByGudep();
  }

  Future<void> fetchPembinaByGudep() async {
    try {
      isLoadingPembina(true);
      // Panggil endpoint get pembina berdasarkan parameter gudep siswa saat ini
      final response = await http.get(
        Uri.parse('${ApiEndpoint.baseUrl}/sku/pembina-gudep/${SessionManager.gudep}'),
        headers: SessionManager.apiHeader,
      );

      if (response.statusCode == 200) {
        final resData = json.decode(response.body);
        if (resData['status'] == 'success') {
          pembinaDinamisList.assignAll(resData['data']);
          
          if (pembinaDinamisList.isNotEmpty) {
            selectedPembinaId.value = pembinaDinamisList[0]['id'].toString();
          }
        }
      }
    } catch (e) {
      print("Error fetching pembina: $e");
    } finally {
      isLoadingPembina(false);
    }
  }

  Future<void> submitPengajuan() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedPembinaId.value.isEmpty) {
      Get.snackbar("Pembina Belum Dipilih", "Gudep Anda belum memiliki Pembina terdaftar.");
      return;
    }
    
    isSubmitting(true);
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: AppTheme.secondary)), 
      barrierDismissible: false
    );

    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoint.baseUrl}/sku/ajukan'),
        headers: {
          ...SessionManager.apiHeader,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "user_id": SessionManager.userId,
          "pembina_id": selectedPembinaId.value,
          "nama": namaController.text.trim(),
          "golongan": selectedGolongan.value,
          "tingkat": selectedTingkat.value,
          "province": provinsiController.text.trim(),
          "gudep": SessionManager.gudep,
          "bukti_url": buktiUrlController.text.trim()
        }),
      );

      Get.back(); // Tutup loading

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Sukses Menyerahkan", 
          "Berkas pengajuan ujian SKU berhasil dikirim ke Pembina Anda.", 
          backgroundColor: Colors.green, 
          colorText: Colors.white,
        );
        
        buktiUrlController.clear();
        
        // Menunggu 2 detik agar user sempat membaca snackbar sukses
        Future.delayed(const Duration(seconds: 2), () {
          // Menutup halaman form pengajuan dan mengarahkan kembali ke Dashboard SKU User.
          // Ini akan memicu controller Dashboard SKU untuk refresh data secara natural.
          Get.offNamedUntil('/beranda-sku-user', (route) => route.isFirst);
        }); 
      } else {
        var error = json.decode(response.body);
        Get.snackbar(
          "Gagal", 
          error['detail']?['message'] ?? "Terjadi penolakan oleh sistem server.", 
          backgroundColor: AppTheme.errorColor, 
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back(); 
      Get.snackbar(
        "Koneksi Bermasalah", 
        "Gagal menghubungi server pusat.", 
        backgroundColor: AppTheme.errorColor, 
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