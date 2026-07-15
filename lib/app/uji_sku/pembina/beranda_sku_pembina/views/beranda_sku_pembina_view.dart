import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/beranda_sku_pembina_controller.dart';
import '../../../../modules/theme/theme.dart';

class BerandaSkuPembinaView extends GetView<BerandaSkuPembinaController> {
  const BerandaSkuPembinaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Dashboard Pembina SKU', 
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white)
        ),
        backgroundColor: AppTheme.primary, 
        elevation: 0, 
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // 1. KARTU PROFIL RINGKAS PEMBINA
          _buildPembinaProfile(),
          const SizedBox(height: 30),

          // 2. JUDUL NAVIGASI UTAMA
          const Text(
            "Menu Manajemen SKU",
            style: TextStyle(
              fontFamily: 'Poppins', 
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: AppTheme.primary
            ),
          ),
          const SizedBox(height: 16),

          // 3. DAFTAR MENU UTAMA (GRID / LIST KARTU AKSES)
          _buildMenuCard(
            title: "Pengajuan SKU",
            subtitle: "Verifikasi berkas persyaratan pendaftaran dari peserta didik.",
            icon: Icons.assignment_turned_in_rounded,
            colorAccent: AppTheme.secondary,
            onTap: controller.goToPengajuanSku,
          ),
          const SizedBox(height: 16),
          
          _buildMenuCard(
            title: "Penilaian SKU",
            subtitle: "Uji materi indikator kelayakan & input kelulusan poin SKU.",
            icon: Icons.fact_check_rounded,
            colorAccent: Colors.orange.shade700,
            onTap: controller.goToPenilaianSku,
          ),
        ],
      ),
    );
  }

  // Komponen Profil Atas Pembina
  Widget _buildPembinaProfile() {
    return Obx(() => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primary, 
        borderRadius: BorderRadius.circular(20), 
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.25), 
            blurRadius: 10, 
            offset: const Offset(0, 5)
          )
        ]
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30, 
            backgroundColor: AppTheme.secondaryContainer,
            backgroundImage: controller.pembinaImage.value.isNotEmpty 
                ? NetworkImage(controller.pembinaImage.value) 
                : null,
            child: controller.pembinaImage.value.isEmpty 
                ? const Icon(Icons.supervisor_account_rounded, size: 30, color: AppTheme.onSecondaryContainer) 
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hak Akses Pembina", 
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 12, color: AppTheme.secondaryContainer)
                ),
                Text(
                  controller.pembinaName.value, 
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.gite_rounded, color: Colors.white70, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      controller.gugusDepanInfo.value, 
                      style: const TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: Colors.white70)
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ));
  }

  // Komponen Tombol Menu Besar Modular
  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color colorAccent,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorAccent.withOpacity(0.15), 
                    shape: BoxShape.circle
                  ),
                  child: Icon(icon, color: colorAccent, size: 30),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, 
                        style: const TextStyle(
                          fontFamily: 'Poppins', 
                          fontSize: 18, 
                          fontWeight: FontWeight.bold, 
                          color: AppTheme.primary
                        )
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle, 
                        style: TextStyle(
                          fontFamily: 'Nunito', 
                          fontSize: 13, 
                          color: Colors.grey.shade600,
                          height: 1.3
                        )
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.outlineColor, size: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }
}