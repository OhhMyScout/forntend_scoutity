import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  // TextEditingControllers untuk mengelola input form
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController unitController;

  // Observable untuk dropdown provinsi
  var selectedProvince = "Jawa Barat".obs;
  final List<String> provinces = [
    "Jawa Barat",
    "Jawa Tengah",
    "Jawa Timur",
    "DKI Jakarta",
    "Bali"
  ];

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi dengan data yang ada (Arjun Wijaya sesuai desain)
    nameController = TextEditingController(text: "Arjun Wijaya");
    emailController = TextEditingController(text: "arjun.wijaya@scoutify.id");
    unitController = TextEditingController(text: "04.125 - Pangeran Diponegoro");
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    unitController.dispose();
    super.onClose();
  }

  // // Action: Ganti Foto Profil
  void pickImage() {
    print("Action: Membuka kamera/galeri untuk ganti foto");
  }

  // // Action: Simpan Perubahan
  void saveProfile() {
    print("Action: Menyimpan data ke server...");
    Get.back(); // Kembali ke halaman sebelumnya setelah simpan
  }

  // // Action: Hapus Akun
  void deleteAccount() {
    print("Action: Menampilkan dialog konfirmasi hapus akun");
  }

  // // Action: Kembali
  void goBack() {
    Get.back();
  }
}