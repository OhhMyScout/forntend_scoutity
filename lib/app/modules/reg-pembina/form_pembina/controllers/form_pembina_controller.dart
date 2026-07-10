import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormPembinaController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final sekolahController = TextEditingController();
  final noHpController = TextEditingController();
  final gudepPaController = TextEditingController();
  final gudepPiController = TextEditingController();

  // State untuk file dan persetujuan
  RxString fotoPath = ''.obs;
  RxString dokumenPath = ''.obs;
  RxBool isTermsAccepted = false.obs;

  void pickFoto() {
    // Simulasi ambil foto (Gunakan package image_picker di implementasi asli)
    fotoPath.value = 'foto_profil_pramuka.jpg';
    Get.snackbar('Foto Dipilih', 'Pastikan background sesuai dengan asal sekolah.');
  }

  void pickDokumen() {
    // Simulasi ambil dokumen (Gunakan package file_picker di implementasi asli)
    dokumenPath.value = 'berkas_pendukung.pdf';
    Get.snackbar('Dokumen Dipilih', 'Dokumen pendukung berhasil dilampirkan.');
  }

  void toggleTerms(bool? value) {
    if (value != null) isTermsAccepted.value = value;
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {
      if (fotoPath.value.isEmpty) {
        Get.snackbar('Peringatan', 'Harap unggah foto dengan pakaian Pramuka lengkap.', backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }
      if (!isTermsAccepted.value) {
        Get.snackbar('Peringatan', 'Anda harus menyetujui syarat dan ketentuan.', backgroundColor: Colors.orange, colorText: Colors.white);
        return;
      }

      // Proses data form di sini
      Get.snackbar(
        'Berhasil',
        'Pendaftaran Pembina Scoutify atas nama ${namaController.text} sedang diproses!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
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