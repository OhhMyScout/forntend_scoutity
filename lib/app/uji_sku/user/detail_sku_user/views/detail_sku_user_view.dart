import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_sku_user_controller.dart';

import '../../../../modules/theme/theme.dart';

class DetailSkuUserView extends GetView<DetailSkuUserController> {
  const DetailSkuUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Obx(() => Text(
          controller.title.value,
          style: const TextStyle(
            fontFamily: 'Poppins', 
            fontWeight: FontWeight.bold, 
            color: Colors.white,
          ),
        )),
        backgroundColor: AppTheme.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.secondary));
        }

        if (controller.skuMasterList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_late_rounded, size: 80, color: AppTheme.outlineVariantColor),
                const SizedBox(height: 16),
                const Text(
                  "Buku Panduan Kosong",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Data soal untuk tingkatan ini belum tersedia.",
                  style: TextStyle(fontFamily: 'Urbanist', color: AppTheme.onSurfaceVariant),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppTheme.secondary,
          backgroundColor: Colors.white,
          onRefresh: () async => controller.fetchData(),
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 80),
            itemCount: controller.skuMasterList.length,
            itemBuilder: (context, index) {
              var item = controller.skuMasterList[index];
              String status = controller.getStatusPoin(item['id']);
              
              // Animasi list muncul berurutan (Staggered Animation)
              return _AnimatedListItem(
                delay: index * 50, // Delay bertambah 50ms per item
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildPoinCard(
                    poinId: item['id'],
                    nomor: item['nomor_poin'].toString(),
                    kategori: item['kategori'] ?? "Umum",
                    deskripsi: item['deskripsi'],
                    status: status,
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildPoinCard({
    required String poinId,
    required String nomor,
    required String kategori,
    required String deskripsi,
    required String status,
  }) {
    // Menentukan warna berdasarkan status ujian
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case "Selesai":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        break;
      case "Menunggu Validasi":
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_filled_rounded;
        break;
      case "Revisi":
        statusColor = AppTheme.errorColor;
        statusIcon = Icons.error_rounded;
        break;
      default:
        statusColor = AppTheme.outlineColor; // Belum Diuji
        statusIcon = Icons.radio_button_unchecked_rounded;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariantColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10, offset: const Offset(0, 4)
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Header Card (Nomor & Kategori)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              border: const Border(bottom: BorderSide(color: AppTheme.outlineVariantColor, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                      child: Text(
                        nomor, 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Poin $nomor",
                      style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: AppTheme.primary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    kategori,
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSecondaryContainer),
                  ),
                )
              ],
            ),
          ),
          
          // Bagian Deskripsi Soal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              deskripsi,
              style: const TextStyle(fontFamily: 'Urbanist', fontSize: 14, color: AppTheme.onSurfaceVariant, height: 1.5),
            ),
          ),

          // Bagian Status & Tombol Aksi
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Badge Status
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ],
                ),
                
                // Tombol Aksi
                if (status == "Belum Diuji" || status == "Revisi")
                  ElevatedButton(
                    onPressed: () => _showAjukanDialog(poinId, nomor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: status == "Revisi" ? AppTheme.errorColor : AppTheme.secondary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      status == "Revisi" ? "Perbaiki" : "Ajukan Uji",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  // =========================================================
  // DIALOG FORM PENGAJUAN UJIAN
  // =========================================================
  void _showAjukanDialog(String skuId, String nomor) {
    TextEditingController urlController = TextEditingController();
    
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ajukan Ujian Poin $nomor",
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                "Jika ujian berupa praktik yang sudah dinilai langsung, kosongi kolom ini. Namun jika berupa tugas, lampirkan link bukti (Google Drive, Youtube, dll).",
                style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: AppTheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  hintText: "https://...",
                  hintStyle: const TextStyle(color: AppTheme.outlineVariantColor),
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.link_rounded, color: AppTheme.outlineColor),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Batal", style: TextStyle(color: AppTheme.outlineColor, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      controller.ajukanUjian(skuId, urlController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Kirim ke Pembina", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// WIDGET BANTUAN UNTUK ANIMASI STAGGERED LIST
// =========================================================
class _AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedListItem({required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        // Logika untuk menunda animasi
        double startPoint = delay / (400 + delay);
        double animationProgress = value > startPoint ? (value - startPoint) / (1 - startPoint) : 0.0;
        
        return Opacity(
          opacity: animationProgress,
          child: Transform.translate(
            offset: Offset(30 * (1 - animationProgress), 0), // Slide in dari kanan ke kiri
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}