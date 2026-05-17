import 'package:get/get.dart';

class PanduanTendaController extends GetxController {
  
  // Data State untuk Langkah-langkah (Bisa interaktif ditekan)
  var activeStep = (-1).obs;

  // Data List Langkah
  final List<Map<String, dynamic>> steps = [
    {
      "title": "Pemilihan Lokasi",
      "desc": "Cari permukaan tanah yang datar dan bebas dari akar pohon atau bebatuan tajam yang bisa merusak dasar tenda.",
      "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuADcowpIWcto26_XofCWw65QlABqxrXEZwJu7Hif5D-WZMqPwfqdNbofqobH2_ICZ_JsaIFm3Sw9j4k894idxgPhTlQOKuSqNkxwzSaU17G-yJNR4RdU5_uaZB8gpdb18h7QWDNdHKrPbBis1m5i2jk4jWOpcFy8V9J-LI9m7sjOdl05rqnXr6mvsDxu8WYy9X07aZfFPKJxZWMm6ZUKWb7SdHbln4NLajWKqtxpQbetZY1UgM4IFCNgdS3uFYI5FueTN6mPp2YEsc"
    },
    {
      "title": "Menghamparkan Tenda",
      "desc": "Buka lipatan tenda dan hamparkan secara merata. Pastikan bagian pintu menghadap ke arah yang diinginkan.",
      "image": null
    },
    {
      "title": "Memasang Rangka",
      "desc": "Sambungkan semua bagian tiang penyangga. Masukkan tiang ke dalam lubang atau pengait tenda secara menyilang.",
      "images": [
        "https://lh3.googleusercontent.com/aida-public/AB6AXuBZfbMjL_Kpqj_BC3KNqNF79t0W8nRTsshZQkp58EgVL3vG1tbiBNMvkGQXeo0qlcLexL82plSAwcfId52Kmyk7Sqp9CZ-IEcKMMcjdg-eMVTgZjPfRSn_PM0S_mDGd2CvFktonIrtB_SUupdE_Wbt-jCW6aInYwRG-8zSKhkIZsb_xQPu2Gf9y6uVnzmGT4bsiCX9Qr_JV0FU_BBlsh_NcO1us3eQqcO9YPf4QbghnWm_LdV5XaIZ0tzC_oU3GdgDd_vEzp-SRPG0",
        "https://lh3.googleusercontent.com/aida-public/AB6AXuDWNOs4_d9aDg6J1-u2pTbPmjVLfgYdTADX9KGcRiN3JH2Ar7eZAz1BePkmM2qBetmS5sXxbCSCqmcwLI_-Qo9-F0mPO-p_yXzc2QalQbpRfU4-KREdQdNROTraquC8gWuXAmTENrRpMfi0aaVhCiEFLczSYAMIqExb5WuuZDajcE_v6YefMRRgXq90tPcRLGBQnsnC-AFjm5WfUQk2KDnrj4CXWfCnr97Gpf-GCDMRIZbjUwD-rtW2Yzt4cMW55rTVIoJbxDcU6Nc"
      ]
    },
    {
      "title": "Menegakkan Tenda",
      "desc": "Lengkungkan tiang penyangga hingga tenda berdiri tegak. Lakukan secara perlahan dan pastikan semua pengait terpasang sempurna.",
      "image": null
    },
    {
      "title": "Pasak & Tali",
      "desc": "Tancapkan pasak pada sudut-sudut tenda dengan sudut 45 derajat. Tarik tali (guyline) agar tenda kencang dan tidak lembap.",
      "image": null
    },
  ];

  void toggleStep(int index) {
    if (activeStep.value == index) {
      activeStep.value = -1; // Deselect jika sudah ditekan
    } else {
      activeStep.value = index;
    }
  }

  void onBack() {
    Get.back();
  }
}