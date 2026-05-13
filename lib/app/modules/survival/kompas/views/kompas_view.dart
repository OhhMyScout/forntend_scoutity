/// lib/app/modules/kompas/views/kompas_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/kompas_controller.dart';

class KompasView extends GetView<KompasController> {

  const KompasView({super.key});

  static const Color primaryColor =
      Color(0xFF361F1A);

  static const Color secondaryColor =
      Color(0xFF7D562D);

  static const Color backgroundColor =
      Color(0xFFFCF9F4);

  static const Color textSecondary =
      Color(0xFF504442);

  static const Color surfaceLow =
      Color(0xFFF6F3EE);

  static const Color outlineColor =
      Color(0xFFD4C3BF);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => Get.back(),

          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),

        title: const Text(
          'Kompas Digital',
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: controller.refreshCompass,
        backgroundColor: primaryColor,

        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const SizedBox(height: 10),

              /// COMPASS
              SizedBox(
                width: 340,
                height: 340,

                child: Stack(
                  alignment: Alignment.center,

                  children: [

                    /// OUTER CIRCLE
                    Container(
                      width: 340,
                      height: 340,

                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: surfaceLow,
                          width: 12,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withValues(alpha: 0.08),
                            blurRadius: 40,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),

                    /// INNER CIRCLE
                    Container(
                      width: 300,
                      height: 300,

                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: outlineColor,
                        ),
                      ),
                    ),

                    /// MARKS
                    ...List.generate(
                      12,
                      (index) {

                        final angle =
                            index * 30.0;

                        final isMajor =
                            index % 3 == 0;

                        return Transform.rotate(
                          angle: angle * 3.1415926535 / 180,

                          child: Align(
                            alignment: Alignment.topCenter,

                            child: Container(
                              margin: const EdgeInsets.only(
                                top: 16,
                              ),

                              width: isMajor ? 3 : 2,
                              height: isMajor ? 20 : 12,

                              decoration: BoxDecoration(
                                color: isMajor
                                    ? primaryColor
                                    : Colors.grey.shade500,

                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    /// DIRECTION LETTERS
                    const Positioned(
                      top: 24,

                      child: Text(
                        'N',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),

                    const Positioned(
                      bottom: 24,

                      child: Text(
                        'S',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textSecondary,
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 24,

                      child: Text(
                        'W',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textSecondary,
                        ),
                      ),
                    ),

                    const Positioned(
                      right: 24,

                      child: Text(
                        'E',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textSecondary,
                        ),
                      ),
                    ),

                    /// NEEDLE
                    Obx(
                      () => Transform.rotate(
                        angle:
                            controller.rotation.value *
                            3.1415926535 /
                            180,

                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            Container(
                              width: 8,
                              height: 120,

                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius:
                                    BorderRadius.circular(100),
                              ),
                            ),

                            Container(
                              width: 18,
                              height: 18,

                              decoration: BoxDecoration(
                                color: backgroundColor,
                                shape: BoxShape.circle,

                                border: Border.all(
                                  color: primaryColor,
                                  width: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// TOP MARK
                    Positioned(
                      top: 0,

                      child: Container(
                        width: 4,
                        height: 40,

                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// DEGREE
              Obx(
                () => Text(
                  '${controller.rotation.value.toStringAsFixed(0)}° ${controller.direction.value}',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// FULL DIRECTION
              Obx(
                () => Text(
                  controller.fullDirection.value,
                  style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w700,
                    color: textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}