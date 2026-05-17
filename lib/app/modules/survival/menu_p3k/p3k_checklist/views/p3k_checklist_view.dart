import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/p3k_checklist_controller.dart';

class P3KChecklistView extends GetView<P3KChecklistController> {
  const P3KChecklistView({super.key});

  static const Color primary = Color(0xFF361F1A);
  static const Color background = Color(0xFFFCF9F4);
  static const Color secondary = Color(0xFF7D562D);
  static const Color secondaryContainer = Color(0xFFFFCA98);
  static const Color onSecondaryContainer = Color(0xFF7A532A);
  static const Color surfaceContainerLow = Color(0xFFF6F3EE);
  static const Color surfaceContainerHigh = Color(0xFFEBE8E3);
  static const Color outlineVariant = Color(0xFFD4C3BF);
  static const Color onSurfaceVariant = Color(0xFF504442);

  @override
  Widget build(BuildContext context) {
    // Memastikan controller siap dipakai
    Get.put(P3KChecklistController());

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildProgressBarPanel(),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                  itemCount: controller.checklistItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.checklistItems[index];
                    final bool isChecked = (item['isCheck'] as bool?) ?? false;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isChecked ? Colors.white : Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isChecked ? secondary : outlineVariant.withValues(alpha: 0.2),
                          width: isChecked ? 1.5 : 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: isChecked ? 0.04 : 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ListTile(
                        onTap: () => controller.toggleItem(index),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        leading: Checkbox(
                          value: isChecked,
                          activeColor: secondary,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          onChanged: (_) => controller.toggleItem(index),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item['title'],
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: primary,
                                  decoration: isChecked ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                            _buildCategoryBadge(item['category']),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            item['desc'],
                            style: const TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 12,
                              color: onSurfaceVariant,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: primary),
                onPressed: controller.onBack,
              ),
              const SizedBox(width: 8),
              const Text(
                "Checklist Isi Tas P3K",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primary,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: onSurfaceVariant),
            tooltip: "Reset All",
            onPressed: () => controller.resetChecklist(),
          )
        ],
      ),
    );
  }

  Widget _buildProgressBarPanel() {
    return Obx(() {
      final double progress = controller.progressPercentage;
      final int current = controller.checkedCount;
      final int total = controller.checklistItems.length;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Color(0x0A361F1A), blurRadius: 20, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kesiapan Inventaris",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "$current dari $total alat esensial siap",
                        style: const TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 13,
                          color: onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Halaman ini adalah halaman sebagai pengingat dan kesiapan isi di dalam tas P3K. Data yg di ceklis tidak akan di simpan melainkan untuk membantu pengecekan tas P3K.',
                        softWrap: true,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 12,
                          color: onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${(progress * 100).toInt()}%",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                height: 10,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: surfaceContainerHigh,
                  color: secondary,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCategoryBadge(String label) {
    Color labelColor = primary;
    Color containerColor = surfaceContainerLow;

    switch (label) {
      case "Pembalut":
        labelColor = onSecondaryContainer;
        containerColor = secondaryContainer.withValues(alpha: 0.4);
        break;
      case "Cairan":
        labelColor = const Color(0xFF006874);
        containerColor = const Color(0xFFE0F3F5);
        break;
      case "Obat":
        labelColor = const Color(0xFFBA1A1A);
        containerColor = const Color(0xFFFFDAD6);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w800,
          fontSize: 10,
          color: labelColor,
        ),
      ),
    );
  }
}

