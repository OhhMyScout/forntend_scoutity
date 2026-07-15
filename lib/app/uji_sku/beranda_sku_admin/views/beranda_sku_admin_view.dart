import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/beranda_sku_admin_controller.dart';

class BerandaSkuAdminView extends GetView<BerandaSkuAdminController> {
  const BerandaSkuAdminView({super.key});
  
  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF361F1A);
    const accentColor = Color(0xFF7D562D);

    return Scaffold(
      backgroundColor: const Color(0xFFF3EBE1), // Menyesuaikan tema krem Scoutify
      appBar: AppBar(
        title: const Text(
          'Persetujuan Pembina Baru',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.listPengajuan.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: accentColor),
          );
        }

        if (controller.listPengajuan.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_turned_in_outlined, size: 70, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada pengajuan pending saat ini.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.getDaftarPengajuan(),
          color: accentColor,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.listPengajuan.length,
            itemBuilder: (context, index) {
              final item = controller.listPengajuan[index];
              final user = item['users'] ?? {};
              
              final String fullname = user['fullname'] ?? 'Tanpa Nama';
              final String email = user['email'] ?? '-';
              final String? userImageUrl = user['image']; // Foto Profil User
              final String buktiFotoPramuka = item['foto_pramuka'] ?? ''; // Foto Pramuka dari Pengajuan

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SEKSI 1: Profil Pengaju (Avatar + Nama + Email)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: accentColor.withOpacity(0.2),
                            backgroundImage: userImageUrl != null && userImageUrl.isNotEmpty
                                ? NetworkImage(userImageUrl)
                                : null,
                            child: userImageUrl == null || userImageUrl.isEmpty
                                ? const Icon(Icons.person, color: accentColor, size: 28)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fullname, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)),
                                Text(email, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),

                      // SEKSI 2: Data Sekolah & Gudep
                      Text('Sekolah: ${item['sekolah']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(child: Text('Gudep PA: ${item['gudep_pa'] ?? '-'}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13))),
                          Expanded(child: Text('Gudep PI: ${item['gudep_pi'] ?? '-'}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13))),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // SEKSI 3: Tampilan Preview Foto Bukti Pramuka Lengkap
                      const Text(
                        'Foto Bukti Pramuka Lengkap:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: accentColor),
                      ),
                      const SizedBox(height: 8),
                      if (buktiFotoPramuka.isNotEmpty)
                        GestureDetector(
                          onTap: () => _detailFotoDialog(context, buktiFotoPramuka, fullname),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              buktiFotoPramuka,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 150,
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: CircularProgressIndicator(color: accentColor),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                          child: const Center(child: Text('Tidak ada lampiran foto pramuka.', style: TextStyle(fontSize: 12))),
                        ),
                      const SizedBox(height: 20),

                      // SEKSI 4: Aksi Penolakan & Persetujuan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            onPressed: () => _showKonfirmasiDialog(context, item['id'], 'rejected'),
                            icon: const Icon(Icons.cancel, size: 18),
                            label: const Text('Tolak'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            onPressed: () => _showKonfirmasiDialog(context, item['id'], 'approved'),
                            icon: const Icon(Icons.check_circle, size: 18),
                            label: const Text('Setujui'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // Dialog Konfirmasi Persetujuan / Penolakan
  void _showKonfirmasiDialog(BuildContext context, String pengajuanId, String statusAction) {
    final title = statusAction == 'approved' ? 'Setujui Pengajuan' : 'Tolak Pengajuan';
    final contentText = statusAction == 'approved' 
        ? 'Apakah Anda yakin ingin menyetujui pengajuan sebagai Pembina?' 
        : 'Apakah Anda yakin ingin menolak pengajuan ini?';
    
    Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF361F1A)),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(contentText, textAlign: TextAlign.center),
      ),
      textConfirm: 'Ya, Proses',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: statusAction == 'approved' ? Colors.green : Colors.red,
      onConfirm: () {
        Get.back();
        controller.prosesVerifikasi(pengajuanId, statusAction);
      },
    );
  }

  // Dialog Modal untuk mempebesar Foto Pramuka (Lightbox Mode)
  void _detailFotoDialog(BuildContext context, String urlFoto, String namaUser) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Container Foto utama
            InteractiveViewer( // Supaya foto bisa di-zoom cubit oleh admin
              panEnabled: true,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  urlFoto,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Tombol X Tutup di Pojok Atas
            Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}