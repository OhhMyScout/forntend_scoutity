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
          style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white),
        )),
        backgroundColor: AppTheme.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // 1. BAR PENCARIAN & FILTER SOAL
          _buildSearchAndFilterBar(),

          // 2. KONTEN DAFTAR SOAL SKU
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.secondary));
              }

              if (controller.filteredSkuMasterList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off_rounded, size: 70, color: AppTheme.outlineColor.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      const Text(
                        "Soal Tidak Ditemukan",
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.searchQuery.value.isNotEmpty
                            ? "Tidak ada poin SKU cocok kata kunci '${controller.searchQuery.value}'"
                            : "Tidak ada soal dalam kategori filter ini.",
                        style: const TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: AppTheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
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
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 80),
                  itemCount: controller.filteredSkuMasterList.length,
                  itemBuilder: (context, index) {
                    var item = controller.filteredSkuMasterList[index];
                    String status = controller.getStatusPoin(item['id']);
                    
                    return _AnimatedListItem(
                      delay: index * 30, // Animasi stagerred dipercepat sedikit demi kenyamanan filter
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
          ),
        ],
      ),
    );
  }

  // Komponen Header Pencarian & Chip Pilihan Status
  Widget _buildSearchAndFilterBar() {
    return Container(
      color: AppTheme.primary,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 4),
      child: Column(
        children: [
          // Input Kolom Search Text
          TextField(
            onChanged: (value) => controller.searchQuery.value = value,
            style: const TextStyle(color: AppTheme.primary, fontSize: 14, fontFamily: 'Urbanist'),
            decoration: InputDecoration(
              hintText: "Cari nomor poin atau kata kunci tugas...",
              hintStyle: TextStyle(color: AppTheme.outlineColor.withOpacity(0.7), fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primary, size: 20),
              suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, color: AppTheme.outlineColor, size: 18),
                      onPressed: () {
                        controller.searchQuery.value = "";
                      },
                    )
                  : const SizedBox.shrink()),
              fillColor: Colors.white,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          
          // Deretan Horizontal Chips Filter Status
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Obx(() => Row(
              children: ["Semua", "Belum Uji", "Menunggu Verifikasi", "Lulus"].map((filterName) {
                final bool isSelected = controller.selectedFilter.value == filterName;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      filterName, 
                      style: TextStyle(
                        fontFamily: 'Nunito', 
                        fontSize: 12, 
                        fontWeight: FontWeight.bold,
                        // PERBAIKAN: Teks berwarna putih jika dipilih (kontras dengan primary), 
                        // dan berwarna primary/gelap jika tidak dipilih
                        color: isSelected ? Colors.white : AppTheme.primary,
                      ),
                    ),
                    selected: isSelected,
                    // PERBAIKAN: Latar belakang kontras
                    selectedColor: AppTheme.primary, // Warna saat aktif
                    backgroundColor: Colors.white,   // Warna putih bersih saat tidak aktif agar teks kelihatan jelas
                    checkmarkColor: Colors.white,
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppTheme.primary : AppTheme.outlineVariantColor
                      )
                    ),
                    onSelected: (bool selected) {
                      if (selected) controller.selectedFilter.value = filterName;
                    },
                  ),
                );
              }).toList(),
            )),
          )
        ],
      ),
    );
  }

  Widget _buildPoinCard({
    required String poinId,
    required String nomor,
    required String kategori,
    required String deskripsi,
    required String status,
  }) {
    Color statusColor;
    IconData statusIcon;
    String statusTextToShow;
    
    switch (status) {
      case "Selesai":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_rounded;
        statusTextToShow = "Lulus";
        break;
      case "Menunggu Validasi":
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_filled_rounded;
        statusTextToShow = "Menunggu Verifikasi";
        break;
      case "Revisi":
        statusColor = AppTheme.errorColor;
        statusIcon = Icons.refresh_rounded;
        statusTextToShow = "Butuh Revisi";
        break;
      default:
        statusColor = AppTheme.outlineColor;
        statusIcon = Icons.radio_button_unchecked_rounded;
        statusTextToShow = "Kosongan (Belum Uji)";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariantColor, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      child: Text(nomor, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    Text("Poin $nomor", style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: AppTheme.primary)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.secondaryContainer, borderRadius: BorderRadius.circular(100)),
                  child: Text(kategori, style: const TextStyle(fontFamily: 'Nunito', fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.onSecondaryContainer)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(deskripsi, style: const TextStyle(fontFamily: 'Urbanist', fontSize: 14, color: AppTheme.onSurfaceVariant, height: 1.5)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 18),
                    const SizedBox(width: 6),
                    Text(statusTextToShow, style: TextStyle(fontFamily: 'Nunito', fontSize: 13, fontWeight: FontWeight.bold, color: statusColor)),
                  ],
                ),
                if (status == "Belum Diuji" || status == "Revisi")
                  ElevatedButton(
                    onPressed: () => _showAjukanDialog(poinId, nomor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: status == "Revisi" ? AppTheme.errorColor : AppTheme.secondary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(status == "Revisi" ? "Perbaiki" : "Ajukan Uji", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  // =========================================================
  // REVISI DIALOG FORM PENGAJUAN UJIAN (DOKUMEN/FOTO/VIDEO FLEKSIBEL)
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
              // Judul Dialog
              Text(
                "Ajukan Ujian Poin $nomor",
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primary),
              ),
              const SizedBox(height: 12),
              
              // Teks Deskripsi Instruksi Fleksibel
              const Text(
                "Silakan lampirkan tautan bukti pendukung agar Pembina dapat memeriksa secara daring. Anda bisa menyertakan link dari Google Drive, YouTube, atau Cloud Storage lainnya.",
                style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: AppTheme.onSurfaceVariant, height: 1.4),
              ),
              const SizedBox(height: 16),

              // INDIKATOR FORMAT BUKTI YANG DIDUKUNG
              Wrap(
                spacing: 8.0, // Jarak horizontal antar badge
                runSpacing: 8.0, // Jarak vertikal jika badge turun ke bawah (pembungkus otomatis)
                alignment: WrapAlignment.start,
                children: [
                  _buildFileFormatBadge(Icons.insert_drive_file_rounded, "Dokumen/PDF", Colors.blue),
                  _buildFileFormatBadge(Icons.image_rounded, "Foto/Gambar", Colors.green),
                  _buildFileFormatBadge(Icons.video_camera_back_rounded, "Video Aksi", Colors.red),
                ],
              ),
              const SizedBox(height: 20),

              // Field Pengisian Tautan/Link Bukti
              TextField(
                controller: urlController,
                keyboardType: TextInputType.url,
                style: const TextStyle(fontFamily: 'Urbanist', fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Tempel link bukti (https://drive.google.com/...)",
                  hintStyle: TextStyle(color: AppTheme.outlineColor.withOpacity(0.6), fontSize: 13),
                  filled: true,
                  fillColor: AppTheme.surfaceContainerLow,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.secondary, width: 1.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.link_rounded, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 24),

              // Manajemen Tombol Aksi Kanan-Bawah
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Batal", style: TextStyle(color: AppTheme.outlineColor, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      String linkInput = urlController.text.trim();
                      
                      // Validasi input link kosong
                      if (linkInput.isEmpty) {
                        Get.snackbar(
                          "Kolom Kosong", 
                          "Tautan bukti wajib diisi sebelum mengirimkan pengajuan.",
                          backgroundColor: AppTheme.errorColor.withOpacity(0.9),
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Validasi skema URL standar (harus diawali http/https)
                      if (!linkInput.startsWith("http://") && !linkInput.startsWith("https://")) {
                        Get.snackbar(
                          "Format Salah", 
                          "Masukkan tautan URL internet yang valid (harus diawali dengan http:// atau https://).",
                          backgroundColor: Colors.orange.shade800,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // Kirim data ke API jika lolos validasi lokal HP
                      controller.ajukanUjian(skuId, linkInput);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Kirim Bukti", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget Bantuan Pembuatan Badge Format Bukti
  Widget _buildFileFormatBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label, 
            style: TextStyle(fontFamily: 'Nunito', fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

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
        double startPoint = delay / (400 + delay);
        double animationProgress = value > startPoint ? (value - startPoint) / (1 - startPoint) : 0.0;
        return Opacity(
          opacity: animationProgress,
          child: Transform.translate(offset: Offset(30 * (1 - animationProgress), 0), child: child),
        );
      },
      child: child,
    );
  }
}