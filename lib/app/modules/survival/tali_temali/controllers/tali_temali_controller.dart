import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TaliTemaliController extends GetxController {
  // Menggunakan RxList agar UI otomatis diperbarui setelah aset selesai dipindai
  final RxList<Map<String, dynamic>> listSimpul = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSimpulFromAssets();
  }

  Future<void> loadSimpulFromAssets() async {
    try {
      // 1. Memuat AssetManifest untuk memindai semua file di bundle aplikasi
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final List<String> allAssets = manifest.listAssets();

      // 2. Menyaring file yang berada di dalam direktori assets/tali/
      final Iterable<String> taliAssets = allAssets.where((path) => path.startsWith('assets/tali/'));

      // 3. Mengelompokkan file berdasarkan nama folder tali (misal: assets/tali/mati/image1.jpg -> 'mati')
      final Map<String, List<String>> folderMap = {};
      for (String path in taliAssets) {
        final parts = path.split('/');
        // Format path standar: assets/tali/<nama_tali>/<nama_file>
        if (parts.length >= 4) {
          final folderName = parts[2];
          folderMap.putIfAbsent(folderName, () => []).add(path);
        }
      }

      final List<Map<String, dynamic>> loadedList = [];

      folderMap.forEach((folderName, images) {
        // 4. Mengurutkan gambar secara natural (agar image1, image2, image10 berurutan dari awal sampai akhir)
        images.sort((a, b) => _naturalCompare(a, b));

        // 5. Mencari gambar sampul yang memiliki angka '1' pada nama filenya (misal: image1.jpg, 1.png)
        String coverImage = images.firstWhere(
          (path) {
            final fileName = path.split('/').last.toLowerCase();
            return RegExp(r'1\.(jpg|jpeg|png)$').hasMatch(fileName) || fileName.contains('1');
          },
          orElse: () => images.isNotEmpty ? images.first : '',
        );

        // 6. Menentukan nama tali berdasarkan nama folder
        String formattedTitle = _capitalize(folderName);

        loadedList.add({
          "title": formattedTitle,
          "folderName": folderName,
          "level": _getLevel(folderName),
          "levelColor": _getLevelColor(folderName),
          "levelTextColor": _getLevelTextColor(folderName),
          "desc": _getDesc(folderName),
          "image": coverImage,       // Gambar sampul dengan angka 1
          "allImages": images,       // Seluruh gambar langkah-langkah (image1 - image12)
        });
      });

      // Memasukkan hasil pemindai ke dalam RxList
      listSimpul.assignAll(loadedList);
    } catch (e) {
      debugPrint("Gagal memuat aset tali: $e");
    }
  }

  // Fungsi pengurutan agar angka dalam teks diurutkan secara numerik (image2 sebelum image10)
  int _naturalCompare(String a, String b) {
    final RegExp regExp = RegExp(r'\d+');
    final matchA = regExp.firstMatch(a);
    final matchB = regExp.firstMatch(b);

    if (matchA != null && matchB != null) {
      final int numA = int.parse(matchA.group(0)!);
      final int numB = int.parse(matchB.group(0)!);
      if (numA != numB) return numA.compareTo(numB);
    }
    return a.compareTo(b);
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Helper metadata tambahan agar desain kartu tetap rapi sesuai estetika Tailwind
  String _getLevel(String folder) {
    if (folder.toLowerCase() == 'anyam') return 'Menengah';
    return 'Dasar';
  }

  Color _getLevelColor(String folder) {
    if (folder.toLowerCase() == 'anyam') return const Color(0xFFFFCA98);
    return const Color(0xFFF0EDE9);
  }

  Color _getLevelTextColor(String folder) {
    if (folder.toLowerCase() == 'anyam') return const Color(0xFF7A532A);
    return const Color(0xFF504442);
  }

  String _getDesc(String folder) {
    switch (folder.toLowerCase()) {
      case 'mati':
        return "Berguna untuk menyambung dua utas tali yang sama besarnya dan dalam keadaan kering.";
      case 'pangkal':
        return "Simpul awal untuk memulai ikatan pada tiang atau kayu.";
      case 'jangkar':
        return "Digunakan untuk membuat tandu darurat atau mengikat ember/tali timba.";
      case 'anyam':
        return "Untuk menyambung dua utas tali yang tidak sama besarnya dan dalam keadaan kering.";
      default:
        return "Panduan langkah demi langkah pembuatan simpul $folder untuk kegiatan kepramukaan.";
    }
  }

  void onBack() {
    Get.back();
  }

  void openDetailSimpul(Map<String, dynamic> knot) {
    Get.toNamed('/detail-tali', arguments: knot);
  }

  void openTipsMerawatTali() {
    Get.snackbar(
      "Segera Hadir",
      "Tips lanjutan sedang dalam pengembangan.",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}