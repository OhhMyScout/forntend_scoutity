import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/daftar_antrian_validasi_controller.dart';
import '../../../../modules/theme/theme.dart';

class DaftarAntrianValidasiView extends GetView<DaftarAntrianValidasiController> {
  const DaftarAntrianValidasiView({super.key});

  // Fungsi utilitas membuka link bukti Google Drive siswa di browser eksternal HP
  Future<void> _bukaLinkDrive(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Gagal membuka link bukti Google Drive.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(DaftarAntrianValidasiController()); // Injeksi Controller

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Antrian Validasi Berkas SKU', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppTheme.primary, centerTitle: true, iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.antrianList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.secondary));
        }

        if (controller.antrianList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open_rounded, size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                const Text("Belum ada antrian berkas masuk saat ini.", style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: Colors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchAntrianPengajuan(),
          color: AppTheme.secondary,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.antrianList.length,
            itemBuilder: (context, index) {
              final item = controller.antrianList[index];
              final user = item['users'] ?? {};
              
              final String namaSiswa = item['nama'] ?? user['fullname'] ?? 'Tanpa Nama';
              final String fotoProfil = user['image'] ?? '';
              final String buktiUrl = item['bukti_url'] ?? '';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppTheme.secondaryContainer,
                            backgroundImage: fotoProfil.isNotEmpty ? NetworkImage(fotoProfil) : null,
                            child: fotoProfil.isEmpty ? const Icon(Icons.person, color: AppTheme.onSecondaryContainer) : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(namaSiswa, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.primary)),
                                Text("Gudep: ${item['gudep']} | ${item['province']}", style: const TextStyle(fontFamily: 'Urbanist', fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppTheme.secondaryContainer, borderRadius: BorderRadius.circular(20)),
                            child: Text(item['tingkat'] ?? '', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSecondaryContainer)),
                          )
                        ],
                      ),
                      const Divider(height: 24),
                      Text("Golongan Kecakapan: ${item['golongan']}", style: const TextStyle(fontFamily: 'Nunito', fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      
                      // Tombol Klik Akses Preview Google Drive Siswa
                      InkWell(
                        onTap: () => _bukaLinkDrive(buktiUrl),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
                          child: Row(
                            children: [
                              Icon(Icons.insert_drive_file_outlined, color: Colors.blue.shade800, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text("Periksa Berkas Bukti (Google Drive)", style: TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade900))),
                              Icon(Icons.open_in_new_rounded, color: Colors.blue.shade800, size: 16)
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Manajemen Tombol Konfirmasi Aksi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red, side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
                            onPressed: () => _konfirmasiValidasi(context, item['id'], 'rejected'),
                            icon: const Icon(Icons.close_rounded, size: 16),
                            label: const Text("Tolak", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                            ),
                            onPressed: () => _konfirmasiValidasi(context, item['id'], 'approved'),
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: const Text("Verifikasi", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          )
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

  void _konfirmasiValidasi(BuildContext context, String pengajuanId, String tindakan) {
    Get.defaultDialog(
      title: tindakan == "approved" ? "Verifikasi Berkas" : "Tolak Berkas",
      titleStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
      content: Text(
        tindakan == "approved" 
          ? "Apakah berkas fisik siswa sudah sesuai dan siap mengikuti rangkaian uji materi?" 
          : "Tolak pengajuan berkas ini?",
        textAlign: TextAlign.center,
        style: const TextStyle(fontFamily: 'Nunito', fontSize: 14),
      ),
      textConfirm: "Ya, Benar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: tindakan == "approved" ? Colors.green : Colors.red,
      onConfirm: () {
        Get.back();
        controller.prosesValidasiBerkas(pengajuanId, tindakan);
      }
    );
  }
}