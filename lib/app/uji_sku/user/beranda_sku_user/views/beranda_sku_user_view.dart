import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/beranda_sku_user_controller.dart';
import '../../../../modules/theme/theme.dart';

class BerandaSkuUserView extends GetView<BerandaSkuUserController> {
  const BerandaSkuUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Dashboard SKU', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primary, elevation: 0, centerTitle: true, iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: AppTheme.secondary));
        return RefreshIndicator(
          color: AppTheme.secondary, backgroundColor: Colors.white,
          onRefresh: () async => controller.fetchUserSkuProgress(),
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              // 1. DATA RINGKAS USER
              _AnimatedComponent(delay: 0, child: _buildCompactProfile()),
              const SizedBox(height: 24),

              // 2. TOMBOL AKSI CEPAT (Lanjut Ujian & Form)
              _AnimatedComponent(delay: 100, child: _buildActionButtons()),
              const SizedBox(height: 32),

              // 3. DAFTAR KARTU LEVEL
              _AnimatedComponent(delay: 200, child: const Text("Peta Perjalanan Kecakapan", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primary))),
              const SizedBox(height: 16),
              _AnimatedComponent(delay: 300, child: _buildLevelCard("Penggalang Ramu", controller.idRamu, controller.progressRamu.value, true)),
              const SizedBox(height: 16),
              _AnimatedComponent(delay: 400, child: _buildLevelCard("Penggalang Rakit", controller.idRakit, controller.progressRakit.value, controller.isRakitUnlocked.value)),
              const SizedBox(height: 16),
              _AnimatedComponent(delay: 500, child: _buildLevelCard("Penggalang Terap", controller.idTerap, controller.progressTerap.value, controller.isTerapUnlocked.value)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildCompactProfile() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30, backgroundColor: AppTheme.secondaryContainer,
            backgroundImage: controller.userImage.value.isNotEmpty ? NetworkImage(controller.userImage.value) : null,
            child: controller.userImage.value.isEmpty ? const Icon(Icons.person_rounded, size: 30, color: AppTheme.onSecondaryContainer) : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Peserta Didik", style: TextStyle(fontFamily: 'Nunito', fontSize: 12, color: AppTheme.secondaryContainer)),
                Text(controller.userName.value, style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text("${controller.userPoints.value} Poin", style: const TextStyle(fontFamily: 'Urbanist', fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.goToFormPengajuan,
            icon: const Icon(Icons.edit_document), label: const Text("Form Pengajuan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: AppTheme.secondary,
              elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppTheme.secondary, width: 1.5)),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.lanjutUjian,
            icon: const Icon(Icons.play_arrow_rounded), label: const Text("Lanjut Ujian"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondary, foregroundColor: Colors.white,
              elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(String title, String levelId, double progress, bool isUnlocked) {
    int percent = (progress * 100).toInt();
    if (percent > 100) percent = 100;
    return GestureDetector(
      onTap: () {
        if (isUnlocked) Get.toNamed('/detail-sku-user', arguments: {'level_id': levelId, 'title': title});
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: isUnlocked ? BorderSide.none : const BorderSide(color: AppTheme.outlineVariantColor)),
        elevation: isUnlocked ? 2 : 0, color: isUnlocked ? Colors.white : AppTheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: isUnlocked ? AppTheme.secondaryContainer : AppTheme.surfaceContainerHighest, shape: BoxShape.circle),
                child: Icon(isUnlocked ? Icons.menu_book_rounded : Icons.lock_rounded, color: isUnlocked ? AppTheme.onSecondaryContainer : AppTheme.outlineColor, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: isUnlocked ? AppTheme.primary : AppTheme.outlineColor)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: progress, backgroundColor: AppTheme.surfaceContainerHighest, color: isUnlocked ? AppTheme.secondary : AppTheme.outlineVariantColor, minHeight: 8))),
                        const SizedBox(width: 12),
                        Text("$percent%", style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w800, color: isUnlocked ? AppTheme.secondary : AppTheme.outlineColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedComponent extends StatelessWidget {
  final Widget child;
  final int delay;
  const _AnimatedComponent({required this.child, required this.delay});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1), duration: Duration(milliseconds: 500 + delay), curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        double startPoint = delay / (500 + delay);
        double animationProgress = value > startPoint ? (value - startPoint) / (1 - startPoint) : 0.0;
        return Opacity(opacity: animationProgress, child: Transform.translate(offset: Offset(0, 30 * (1 - animationProgress)), child: child));
      },
      child: child,
    );
  }
}