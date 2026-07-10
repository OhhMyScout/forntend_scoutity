import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/beranda_sku_controller.dart';

import '../../../modules/theme/theme.dart';

class BerandaSkuView extends GetView<BerandaSkuController> {
  const BerandaSkuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Pusat Evaluasi SKU',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppTheme.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.secondary));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. KARTU PROFIL USER (KTA Digital)
              _AnimatedComponent(
                delay: 0,
                child: _buildProfileCard(),
              ),
              const SizedBox(height: 32),

              // 2. BAGIAN PROGRESS (Hanya tampil jika role = USER)
              if (controller.userRole.value == 'USER') ...[
                _AnimatedComponent(
                  delay: 200,
                  child: const Text(
                    "Ringkasan Progress SKU",
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 16),
                _AnimatedComponent(delay: 300, child: _buildProgressItem("Penggalang Ramu", controller.progressRamu.value)),
                const SizedBox(height: 12),
                _AnimatedComponent(delay: 400, child: _buildProgressItem("Penggalang Rakit", controller.progressRakit.value)),
                const SizedBox(height: 12),
                _AnimatedComponent(delay: 500, child: _buildProgressItem("Penggalang Terap", controller.progressTerap.value)),
              ] else ...[
                // Pesan khusus untuk Pembina / Admin
                _AnimatedComponent(
                  delay: 200,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.outlineVariantColor),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.admin_panel_settings_rounded, size: 50, color: AppTheme.secondary),
                        const SizedBox(height: 16),
                        Text(
                          controller.userRole.value == 'PEMBINA' 
                            ? "Anda masuk sebagai Pembina. Anda memiliki akses untuk memvalidasi dan melantik peserta didik."
                            : "Anda masuk sebagai Admin. Anda memiliki akses penuh untuk mengelola master data syarat kecakapan umum.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontFamily: 'Urbanist', fontSize: 14, color: AppTheme.onSurfaceVariant, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        );
      }),
      // 3. TOMBOL NAVIGASI DINAMIS DI BAWAH LAYAR
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        if (controller.isLoading.value) return const SizedBox();
        
        return _AnimatedComponent(
          delay: 600,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: controller.goToRoleDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: AppTheme.secondary.withValues(alpha: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Masuk Dashboard ${controller.userRole.value}",
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // =========================================================
  // KOMPONEN: KARTU PROFIL LENGKAP (KTA DIGITAL)
  // =========================================================
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppTheme.primary.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 8)),
        ],
        image: DecorationImage(
          image: const NetworkImage("https://www.transparenttextures.com/patterns/cubes.png"), // Efek tekstur halus
          colorFilter: ColorFilter.mode(Colors.white.withValues(alpha: 0.05), BlendMode.dstIn),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Container(
                height: 70, width: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondaryContainer,
                  border: Border.all(color: AppTheme.secondaryContainer, width: 2),
                  image: controller.userImage.value.isNotEmpty
                      ? DecorationImage(image: NetworkImage(controller.userImage.value), fit: BoxFit.cover)
                      : null,
                ),
                child: controller.userImage.value.isEmpty 
                    ? const Icon(Icons.person_rounded, size: 40, color: AppTheme.onSecondaryContainer)
                    : null,
              ),
              const SizedBox(width: 16),
              
              // Nama & Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userName.value,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        controller.userRole.value,
                        style: const TextStyle(fontFamily: 'Nunito', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 20),
          
          // Informasi Lengkap
          _buildProfileInfoRow(Icons.email_rounded, "Email", controller.userEmail.value.isNotEmpty ? controller.userEmail.value : "-"),
          const SizedBox(height: 12),
          _buildProfileInfoRow(Icons.location_on_rounded, "Provinsi", controller.userProvince.value.isNotEmpty ? controller.userProvince.value : "Belum diatur"),
          const SizedBox(height: 12),
          _buildProfileInfoRow(Icons.stars_rounded, "Poin Terkumpul", "${controller.userPoints.value} Poin", iconColor: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildProfileInfoRow(IconData icon, String label, String value, {Color iconColor = AppTheme.secondaryContainer}) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, color: Colors.white60)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontFamily: 'Urbanist', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        )
      ],
    );
  }

  // =========================================================
  // KOMPONEN: BAR PROGRESS SEDERHANA
  // =========================================================
  Widget _buildProgressItem(String title, double progress) {
    int percent = (progress * 100).toInt();
    if (percent > 100) percent = 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariantColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: AppTheme.primary)),
              Text("$percent%", style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppTheme.secondary)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.surfaceContainerHighest,
              color: AppTheme.secondary,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================
// WIDGET BANTUAN UNTUK ANIMASI SLIDE UP & FADE IN
// =========================================================
class _AnimatedComponent extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedComponent({required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        double startPoint = delay / (500 + delay);
        double animationProgress = value > startPoint ? (value - startPoint) / (1 - startPoint) : 0.0;
        return Opacity(
          opacity: animationProgress,
          child: Transform.translate(offset: Offset(0, 30 * (1 - animationProgress)), child: child),
        );
      },
      child: child,
    );
  }
}