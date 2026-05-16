// lib/app/modules/beranda_game/controllers/beranda_game_controller.dart

import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

class BerandaGameController extends GetxController {
  final selectedIndex = 2.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void openNotification() {
    Get.toNamed(Routes.SETTINGS);
  }

  void openSemaphoreDetection() {
    Get.toNamed(Routes.SEMAPHORE_DETECT);
  }

  void openLeaderboard() {
    Get.toNamed(Routes.LEADERBOARD);
  }

  void openGame(Map<String, dynamic> game) {
    final title = game["title"];

    switch (title) {
      case "Sandi Kotak I":
        Get.toNamed(Routes.KOTAK1_CHALLENGE);
        break;

      case "Sandi Kotak II":
        Get.toNamed(Routes.KOTAK2_CHALLENGE);
        break;

      case "Sandi Morse":
        Get.toNamed(Routes.MORSE_CHALLENGE);
        break;

      default:
        Get.snackbar(
          "Info",
          "Game belum tersedia",
        );
    }
  }

  final games = [
    {
      "title": "Sandi Kotak I",
      "description":
          "Menebak kata sandi kotak 1 dan dapatkan 10 point.",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuBoh2GjoKrwLHgyb6Fbm8791EtaF1TVwGOVAJ7SYCfdy10BhSpBTjvlWCXdpt3Xpnfobf9T_mhSzM-eOpMBm0kaOCZ1_VjrHKwmksoifA0uxMh-Uqi1DQvjoBKK0ovtPX_7NyxyArpoPGzQ3lisoGB5U7O-HshsazO6D-SihMTNjpUFXAN4XnCllaHU4_k_m8XlqPSeGblrgpb5B4F5Cts22EjAwGTXRsUqoTIXpZk5SA5c4jrULJRoAk51UK5ySOg9o8ynNUerTR4",
      "button": "Main Sekarang",
      "primary": true,
    },
    {
      "title": "Sandi Kotak II",
      "description":
          "Menebak kata sandi kotak 2 dan dapatkan 10 point.",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuANTN6R1NarJCMOMoy83mt8eUygvuWOMRXbOJW-hRqouxkczMRVUxjMz78olzG8yHYM9_Gb2lZT_1euO3Q5GLIhdLVcnRmMitWE5nTYMy-AZG4lVEJRadj_HM3akCDNoT6epY1pakHF4BYSVq1tG328rAPcIotmqQT-loOmcACltxNX64yiNnuiPeXsjlrc95WpiZVYNDTNZ_y-3gI2pxEXvDbA-fhxlV5Ssg5c_91obfkrv3oekHvljM3inIEtBfnWvZ2iprOMb3w",
      "button": "Lanjut Main",
      "primary": false,
    },
    {
      "title": "Sandi Morse",
      "description":
          "Menebak kata dan dapatkan 10 point.",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDt1bzK5oqvadOw2FbxWyeD2iHBW_xbaAV5IaHRN1GrEx00S87biriQbAHvcL508Q3-Gg9xV-MxZOrykWj3dsd6IxPGtyhhoSSmk-aSKHqT0M4707ALuGM3SR3jfWnnxq1TIMowdIZlQhIFZqULoTxsCAmIeACEkGTO0zK57HWKfuLOvQ4CejXWA8EbIGZxVl1hJpx83kN434b1h6oBKooWuSsgCwqZDWf2El7TQJpQu9HfLj5i3sSCA9j1tWVt4PLFvFGJ0yyq2HE",
      "button": "Mulai Baru",
      "primary": true,
    },
  ];
}