import 'package:get/get.dart';
import '../../../../modules/data/session_manager.dart';

class BerandaSkuPembinaController extends GetxController {
  // Data Profil Pembina
  var pembinaName = "".obs;
  var pembinaImage = "".obs;
  var gugusDepanInfo = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadPembinaData();
  }

  void _loadPembinaData() {
    // Memuat nama pembina, jika fullname kosong gunakan username
    pembinaName.value = SessionManager.fullname.isNotEmpty 
        ? SessionManager.fullname 
        : SessionManager.username;
        
    pembinaImage.value = SessionManager.image;
    
    // Informasi Gudep Pembina (bisa disesuaikan dengan field session Anda)
    gugusDepanInfo.value = "Gudep Aktif"; 
  }

  // Navigasi ke Halaman Verifikasi Pengajuan SKU Berkas Masuk
  void goToPengajuanSku() {
    Get.toNamed('/daftar-antrian-validasi'); // Pastikan daftarkan route ini!
  }

  // Navigasi ke Halaman Penilaian / Uji Poin SKU Siswa
  void goToPenilaianSku() {
    Get.toNamed('/penilaian-sku'); // Pastikan daftarkan route ini!
  }
}