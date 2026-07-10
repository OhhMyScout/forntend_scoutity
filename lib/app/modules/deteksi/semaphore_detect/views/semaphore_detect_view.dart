import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          /// =========================================
          /// 1. CAMERA PREVIEW
          /// =========================================
          Positioned.fill(
            child: Obx(() {
              if (!controller.isCameraInitialized.value ||
                  controller.cameraController == null) {
                return const ColoredBox(
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: controller
                            .cameraController!
                            .value
                            .previewSize
                            ?.height ??
                        1,
                    height: controller
                            .cameraController!
                            .value
                            .previewSize
                            ?.width ??
                        1,
                    child: CameraPreview(
                      controller.cameraController!,
                    ),
                  ),
                ),
              );
            }),
          ),

          /// =========================================
          /// 2. OVERLAY
          /// =========================================
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.15),
            ),
          ),

          /// =========================================
          /// 3. VIEW FINDER
          /// =========================================
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white70,
                  width: 2,
                ),
              ),
            ),
          ),

          /// =========================================
          /// 4. APP BAR & CAMERA CONTROLS (KANAN ATAS)
          /// =========================================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// BACK BUTTON & TITLE
                  Expanded(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: Get.back,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: const BoxDecoration(
                              color: Colors.white,
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
                          "Deteksi Semaphore",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// FLIP CAMERA & FLASH CONTROLS
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => IconButton.filledTonal(
                        onPressed: controller.isCameraInitialized.value
                            ? controller.flipCamera
                            : null,
                        icon: const Icon(Icons.flip_camera_android_rounded),
                        tooltip: 'Flip camera',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: primaryColor,
                        ),
                      )),
                      const SizedBox(height: 8),
                      Obx(() => IconButton.filledTonal(
                        onPressed: controller.isCameraInitialized.value
                            ? controller.toggleFlash
                            : null,
                        icon: Icon(
                          controller.isFlashOn.value
                              ? Icons.flash_on_rounded
                              : Icons.flash_off_rounded,
                        ),
                        tooltip: controller.isFlashOn.value
                            ? 'Matikan flash'
                            : 'Nyalakan flash',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          foregroundColor: primaryColor,
                        ),
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// =========================================
          /// 5. BOTTOM CONTENT
          /// =========================================
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// STATUS
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.isAnalyzing.value
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            controller.isAnalyzing.value
                                ? "Menganalisis..."
                                : "Siap",
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// BUTTON DETEKSI
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isAnalyzing.value
                          ? null
                          : controller.detectSemaphore,
                      child: Container(
                        width: 85,
                        height: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: controller.isAnalyzing.value
                              ? const Padding(
                                  padding: EdgeInsets.all(22),
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 32,
                                  color: primaryColor,
                                ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// RESULT CARD
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          /// HURUF
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: secondaryColor, // Diubah agar sesuai tema
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  controller.detectedLetter.value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  "HURUF",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          /// PROGRESS CONFIDENCE
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Confidence",
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${controller.confidence.value.toStringAsFixed(1)}%",
                                      style: const TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: LinearProgressIndicator(
                                    value: controller.confidence.value / 100,
                                    minHeight: 10,
                                    backgroundColor: backgroundColor,
                                    color: primaryColor,
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

          /// =========================================
          /// 6. CUSTOM ANIMATED POP-UP (ERROR NOTIFICATION)
          /// =========================================
          Obx(() => AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                top: controller.errorMessage.value.isNotEmpty ? 100 : -100,
                left: 20,
                right: 20,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.errorMessage.value.isNotEmpty ? 1.0 : 0.0,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor, // Sesuai warna tema
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              controller.errorMessage.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Menutup pop-up ketika tombol X ditekan
                              controller.errorMessage.value = '';
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}