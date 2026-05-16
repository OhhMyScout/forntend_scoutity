

import 'package:get/get.dart';

class BerandaSurvivalController extends GetxController {
  final survivalMenus = [
    {
      "title": "Bertahan Hidup",
      "icon": "terrain",
    },
    {
      "title": "Panduan Tenda",
      "icon": "cabin",
    },
    {
      "title": "Tali Temali",
      "icon": "join_inner",
    },
    {
      "title": "SOS & Isyarat",
      "icon": "settings_input_antenna",
    },
  ];

  final p3kMenus = [
    {
      "title": "Luka",
      "icon": "healing",
    },
    {
      "title": "Patah",
      "icon": "personal_injury",
    },
    {
      "title": "Gigitan",
      "icon": "pest_control_rodent",
    },
    {
      "title": "PATUT",
      "icon": "medical_information",
    },
  ];

  void onBack() {
    Get.back();
  }

  void openCompass() {
    Get.snackbar(
      "Kompas Digital",
      "Membuka kompas digital",
    );
  }

  void openMenu(String title) {
    Get.snackbar(
      title,
      "Membuka menu $title",
    );
  }

  void callEmergency(String number) {
    Get.snackbar(
      "Panggilan Darurat",
      "Menghubungi $number",
    );
  }

  void onBottomNav(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed('/home');
        break;
      case 1:
        Get.offAllNamed('/education');
        break;
      case 2:
        Get.offAllNamed('/games');
        break;
      case 3:
        break;
      case 4:
        Get.offAllNamed('/profile');
        break;
    }
  }
}