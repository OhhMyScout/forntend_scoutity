import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart'; // Tambahan untuk izin runtime

class SemaphoreDetectController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  var isCameraInitialized = false.obs;
  var isAnalyzing = false.obs;
  
  var detectedLetter = '-'.obs;
  var accuracy = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      // 1. MINTA IZIN KAMERA KE PENGGUNA (MUNCUL POP-UP)
      var status = await Permission.camera.request();
      if (!status.isGranted) {
        Get.snackbar(
          "Izin Ditolak", 
          "Aplikasi membutuhkan izin kamera untuk mendeteksi Semaphore.",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          duration: const Duration(seconds: 4),
        );
        return; // Hentikan proses jika izin ditolak
      }

      // 2. JIKA DIIZINKAN, NYALAKAN KAMERA
      cameras = await availableCameras();
      
      if (cameras != null && cameras!.isNotEmpty) {
        cameraController = CameraController(
          cameras![0], // Pilih kamera utama
          ResolutionPreset.high,
          enableAudio: false,
        );

        await cameraController!.initialize();
        isCameraInitialized.value = true;
      }
    } catch (e) {
      debugPrint("Error initializing camera: $e");
      Get.snackbar(
        "Error Kamera", 
        "Terjadi kesalahan pada sistem kamera perangkatmu.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    }
  }

  Future<void> captureImage() async {
    if (!isCameraInitialized.value || cameraController == null) return;
    if (isAnalyzing.value) return;

    try {
      HapticFeedback.mediumImpact(); 
      isAnalyzing.value = true;

      // Simulasi AI Loading 2 detik
      await Future.delayed(const Duration(seconds: 2));

      // Simulasi Hasil AI
      detectedLetter.value = 'A'; 
      accuracy.value = 85;        

    } catch (e) {
      debugPrint("Error capturing image: $e");
    } finally {
      isAnalyzing.value = false;
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}