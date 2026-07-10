import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sinyal_darurat_controller.dart';

class SinyalDaruratView extends GetView<SinyalDaruratController> {
  const SinyalDaruratView({super.key});

  // Palet Warna disesuaikan dengan Tema Beranda (Earth Tone + Alert Colors)
  static const Color primaryText = Color(0xFF3E2723); // Coklat Gelap
  static const Color background = Color(0xFFF9F6F0); // Krem Pasir (Sama seperti beranda)
  static const Color outline = Color(0xFFD7CCC8); // Coklat Terang untuk Border
  static const Color shadowColor = Color(0xFFA1887F); // Coklat untuk bayangan 3D
  static const Color errorColor = Color(0xFFD32F2F); // Merah Darurat
  static const Color warningColor = Color(0xFFFF8F00); // Kuning Amber

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: background.withValues(alpha: 0.9),
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: outline, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: shadowColor,
                      offset: Offset(0, 2),
                      blurRadius: 0,
                    )
                  ]
                ),
                child: const Icon(Icons.arrow_back_rounded, color: primaryText, size: 20),
              ),
              onPressed: controller.onBack,
            ),
            title: const Text(
              "Sinyal Darurat",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: primaryText,
              ),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(),
                  const SizedBox(height: 24),
                  _buildInteractiveToolsPanel(),
                  const SizedBox(height: 36),
                  
                  // Judul Panduan
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEFEBE1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: Color(0xFF6D4C41), size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Panduan Tanda Bahaya",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: primaryText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildGuidesSection(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE), // Merah sangat muda
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEF9A9A), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEF9A9A).withValues(alpha: 0.5),
            offset: const Offset(0, 5),
            blurRadius: 0, // Efek 3D timbul
          )
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_rounded, color: errorColor, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pusat Keselamatan",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: errorColor,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Gunakan panel di bawah ini untuk memancarkan tanda SOS otomatis lewat kilatan cahaya atau suara sirine.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFC62828),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveToolsPanel() {
    return Row(
      children: [
        // Senter SOS Button
        Expanded(
          child: Obx(() {
            final isActive = controller.isFlashlightSosActive.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8), // Ruang untuk shadow 3D
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFFFD54F) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isActive ? const Color(0xFFF57F17) : outline,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isActive ? const Color(0xFFF57F17) : shadowColor,
                    offset: const Offset(0, 6),
                    blurRadius: 0, // Efek mainan 3D
                  )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.toggleFlashlightSos,
                  borderRadius: BorderRadius.circular(22),
                  splashColor: isActive ? Colors.white.withValues(alpha: 0.3) : const Color(0xFFFFF8E1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : const Color(0xFFFFF8E1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isActive ? Icons.flashlight_on_rounded : Icons.flashlight_off_rounded,
                            color: isActive ? const Color(0xFFF57F17) : warningColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Senter SOS",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isActive ? const Color(0xFF5D4037) : primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isActive ? "Memancarkan..." : "Mulai Flash",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? const Color(0xFF795548) : const Color(0xFF8D6E63),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 16),

        // Suara Alarm SOS Button
        Expanded(
          child: Obx(() {
            final isActive = controller.isAudioSosActive.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8), // Ruang untuk shadow 3D
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFFEF5350) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isActive ? const Color(0xFFB71C1C) : outline,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isActive ? const Color(0xFFB71C1C) : shadowColor,
                    offset: const Offset(0, 6),
                    blurRadius: 0, // Efek mainan 3D
                  )
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.toggleAudioSos,
                  borderRadius: BorderRadius.circular(22),
                  splashColor: isActive ? Colors.white.withValues(alpha: 0.3) : const Color(0xFFFFEBEE),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : const Color(0xFFFFEBEE),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isActive ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                            color: isActive ? errorColor : errorColor,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Suara SOS",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isActive ? Colors.white : primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isActive ? "Berbunyi..." : "Mulai Sirine",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isActive ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF8D6E63),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildGuidesSection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.signalGuides.length,
      itemBuilder: (context, index) {
        final item = controller.signalGuides[index];
        return Obx(() {
          final isActive = controller.activeAccordionIndex.value == index;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFFF8E1) : Colors.white, // Kuning muda jika dibuka
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isActive ? warningColor : outline, 
                width: 2
              ),
              boxShadow: const [
                // Shadow solid (timbul) juga diterapkan pada list panduan
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(0, 4),
                  blurRadius: 0,
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  InkWell(
                    onTap: () => controller.toggleAccordion(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isActive ? warningColor : const Color(0xFFEFEBE1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.signpost_rounded, 
                              color: isActive ? Colors.white : const Color(0xFF6D4C41), 
                              size: 20
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["title"],
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: isActive ? const Color(0xFF5D4037) : primaryText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item["subtitle"],
                                  style: const TextStyle(
                                    fontSize: 12, 
                                    color: Color(0xFF8D6E63)
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedRotation(
                            turns: isActive ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 250),
                            child: Icon(
                              Icons.expand_more_rounded, 
                              color: isActive ? warningColor : const Color(0xFF8D6E63)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.fastOutSlowIn,
                    child: isActive
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Column(
                              children: [
                                Divider(color: warningColor.withValues(alpha: 0.3), thickness: 1.5),
                                const SizedBox(height: 12),
                                Text(
                                  item["desc"],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF5D4037),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(width: double.infinity, height: 0),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}