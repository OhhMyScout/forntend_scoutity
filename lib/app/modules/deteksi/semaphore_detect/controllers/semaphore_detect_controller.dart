import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../../data/api_endpoint.dart';

class SemaphoreDetectController extends GetxController {
  final isFlashOn = false.obs;
  bool _isFrontCamera = false;
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  final isCameraInitialized = false.obs;
  final isAnalyzing = false.obs;

  final detectedLetter = "-".obs;
  final confidence = 0.0.obs;

  final errorMessage = "".obs;

  // Tema Warna sesuai UI sebelumnya
  final Color backgroundColor = const Color(0xFFFCF9F4);
  final Color primaryColor = const Color(0xFF361F1A);
  final Color secondaryColor = const Color(0xFF7D562D);

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  /// =========================================
  /// CUSTOM CUTE POP-UP
  /// =========================================
  void _showCutePopup({
    required String title,
    required String message,
    required IconData icon,
    Color iconColor = Colors.orange,
  }) {
    // Mencegah pop-up ganda jika sudah ada pop-up yang terbuka
    if (Get.isDialogOpen ?? false) return; 

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent, // Transparan agar bisa di-custom shape-nya
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ikon Lucu / Menarik
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 56,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 20),
              
              // Judul
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              
              // Pesan
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 15,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              
              // Tombol Tutup
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                    "Mengerti",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // Wajib klik tombol untuk tutup
    );
  }

  Future<void> initCamera() async {
    try {
      final permission = await Permission.camera.request();

      if (!permission.isGranted) {
        _showCutePopup(
          title: "Yahh, Izin Ditolak",
          message: "Aplikasi membutuhkan akses kamera agar bisa mendeteksi semaphore. Yuk, izinkan di pengaturan!",
          icon: Icons.camera_alt_outlined,
          iconColor: Colors.orange,
        );
        return;
      }

      cameras = await availableCameras();

      if (cameras == null || cameras!.isEmpty) {
        _showCutePopup(
          title: "Kamera Tidak Ketemu",
          message: "Aduh, sepertinya hp kamu tidak terdeteksi memiliki kamera aktif.",
          icon: Icons.videocam_off_outlined,
          iconColor: Colors.redAccent,
        );
        return;
      }

      // Pilih kamera belakang jika ada (default)
      CameraDescription selectedCamera = cameras!.first;

      final backCamera = cameras!.where(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      if (backCamera.isNotEmpty) {
        selectedCamera = backCamera.first;
      }

      cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();

      isCameraInitialized.value = true;
      debugPrint("Camera initialized");

    } catch (e) {
      debugPrint("CAMERA ERROR : $e");
      _showCutePopup(
        title: "Kamera Bermasalah",
        message: "Gagal mengakses kamera. Coba tutup dan buka lagi aplikasinya ya.",
        icon: Icons.error_outline_rounded,
        iconColor: Colors.redAccent,
      );
    }
  }

  Future<void> flipCamera() async {
    if (cameras == null || cameras!.isEmpty) return;
    if (cameraController == null) return;
    if (isAnalyzing.value) return;

    final frontCameras = cameras!
        .where((c) => c.lensDirection == CameraLensDirection.front)
        .toList();
    final backCameras = cameras!
        .where((c) => c.lensDirection == CameraLensDirection.back)
        .toList();

    if (frontCameras.isEmpty && backCameras.isEmpty) return;

    isFlashOn.value = false;
    try {
      await cameraController?.setFlashMode(FlashMode.off);
    } catch (_) {}

    final CameraDescription nextCamera;
    if (_isFrontCamera && backCameras.isNotEmpty) {
      nextCamera = backCameras.first;
    } else if (!_isFrontCamera && frontCameras.isNotEmpty) {
      nextCamera = frontCameras.first;
    } else {
      return;
    }

    _isFrontCamera = nextCamera.lensDirection == CameraLensDirection.front;

    try {
      isCameraInitialized.value = false;
      await cameraController?.dispose();
      cameraController = null;

      cameraController = CameraController(
        nextCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
    } catch (e) {
      debugPrint("FLIP CAMERA ERROR : $e");
      errorMessage.value = "Gagal memutar kamera";
    }
  }

  Future<void> toggleFlash() async {
    if (cameraController == null) return;
    if (!cameraController!.value.isInitialized) return;

    final next = !isFlashOn.value;
    try {
      await cameraController!.setFlashMode(next ? FlashMode.torch : FlashMode.off);
      isFlashOn.value = next;
    } catch (_) {
      // Abaikan jika hp tidak punya flash
    }
  }

  Future<void> detectSemaphore() async {
    try {
      if (cameraController == null) return;
      if (!cameraController!.value.isInitialized) return;
      if (isAnalyzing.value) return;

      HapticFeedback.mediumImpact();

      isAnalyzing.value = true;
      errorMessage.value = "";

      final XFile image = await cameraController!.takePicture();

      final request = http.MultipartRequest(
        "POST",
        Uri.parse(ApiEndpoint.semaphoreDetect),
      );

      request.files.add(
        await http.MultipartFile.fromPath("file", image.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("STATUS CODE : ${response.statusCode}");
      debugPrint("BODY : ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (result["success"] == true) {
          detectedLetter.value = result["result"]["label"] ?? "-";
          confidence.value = ((result["result"]["confidence"] ?? 0).toDouble()) * 100;
        } else {
          detectedLetter.value = "-";
          confidence.value = 0;
          // errorMessage.value = result["message"] ?? "Pose tidak terdeteksi";

          _showCutePopup(
            title: "Belum Pas Nih!",
            message: "Sepertinya kamu belum masuk kamera.",
            icon: Icons.sentiment_dissatisfied_rounded,
            iconColor: Colors.orange,
          );
        }
      } else {
        detectedLetter.value = "-";
        confidence.value = 0;

        _showCutePopup(
          title: "Oops! Server Error",
          message: "Terjadi kesalahan di server (Status: ${response.statusCode}). Coba lagi nanti ya.",
          icon: Icons.dns_outlined,
          iconColor: Colors.redAccent,
        );
      }
    } catch (e) {
      debugPrint("DETECTION ERROR : $e");

      _showCutePopup(
        title: "Koneksi Terputus",
        message: "Tidak dapat terhubung ke server. Pastikan internet kamu stabil dan coba lagi.",
        icon: Icons.wifi_off_rounded,
        iconColor: Colors.redAccent,
      );
    } finally {
      isAnalyzing.value = false;
    }
  }

  Future<void> resetDetection() async {
    detectedLetter.value = "-";
    confidence.value = 0;
    errorMessage.value = "";
  }

  @override
  void onClose() {
    isCameraInitialized.value = false;
    cameraController?.dispose();
    super.onClose();
  }
}