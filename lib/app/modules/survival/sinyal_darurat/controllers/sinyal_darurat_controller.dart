import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:torch_light/torch_light.dart';
import 'package:audioplayers/audioplayers.dart'; // Tambahkan import audioplayers

class SinyalDaruratController extends GetxController {
  // Observables State
  var isFlashlightSosActive = false.obs;
  var isAudioSosActive = false.obs;
  var activeAccordionIndex = (-1).obs;

  Timer? _flashlightTimer;
  
  // Inisialisasi AudioPlayer untuk sirine
  final AudioPlayer audioPlayer = AudioPlayer(); 

  // Pola Durasi Morse SOS (... --- ...) dalam milidetik
  // Dot (.) = 200ms, Dash (-) = 600ms, Jeda antar simbol = 200ms, Jeda antar huruf = 600ms
  final List<int> sosPattern = [
    200, 200, 200, 200, 200, 600, // S (...)
    600, 200, 600, 200, 600, 600, // O (---)
    200, 200, 200, 200, 200, 1500 // S (...) + Jeda antar kata ulang
  ];

  // Data Penjelasan Sinyal Darurat
  final List<Map<String, dynamic>> signalGuides = [
    {
      "title": "Apa itu Kode SOS?",
      "subtitle": "Standar internasional tanda bahaya",
      "desc": "SOS adalah singkatan internasional dari tanda bahaya maritim (distress signal). Dalam kode morse, SOS direpresentasikan sebagai tiga titik, tiga garis, dan tiga titik (... --- ...). Tanda ini dirancang agar mudah dikirim dan dikenali tanpa salah tafsir bahkan dalam kondisi cuaca buruk sekalipun."
    },
    {
      "title": "Sinyal Peluit Darurat",
      "subtitle": "Metode komunikasi suara jarak jauh",
      "desc": "Jika kamu tersesat atau membutuhkan bantuan, tiup peluit dengan pola 3 kali tiupan pendek, jeda 1 detik, 3 kali tiupan panjang, jeda 1 detik, lalu 3 kali tiupan pendek kembali. Di alam bebas, pola bunyi yang diulang sebanyak 3 kali secara konsisten adalah tanda universal darurat."
    },
    {
      "title": "Sinyal Asap & Api Unggun",
      "subtitle": "Tanda visual siang dan malam hari",
      "desc": "Pada siang hari, buatlah asap tebal dengan membakar daun atau ranting basah di atas api unggun. Pada malam hari, nyalakan 3 titik api unggun yang membentuk garis lurus atau segitiga sama sisi dengan jarak masing-masing sekitar 25 meter. Angka 3 melambangkan permintaan pertolongan."
    },
    {
      "title": "Tanda Visual Tanah (Ground Signals)",
      "subtitle": "Tanda untuk helikopter atau tim penyelamat",
      "desc": "Buatlah simbol huruf 'X' besar di area terbuka menggunakan tumpukan batu, kayu, atau pakaian berwarna cerah. Simbol 'X' mengindikasikan ketidakmampuan untuk bergerak dan sangat membutuhkan pertolongan medis atau evakuasi udara."
    }
  ];

  void toggleAccordion(int index) {
    if (activeAccordionIndex.value == index) {
      activeAccordionIndex.value = -1;
    } else {
      activeAccordionIndex.value = index;
    }
  }

  // =========================================================
  // LOGIKA SENTER SOS (... --- ...)
  // =========================================================
  void toggleFlashlightSos() async {
    bool isTorchAvailable = await TorchLight.isTorchAvailable();
    if (!isTorchAvailable) {
      Get.snackbar(
        "Fitur Tidak Didukung",
        "Perangkat kamu tidak memiliki hardware senter/flash.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    if (isFlashlightSosActive.value) {
      _stopFlashlightSos();
    } else {
      _startFlashlightSos();
    }
  }

  void _startFlashlightSos() {
    isFlashlightSosActive.value = true;
    int patternIndex = 0;

    void executePattern() async {
      if (!isFlashlightSosActive.value) return;

      bool shouldTurnOn = patternIndex % 2 == 0;
      try {
        if (shouldTurnOn) {
          await TorchLight.enableTorch();
        } else {
          await TorchLight.disableTorch();
        }
      } catch (e) {
        debugPrint("Senter Error: $e");
      }

      int duration = sosPattern[patternIndex];
      patternIndex = (patternIndex + 1) % sosPattern.length;

      _flashlightTimer = Timer(Duration(milliseconds: duration), executePattern);
    }

    executePattern();
  }

  void _stopFlashlightSos() async {
    isFlashlightSosActive.value = false;
    _flashlightTimer?.cancel();
    try {
      await TorchLight.disableTorch();
    } catch (_) {}
  }

  // =========================================================
  // LOGIKA SUARA ALARM SOS MP3
  // =========================================================
  void toggleAudioSos() async {
    isAudioSosActive.value = !isAudioSosActive.value;

    if (isAudioSosActive.value) {
      // Memicu getaran (haptic) saat tombol ditekan agar terasa lebih interaktif
      HapticFeedback.heavyImpact(); 
      
      // Atur audio untuk berulang terus (loop) dan putar filenya
      await audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer.play(AssetSource('sounds/morse_beep.mp3'));
    } else {
      // Hentikan pemutaran audio
      await audioPlayer.stop();
    }
  }

  // Fungsi untuk mematikan semua sinyal saat tombol back di-klik
  void onBack() {
    _stopFlashlightSos();
    audioPlayer.stop(); // Pastikan audio mati
    Get.back();
  }

  // Membersihkan memory saat controller dihancurkan (keluar halaman)
  @override
  void onClose() {
    _stopFlashlightSos();
    audioPlayer.stop();
    audioPlayer.dispose(); // Bebaskan resource audio
    super.onClose();
  }
}