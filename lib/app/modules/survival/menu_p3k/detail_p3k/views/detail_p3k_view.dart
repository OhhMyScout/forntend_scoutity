import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_p3k_controller.dart';

class DetailP3KView extends GetView<DetailP3KController> {
  const DetailP3KView({super.key});

  static const Color primary = Color(0xFF361F1A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color secondary = Color(0xFF7D562D);
  static const Color secondaryFixed = Color(0xFFFFDCBD);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceContainerHigh = Color(0xFFEBE8E3);
  static const Color onSurfaceVariant = Color(0xFF504442);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Obx(() {
                if (controller.steps.isEmpty) {
                  return const Center(child: Text("Data tidak ditemukan"));
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Langkah Tindakan Darurat",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildStepsTimelineList(),
                      if (controller.proTip.value.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildProTipBanner(),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0x1F827471), width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: primary),
            onPressed: controller.onBack,
          ),
          const SizedBox(width: 8),
          Obx(() => Text(
                controller.title.value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primary,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildStepsTimelineList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.steps.length,
      itemBuilder: (context, index) {
        final isLast = index == controller.steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Garis Timeline vertikal kontinyu kustom
              SizedBox(
                width: 32,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (!isLast)
                      Positioned(
                        top: 32,
                        bottom: 0,
                        child: Container(width: 2, color: surfaceContainerHigh),
                      ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(color: primary, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withValues(alpha: 0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(
                      controller.steps[index],
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 15,
                        color: primary,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProTipBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: secondaryFixed.withValues(alpha: 0.2),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
        border: const Border(left: BorderSide(color: secondary, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: secondary, size: 20),
              SizedBox(width: 8),
              Text(
                "PANDUAN PRO",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: secondary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            controller.proTip.value,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}