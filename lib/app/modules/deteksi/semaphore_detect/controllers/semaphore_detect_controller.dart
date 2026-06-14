import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../../../data/api_endpoint.dart';

class SemaphoreDetectController extends GetxController {
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  final isCameraInitialized = false.obs;
  final isAnalyzing = false.obs;

  final detectedLetter = "-".obs;
  final confidence = 0.0.obs;

  final errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      final permission = await Permission.camera.request();

      if (!permission.isGranted) {
        Get.snackbar(
          "Izin Ditolak",
          "Aplikasi membutuhkan akses kamera",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return;
      }

      cameras = await availableCameras();

      if (cameras == null || cameras!.isEmpty) {
        Get.snackbar(
          "Error",
          "Kamera tidak ditemukan",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return;
      }

      CameraDescription selectedCamera = cameras!.first;

      final backCamera = cameras!.where(
        (camera) =>
            camera.lensDirection ==
            CameraLensDirection.back,
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

      Get.snackbar(
        "Error",
        "Gagal mengakses kamera",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> detectSemaphore() async {
    try {
      if (cameraController == null) return;

      if (!cameraController!.value.isInitialized) {
        return;
      }

      if (isAnalyzing.value) {
        return;
      }

      HapticFeedback.mediumImpact();

      isAnalyzing.value = true;
      errorMessage.value = "";

      final XFile image =
          await cameraController!.takePicture();

      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
          ApiEndpoint.semaphoreDetect,
        ),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          image.path,
        ),
      );

      final streamedResponse =
          await request.send();

      final response =
          await http.Response.fromStream(
        streamedResponse,
      );

      debugPrint(
        "STATUS CODE : ${response.statusCode}",
      );

      debugPrint(
        "BODY : ${response.body}",
      );

      final result =
          jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (result["success"] == true) {
          detectedLetter.value =
              result["result"]["label"] ?? "-";

          confidence.value =
              ((result["result"]["confidence"] ?? 0)
                      .toDouble()) *
                  100;
        } else {
          detectedLetter.value = "-";
          confidence.value = 0;

          errorMessage.value =
              result["message"] ??
              "Pose tidak terdeteksi";

          Get.snackbar(
            "Deteksi Gagal",
            errorMessage.value,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else {
        detectedLetter.value = "-";
        confidence.value = 0;

        Get.snackbar(
          "Server Error",
          "Status Code ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint(
        "DETECTION ERROR : $e",
      );

      Get.snackbar(
        "Error",
        "Tidak dapat terhubung ke server",
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
    cameraController?.dispose();
    super.onClose();
  }
}