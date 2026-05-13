import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {

  void contactSupport() {
    Get.snackbar(
      'Dukungan',
      'Menghubungi tim dukungan',
    );
  }

  void openTerms() {
    Get.snackbar(
      'Syarat & Ketentuan',
      'Membuka syarat & ketentuan',
    );
  }

  void openHelpCenter() {
    Get.snackbar(
      'Pusat Bantuan',
      'Membuka pusat bantuan',
    );
  }
}