import 'package:get/get.dart';

class P3KChecklistController extends GetxController {
  // List data item P3K reaktif menggunakan .obs
  var checklistItems = <Map<String, dynamic>>[
    // Peralatan Pembersih & Antiseptik
    {"title": "Kasa Steril", "desc": "Menutup luka terbuka agar terhindar dari kotoran.", "category": "Pembalut", "isCheck": false},
    {"title": "Perban Gulung", "desc": "Membalut kasa dan menahan tekanan luka luar.", "category": "Pembalut", "isCheck": false},
    {"title": "Plester Luka", "desc": "Menutup luka sayat ringan berukuran kecil.", "category": "Pembalut", "isCheck": false},
    {"title": "Cairan Antiseptik", "desc": "Membunuh kuman di sekitar area kulit luka.", "category": "Cairan", "isCheck": false},
    {"title": "Alkohol Swab 70%", "desc": "Sterilisasi alat medis sebelum tindakan luar.", "category": "Cairan", "isCheck": false},
    
    // Alat Medis Penunjang
    {"title": "Gunting Medis", "desc": "Memotong perban, kasa, atau pakaian darurat.", "category": "Peralatan", "isCheck": false},
    {"title": "Pinset Alat", "desc": "Mengambil serpihan duri/batu kecil pada luka.", "category": "Peralatan", "isCheck": false},
    {"title": "Sarung Tangan Lateks", "desc": "Menjaga sterilisasi penolong dari infeksi darah.", "category": "Peralatan", "isCheck": false},
    {"title": "Termometer Badan", "desc": "Mengukur suhu tubuh berkala dalam pemantauan.", "category": "Peralatan", "isCheck": false},
    
    // Obat-obatan Darurat
    {"title": "Obat Pereda Nyeri", "desc": "Parasetamol/Ibuprofen untuk pusing & demam.", "category": "Obat", "isCheck": false},
    {"title": "Oralit Shaset", "desc": "Mencegah dehidrasi parah saat diare/kelelahan.", "category": "Obat", "isCheck": false},
    {"title": "Salep Luka Bakar", "desc": "Menenangkan jaringan kulit luka bakar ringan.", "category": "Obat", "isCheck": false},
  ].obs;

  // Menghitung jumlah item yang sudah diceklis
  int get checkedCount => checklistItems.where((item) => item['isCheck'] == true).length;

  // Menghitung persentase progres kesiapan tas P3K
  double get progressPercentage {
    if (checklistItems.isEmpty) return 0.0;
    return checkedCount / checklistItems.length;
  }

  // Mengubah status ceklist item secara reaktif
  void toggleItem(int index) {
    final item = checklistItems[index];
    final current = (item['isCheck'] as bool?) ?? false;
    item['isCheck'] = !current;
    checklistItems[index] = item; // Trigger update RxList
  }

  // Mengembalikan semua ceklist ke kondisi awal (kosong)
  void resetChecklist() {
    for (int i = 0; i < checklistItems.length; i++) {
      var item = checklistItems[i];
      item['isCheck'] = false;
      checklistItems[i] = item;
    }
  }

  void onBack() {
    Get.back();
  }
}