import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sinyal_darurat_controller.dart';

class SinyalDaruratView extends GetView<SinyalDaruratController> {
  const SinyalDaruratView({super.key});

  // Palet Warna Sinkron dengan Tema Wilderness Scoutify
  static const Color primary = Color(0xFF361F1A);
  static const Color secondary = Color(0xFF7D562D);
  static const Color secondaryContainer = Color(0xFFFFCA98);
  static const Color onSecondaryContainer = Color(0xFF7A532A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceVariant = Color(0xFFE5E2DD);
  static const Color outline = Color(0xFF827471);
  static const Color onSurfaceVariant = Color(0xFF504442);
  static const Color errorColor = Color(0xFFBA1A1A);

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
            scrolledUnderElevation: 4,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: primary),
              onPressed: controller.onBack,
            ),
            title: const Text(
              "Sinyal Darurat",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: primary,
              ),
            ),
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
                  const SizedBox(height: 32),
                  const Text(
                    "Panduan Tanda Bahaya",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: primary,
                    ),
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
        color: errorColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: errorColor.withValues(alpha: 0.2)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gpp_maybe_rounded, color: errorColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Alat Keselamatan Hidup",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: errorColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Gunakan panel interaktif di bawah ini untuk memancarkan tanda SOS darurat otomatis lewat kilatan cahaya atau ketukan bising suara.",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 13,
                    color: onSurfaceVariant,
                    height: 1.4,
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
        // Senter SOS
        Expanded(
          child: Obx(() {
            final isActive = controller.isFlashlightSosActive.value;
            return InkWell(
              onTap: controller.toggleFlashlightSos,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isActive ? primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isActive ? primary : surfaceVariant),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white.withValues(alpha: 0.15) : secondaryContainer.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive ? Icons.flashlight_on_rounded : Icons.flashlight_off_rounded,
                        color: isActive ? secondaryContainer : secondary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Senter SOS",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isActive ? Colors.white : primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isActive ? "Memancarkan..." : "Mulai Flash",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: isActive ? Colors.white.withValues(alpha: 0.7) : outline,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        const SizedBox(width: 16),

        // Suara Alarm SOS
        Expanded(
          child: Obx(() {
            final isActive = controller.isAudioSosActive.value;
            return InkWell(
              onTap: controller.toggleAudioSos,
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isActive ? errorColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isActive ? errorColor : surfaceVariant),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white.withValues(alpha: 0.2) : Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                        color: isActive ? Colors.white : errorColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Suara SOS",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isActive ? Colors.white : primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isActive ? "Berbunyi..." : "Mulai Sirine",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        color: isActive ? Colors.white.withValues(alpha: 0.7) : outline,
                      ),
                    ),
                  ],
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
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isActive ? secondary : Colors.transparent),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () => controller.toggleAccordion(index),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.signpost_rounded, color: secondary, size: 20),
                  ),
                  title: Text(
                    item["title"],
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: primary,
                    ),
                  ),
                  subtitle: Text(
                    item["subtitle"],
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, color: outline),
                  ),
                  trailing: AnimatedRotation(
                    turns: isActive ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(Icons.expand_more_rounded, color: outline),
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
                              const Divider(color: surfaceVariant),
                              const SizedBox(height: 8),
                              Text(
                                item["desc"],
                                style: const TextStyle(
                                  fontFamily: 'Urbanist',
                                  fontSize: 14,
                                  color: onSurfaceVariant,
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
          );
        });
      },
    );
  }
}