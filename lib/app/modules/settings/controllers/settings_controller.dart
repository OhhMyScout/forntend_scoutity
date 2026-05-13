import 'package:get/get.dart';

class SettingsController extends GetxController {
  RxBool isDarkMode = true.obs;
  RxBool isNotificationActive = false.obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
  }

  void toggleNotification(bool value) {
    isNotificationActive.value = value;
  }

  void changeProfile() {
    Get.snackbar(
      'Profil',
      'Fitur ubah profil diklik',
    );
  }

  void openPrivacyPolicy() {
    Get.snackbar(
      'Kebijakan',
      'Membuka Kebijakan & Privasi',
    );
  }

  void sendFeedback() {
    Get.snackbar(
      'Feedback',
      'Membuka halaman feedback',
    );
  }
}