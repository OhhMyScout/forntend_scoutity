import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaliTemaliController extends GetxController {
  // Data daftar simpul yang akan dirender di View
  final List<Map<String, dynamic>> listSimpul = [
    {
      "title": "Simpul Mati",
      "level": "Dasar",
      "levelColor": const Color(0xFFF0EDE9),
      "levelTextColor": const Color(0xFF504442),
      "desc":
          "Berguna untuk menyambung dua utas tali yang sama besarnya dan dalam keadaan kering.",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuArecqG3wrwE6LAtktUDpJ6VKpzpvPwU2v4oxhRM-_M570Cf79EgCSklPnQI14R8ne2urLsP7lvRpgbZdUSU9Gcljg--4eBy0bo762M_nG2cnU3M2VvcMgNh9L5X1t__R1X20-7swLnHgpvsV09agA3YYtIco4dFRL7MQpxIPNz3uBkmof8bxp2fxYZY-7OJHU_e1G--uyi5KAOU2jxzYiIWGXx6sBY8md8IpSUj-iBMTfmZWZkm4Rxm0TZGSm-zKO18i8fnzmouQI",
    },
    {
      "title": "Simpul Pangkal",
      "level": "Dasar",
      "levelColor": const Color(0xFFF0EDE9),
      "levelTextColor": const Color(0xFF504442),
      "desc": "Simpul awal untuk memulai ikatan pada tiang atau kayu.",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCLbkSbbooR2OGwnPXRAHMbuPdunwof2tjQhasgw5gBk0bch2W5w2SsZTJ-IH29EIHMISWNq2RdYHXgT_J5qHY7QeHNwzfDrnTNiMG4oE9b68-iDTSZSVMcreXY9jvNzIvUV9-l-U4gpsjGEQah92DZjaANYBu8q2pR9OyYOhgbBE1wAswWAPp4OEjRXp6a5A59H0VYknkwL1PfxgADaCad8v8Z0OP1SzyUh4LYHj9huReqs52z-7tmm7iuO3Gz4hphW4-pE9DPUCc",
    },
    {
      "title": "Simpul Jangkar",
      "level": "Dasar",
      "levelColor": const Color(0xFFF0EDE9),
      "levelTextColor": const Color(0xFF504442),
      "desc":
          "Digunakan untuk membuat tandu darurat atau mengikat ember/tali timba.",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuDmq4cfWSccqV6ZGPKzojNdcnNfZJ4DXhUF5qugddy-gT69isj5H07yW1JF-1RgKU9EqNhwheaJebWqX1ZjGwZqOkfgpoj45n-RHRe3O1d8sjI71WHMQedeQrsHXWts9qDDLqKw6ePGQLa8FEqJI1mQpvMrZbsyTZ0qMhEUVRH1dsr_TEfEtfyUCDuozRzgJfgcx2YQ4iUHLR5MaCP_ZiHUwq0rLXyfh4RAa2v78Mxc9ozu8ruT5LZ4rZHkxG2Z8xK7yXtxPr_RkcY",
    },
    {
      "title": "Simpul Anyam",
      "level": "Menengah",
      "levelColor": const Color(0xFFFFCA98),
      "levelTextColor": const Color(0xFF7A532A),
      "desc":
          "Untuk menyambung dua utas tali yang tidak sama besarnya dan dalam keadaan kering.",
      "image":
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCLEnHJGx23MyYHIowr_8W4-UFJCTMFDVi91xEByATEBEGJoj2Ishi5BnfCa5ltnC_M_e-YRFV17QI7Paz8TAgELZsK-3oH3O7WfUqnmIuBLlDNtk7wjNshymv7A2OeFYGVkVoeeB_2P6wJvFZ0yNAjb1rlOFCQyQ5tlmICKGM87xow1mcQOsNh92soayDfciK-y3ZHzmMHpZvGtXpdrYiUHwZFTSix4GUusuHdFzpSXIE28OC8eQmSnjE_2fk9hnHHy2ui9yzmZfw",
    },
  ];

  void onBack() {
    Get.back();
  }

  void openDetailSimpul(Map<String, dynamic> knot) {
    Get.toNamed('/detail-tali', arguments: knot);
  }

  void openTipsMerawatTali() {
    // Fungsi untuk tombol Pelajari Lebih Lanjut
    Get.snackbar(
      "Segera Hadir",
      "Tips lanjutan sedang dalam pengembangan.",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
