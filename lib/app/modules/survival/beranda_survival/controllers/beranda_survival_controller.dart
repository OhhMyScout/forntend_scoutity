import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BerandaSurvivalController extends GetxController {
  // // Fungsi navigasi kembali
  void goBack() {
    Get.back();
  }

  // // Fungsi navigasi ke detail materi
  void openDetail(String title) {
    debugPrint("Membuka detail materi: $title");
    // Get.toNamed('/detail-materi', arguments: title);
  }

  // // Fungsi membuka fitur Kompas
  void openCompass() {
    debugPrint("Membuka fitur Kompas Digital");
  }

  // // Fungsi panggilan darurat menggunakan url_launcher
  Future<void> makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      debugPrint('Tidak dapat melakukan panggilan ke $phoneNumber');
    }
  }
}