import 'dart:async';
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

  void _loadData() {
    // Menerima data dari halaman sebelumnya (TaliTemaliView)
    // Jika tidak ada data yang dikirim, gunakan data dummy (fallback)
    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      title.value = args['title'] ?? 'Nama Simpul';
      level.value = args['level'] ?? 'Dasar';
      description.value = args['desc'] ?? 'Deskripsi simpul.';
      
      // Misalkan data steps dikirim lewat arguments
      if (args['steps'] != null) {
        steps.value = List<Map<String, String>>.from(args['steps']);
      } else {
        _generateDummySteps(title.value);
      }
    } else {
      title.value = "Simpul Mati";
      level.value = "Dasar";
      description.value = "Berguna untuk menyambung dua utas tali yang sama besarnya dan dalam keadaan kering.";
      _generateDummySteps("Simpul Mati");
    }
  }

  void _generateDummySteps(String knotName) {
    // Dummy langkah-langkah jika data spesifik belum ditambahkan di database
    steps.value = [
      {
        "image": "https://images.unsplash.com/photo-1520699697851-3dc68aa3a474?auto=format&fit=crop&q=80&w=800",
        "instruction": "Langkah 1: Siapkan dua ujung tali yang ingin disambung. Pegang ujung kiri di tangan kiri dan ujung kanan di tangan kanan."
      },
      {
        "image": "https://images.unsplash.com/photo-1544551763-46a013bb70d5?auto=format&fit=crop&q=80&w=800",
        "instruction": "Langkah 2: Silangkan ujung tali kanan di atas ujung tali kiri, lalu putar ke bawahnya hingga mengikat satu putaran dasar."
      },
      {
        "image": "https://images.unsplash.com/photo-1516981879613-9f5da904015f?auto=format&fit=crop&q=80&w=800",
        "instruction": "Langkah 3: Sekarang ambil ujung tali yang baru, silangkan kembali. Pastikan alurnya sejajar dengan ikatan di bawahnya."
      },
      {
        "image": "https://images.unsplash.com/photo-1504194921103-f8b80cadd5e4?auto=format&fit=crop&q=80&w=800",
        "instruction": "Langkah 4: Tarik kedua ujung tali secara bersamaan dengan kuat. Pastikan bentuknya simetris agar simpul terkunci dengan aman."
      },
    ];
  }

  void nextStep() {
    if (currentStepIndex.value < steps.length - 1) {
      currentStepIndex.value++;
    } else {
      // Kembali ke awal jika sudah di akhir (Loop)
      currentStepIndex.value = 0;
    }
  }

  void prevStep() {
    if (currentStepIndex.value > 0) {
      currentStepIndex.value--;
    } else {
      // Ke akhir jika di posisi awal
      currentStepIndex.value = steps.length - 1;
    }
  }

  void goToStep(int index) {
    currentStepIndex.value = index;
    // Jika sedang play, biarkan play. Jika manual, biarkan manual.
  }

  void togglePlay() {
    isPlaying.value = !isPlaying.value;

    if (isPlaying.value) {
      // Memulai auto-slide setiap 2.5 detik
      _autoPlayTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
        nextStep();
      });
    } else {
      // Menghentikan auto-slide
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