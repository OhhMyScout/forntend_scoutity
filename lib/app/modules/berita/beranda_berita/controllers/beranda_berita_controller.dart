import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';

class BerandaBeritaController extends GetxController {

  // Fungsi navigasi ke halaman Tabel Berita Provinsi
  void goToBeritaProvinsi() {
    Get.toNamed(Routes.TABEL_BERITA_PROVINSI);
  }

  // Fungsi navigasi ke halaman Tabel Berita Paling Populer
  void goToBeritaPopuler() {
    Get.toNamed(Routes.TABEL_BERITA_PALING_POPULER);
  }

  void onBack() {
    Get.back();
  }
}