import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart'; // Tambahkan import ini

import '../controllers/semaphore_detect_controller.dart';

class SemaphoreDetectView extends GetView<SemaphoreDetectController> {
  const SemaphoreDetectView({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFCF9F4);
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          /// ==================================================
          /// BACKGROUND: LIVE CAMERA PREVIEW
          /// ==================================================
          Positioned.fill(
            child: Obx(() {
              if (controller.isCameraInitialized.value && controller.cameraController != null) {
                // Menggunakan FittedBox agar preview kamera memenuhi layar tanpa merusak rasio
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.cameraController!.value.previewSize?.height ?? 1,
                      height: controller.cameraController!.value.previewSize?.width ?? 1,
                      child: CameraPreview(controller.cameraController!),
                    ),
                  ),
                );
              } else {
                return Container(
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: secondaryColor),
                  ),
                );
              }
            }),
          ),

          /// DARK OVERLAY (Slightly reduced opacity for better visibility)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.15),
            ),
          ),

          /// VIEW FINDER
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          /// TOP BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Deteksi Semaphore',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM CONTENT
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// STATUS AI
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: controller.isAnalyzing.value ? Colors.orange : Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.isAnalyzing.value ? 'AI Menganalisis...' : 'AI Siap',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// CAPTURE BUTTON
                  GestureDetector(
                    onTap: controller.captureImage,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: primaryColor,
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// RESULT CARD
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10))
                        ],
                      ),
                      child: Row(
                        children: [
                          /// LETTER
                          Container(
                            width: 80,
                            height: 90,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4E342E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.detectedLetter.value,
                                  style: const TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.1,
                                  ),
                                ),
                                const Text(
                                  'HURUF',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          /// ACCURACY
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Akurasi AI',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: primaryColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      '${controller.accuracy.value}%',
                                      style: const TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: LinearProgressIndicator(
                                    value: controller.accuracy.value / 100,
                                    minHeight: 10,
                                    backgroundColor: const Color(0xFFF0EDE9),
                                    valueColor: const AlwaysStoppedAnimation(Color(0xFFFFCA98)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}