import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_tali_controller.dart';

class DetailTaliView extends GetView<DetailTaliController> {
  const DetailTaliView({super.key});

  static const Color primary = Color(0xFF361F1A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color secondary = Color(0xFF7D562D);
  static const Color onSurfaceVariant = Color(0xFF504442);
  static const Color outline = Color(0xFF827471);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceContainerHigh = Color(0xFFEBE8E3);

  @override
  Widget build(BuildContext context) {
    Get.put(DetailTaliController());

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primary),
          onPressed: controller.onBack,
        ),
        title: Obx(() => Text(
          controller.title.value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: primary,
          ),
        )),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: surfaceContainerHigh,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Obx(() => Text(
              controller.level.value,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: primary,
              ),
            )),
          )
        ],
      ),
      body: Obx(() {
        if (controller.steps.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: primary));
        }

        final currentStepData = controller.steps[controller.currentStepIndex.value];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AREA SLIDER GAMBAR
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.08),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                            // Menggunakan Image.asset untuk membaca file lokal
                            child: Image.asset(
                              currentStepData['image']!,
                              key: ValueKey<int>(controller.currentStepIndex.value),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: surfaceContainerLow,
                                child: const Icon(Icons.broken_image, size: 50, color: outline),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // KONTROL SLIDER (Prev, Dots, Next)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: controller.prevStep,
                          icon: const Icon(Icons.arrow_back_ios_rounded, color: primary),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: primary.withValues(alpha: 0.2),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                controller.steps.length,
                                (index) => GestureDetector(
                                  onTap: () => controller.goToStep(index),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    height: 8,
                                    width: controller.currentStepIndex.value == index ? 24 : 8,
                                    decoration: BoxDecoration(
                                      color: controller.currentStepIndex.value == index
                                          ? primary
                                          : outline.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: controller.nextStep,
                          icon: const Icon(Icons.arrow_forward_ios_rounded, color: primary),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: primary.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Tombol Play / Pause Otomatis
                    ElevatedButton.icon(
                      onPressed: controller.togglePlay,
                      icon: Icon(
                        controller.isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: controller.isPlaying.value ? primary : Colors.white,
                      ),
                      label: Text(
                        controller.isPlaying.value ? "Jeda Otomatis" : "Putar Otomatis",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          color: controller.isPlaying.value ? primary : Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.isPlaying.value ? surfaceContainerHigh : primary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Divider(color: surfaceContainerHigh, thickness: 2),
              ),

              // AREA TEKS PENJELASAN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kegunaan Simpul",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.description.value,
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15,
                        color: onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Instruksi Langkah Saat Ini
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: surfaceContainerHigh),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: secondary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.menu_book_rounded, color: secondary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Langkah ${controller.currentStepIndex.value + 1} dari ${controller.steps.length}",
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: secondary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return FadeTransition(opacity: animation, child: child);
                            },
                            child: Text(
                              currentStepData['instruction']!,
                              key: ValueKey<int>(controller.currentStepIndex.value),
                              style: const TextStyle(
                                fontFamily: 'Urbanist',
                                fontSize: 16,
                                color: primary,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}