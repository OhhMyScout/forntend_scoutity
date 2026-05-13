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

          /// BACKGROUND IMAGE
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuBPCrolAIt0OGKHRcBX2SNVLtPfEdbmGnuODZSzA8TbxzVIf-Fwac2DYjT8wUayJRq0BbnZUMQb7--R00jOp6lppUKkEdjhMlFVL_12NpivmXRh8CLMbYUCIFZ6r31vXeA6SopVM3mes6vua2Twp0tC5d7MHEXwaS6uukMb3tc0JGHJIaXrAx_Wgk5HDDHTrUZ3ExZTZG-szwPdZbchB2tCFZreUbUB9C32GGA9RO_4u2AWTjjSUcIJzyliRW7lFO-gCWKHHjqwdZ0',
              fit: BoxFit.cover,
            ),
          ),

          /// DARK OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),

          /// VIEW FINDER
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          /// TOP BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                children: [

                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            controller.isAnalyzing.value
                                ? 'AI Menganalisis...'
                                : 'AI Siap',
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
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: primaryColor,
                          size: 38,
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
                        color: Colors.white.withOpacity(0.88),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [

                          /// LETTER
                          Container(
                            width: 80,
                            height: 100,
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
                                  ),
                                ),

                                const Text(
                                  'HURUF',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          /// ACCURACY
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [

                                    const Text(
                                      'Akurasi AI',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    Text(
                                      '${controller.accuracy.value}%',
                                      style: const TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(100),
                                  child: LinearProgressIndicator(
                                    value:
                                        controller.accuracy.value / 100,
                                    minHeight: 10,
                                    backgroundColor:
                                        const Color(0xFFF0EDE9),
                                    valueColor:
                                        const AlwaysStoppedAnimation(
                                      Color(0xFFFFCA98),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}