import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DetailTaliController extends GetxController {
  // Data State
  var title = ''.obs;
  var level = ''.obs;
  var description = ''.obs;
  var steps = <Map<String, String>>[].obs;

  // Interaksi State
  var currentStepIndex = 0.obs;
  var isPlaying = false.obs;

  Timer? _autoPlayTimer;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      title.value = args['title'] ?? 'Nama Simpul';
      level.value = args['level'] ?? 'Dasar';
      description.value = args['desc'] ?? 'Panduan langkah demi langkah pembuatan simpul.';

      List<String> images = [];

      // 1. Ambil daftar gambar dari arguments jika sudah dipindai di halaman sebelumnya
      if (args['allImages'] != null && (args['allImages'] as List).isNotEmpty) {
        images = List<String>.from(args['allImages']);
      } 
      // 2. Jika tidak ada, pindai langsung berdasarkan nama folder (misal: alpinebutterflyR, cowR, dll)
      else if (args['folderName'] != null) {
        images = await _fetchImagesFromManifest(args['folderName']);
      }

      if (images.isNotEmpty) {
        // Urutkan gambar dari angka 1 sampai akhir secara natural (1, 2, ... 10, 11)
        images.sort((a, b) => _naturalCompare(a, b));
        _generateStepsFromImages(images, title.value);
      } else {
        _generateFallbackSteps(title.value);
      }
    } else {
      // Fallback default jika halaman dibuka tanpa arguments
      title.value = "Alpine Butterfly";
      level.value = "Menengah";
      description.value = "Simpul yang membentuk loop tetap di tengah tali, sangat kuat untuk beban dua arah.";
      
      final defaultImages = await _fetchImagesFromManifest('alpinebutterflyR');
      if (defaultImages.isNotEmpty) {
        defaultImages.sort((a, b) => _naturalCompare(a, b));
        _generateStepsFromImages(defaultImages, title.value);
      } else {
        _generateFallbackSteps(title.value);
      }
    }
  }

  // Fungsi pengurutan natural agar angka dalam string diurutkan secara numerik
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

  // Memindai folder aset tertentu jika data allImages belum ada
  Future<List<String>> _fetchImagesFromManifest(String folderName) async {
    try {
      final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      return manifest
          .listAssets()
          .where((path) => path.toLowerCase().contains('assets/tali/${folderName.toLowerCase()}'))
          .toList();
    } catch (e) {
      debugPrint("Gagal memuat manifest di detail: $e");
      return [];
    }
  }

  // Mengubah daftar jalur file gambar menjadi daftar langkah (steps)
  void _generateStepsFromImages(List<String> images, String knotName) {
    final List<Map<String, String>> loadedSteps = [];
    for (int i = 0; i < images.length; i++) {
      int stepNum = i + 1;
      loadedSteps.add({
        "image": images[i],
        "instruction": _getInstructionForStep(knotName, stepNum, images.length),
      });
    }
    steps.assignAll(loadedSteps);
  }

  // Menghasilkan teks instruksi otomatis sesuai urutan langkah
  String _getInstructionForStep(String knotName, int step, int totalSteps) {
    if (step == 1) {
      return "Langkah 1: Siapkan tali dan posisikan alur bentukan awal sesuai gambar untuk memulai pembuatan $knotName.";
    } else if (step == totalSteps) {
      return "Langkah $step: Tarik semua ujung tali secara perlahan dan simetris hingga simpul $knotName terkunci dengan rapi dan kuat.";
    } else {
      return "Langkah $step: Ikuti alur lipatan atau silangan tali seperti yang ditunjukkan pada gambar ke-$step. Pastikan posisi tali atas dan bawah tidak terbalik.";
    }
  }

  void _generateFallbackSteps(String knotName) {
    steps.value = [
      {
        "image": "assets/tali/alpinebutterflyR/1.png", // Contoh fallback aset lokal
        "instruction": "Langkah 1: Siapkan tali untuk membuat $knotName."
      }
    ];
  }

  void nextStep() {
    if (currentStepIndex.value < steps.length - 1) {
      currentStepIndex.value++;
    } else {
      currentStepIndex.value = 0; // Loop kembali ke awal
    }
  }

  void prevStep() {
    if (currentStepIndex.value > 0) {
      currentStepIndex.value--;
    } else {
      currentStepIndex.value = steps.length - 1; // Ke akhir jika di awal
    }
  }

  void goToStep(int index) {
    currentStepIndex.value = index;
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;

    if (isPlaying.value) {
      _autoPlayTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
        nextStep();
      });
    } else {
      _autoPlayTimer?.cancel();
    }
  }

  void onBack() {
    Get.back();
  }

  @override
  void onClose() {
    _autoPlayTimer?.cancel();
    super.onClose();
  }
}