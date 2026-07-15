import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../data/api_endpoint.dart';
import '../../../data/session_manager.dart'; // Pastikan path SessionManager Anda benar

class FormPembinaController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final sekolahController = TextEditingController();
  final noHpController = TextEditingController();
  final gudepPaController = TextEditingController();
  final gudepPiController = TextEditingController();

  // Menyimpan file foto lokal secara reaktif agar UI otomatis ter-update saat dipilih
  Rx<File?> fotoFile = Rx<File?>(null);
  RxBool isTermsAccepted = false.obs;
  RxBool isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    // Otomatis mengisi text controller menggunakan data dari SessionManager
    namaController.text = SessionManager.fullname;
    emailController.text = SessionManager.email;
  }

  // Fungsi mengambil FOTO dari Kamera / Galeri HP
  Future<void> pickFoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75, // Kompresi untuk menghemat kuota upload storage
    );

    if (pickedFile != null) {
      fotoFile.value = File(pickedFile.path);
      Get.snackbar('Foto Dipilih', 'Foto berhasil dimuat.');
    }
  }

  void toggleTerms(bool? value) {
    if (value != null) isTermsAccepted.value = value;
  }

  // Fungsi Submit Form ke Backend FastAPI
  Future<void> submitForm() async {
    if (!formKey.currentState!.validate()) return;

    if (fotoFile.value == null) {
      Get.snackbar(
        'Peringatan',
        'Harap unggah foto dengan pakaian Pramuka lengkap.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    if (!isTermsAccepted.value) {
      Get.snackbar(
        'Peringatan',
        'Anda harus menyetujui syarat dan ketentuan.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      String currentUserId =
          SessionManager.userId; // Mengambil user_id dari session

      // 1. UPLOAD FOTO KE SUPABASE STORAGE
      String fileExt = fotoFile.value!.path.split('.').last;
      String fileName =
          'foto_${currentUserId}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      await supabase.storage
          .from('pembina')
          .upload(
            fileName,
            fotoFile.value!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Dapatkan URL publik file
      final String fotoPublicUrl = supabase.storage
          .from('pembina')
          .getPublicUrl(fileName);

      // 2. SEND DATA KE FASTAPI BACKEND
      final Map<String, dynamic> bodyData = {
        "user_id": currentUserId,
        "sekolah": sekolahController.text,
        "gudep_pa": gudepPaController.text.isNotEmpty
            ? gudepPaController.text
            : null,
        "gudep_pi": gudepPiController.text.isNotEmpty
            ? gudepPiController.text
            : null,
        "foto_pramuka": fotoPublicUrl,
        "dokumen_pendukung": null, // Dokumen pendukung dihapus, dikirim null
      };

      final response = await http.post(
        Uri.parse(ApiEndpoint.daftarPembina),
        headers: SessionManager
            .apiHeader, // Memanfaatkan token auth otomatis dari helper session Anda
        body: jsonEncode(bodyData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          responseData['message'] ?? 'Pengajuan berhasil dikirim.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Future.delayed(const Duration(seconds: 2), () {
          // Kembali ke halaman Settings dengan aman, menghapus halaman form,
          // dan memicu pemanggilan ulang route settings agar controller-nya refresh secara natural.
          Get.offNamedUntil('/settings', (route) => route.isFirst);
        });
      } else {
        String errMsg =
            responseData['detail']?['message'] ?? 'Terjadi kesalahan.';
        Get.snackbar(
          'Gagal',
          errMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    namaController.dispose();
    emailController.dispose();
    sekolahController.dispose();
    noHpController.dispose();
    gudepPaController.dispose();
    gudepPiController.dispose();
    super.onClose();
  }
}
