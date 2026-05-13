import 'package:get/get.dart';
import 'package:scoutify/app/routes/app_pages.dart';

class BerandaEdukasiController extends GetxController {
  // Data untuk Bento Grid Materi
  final List<Map<String, dynamic>> materiKepramukaan = [
    {
      "title": "Sandi Morse",
      "desc": "Seni berkomunikasi menggunakan titik dan garis.",
      "icon": "radio",
      "color": 0xFF4E342E,
      "route": Routes.DETAIL_MORSE,
    },
    {
      "title": "Semaphore",
      "desc": "Teknik pengiriman sandi jarak jauh dengan bendera.",
      "icon": "flag",
      "color": 0xFFFFCA98,
    },
    {
      "title": "Tali Temali",
      "desc": "Keterampilan dasar menyambung tali dan ikatan.",
      "icon": "straighten",
      "color": 0xFFEBE8E3,
    },
  ];

  void goToDetail(String? routePath) {
    if (routePath != null && routePath.isNotEmpty) {
      print("Navigasi ke: $routePath");
      Get.toNamed(routePath);
    } else {
      Get.snackbar("Info", "Halaman materi belum tersedia bray!");
    }
  }
}
