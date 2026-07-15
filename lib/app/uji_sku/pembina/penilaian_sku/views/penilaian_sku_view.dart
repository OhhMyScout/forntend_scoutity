import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/penilaian_sku_controller.dart';
import '../../../../modules/theme/theme.dart';

class PenilaianSkuView extends GetView<PenilaianSkuController> {
  const PenilaianSkuView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isDetailMode.value) {
          controller.backToSiswaList();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Obx(
            () => Text(
              controller.isDetailMode.value
                  ? "Evaluasi: ${controller.selectedSiswaName.value}"
                  : "Antrian Uji SKU",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          backgroundColor: AppTheme.primary,
          leading: Obx(
            () => controller.isDetailMode.value
                ? IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: controller.backToSiswaList,
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Get.back(),
                  ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (controller.isDetailMode.value) {
            return _buildDetailSoalSection();
          }
          return _buildDaftarSiswaSection();
        }),
      ),
    );
  }

  Widget _buildDaftarSiswaSection() {
    if (controller.isLoadingSiswa.value) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.secondary),
      );
    }

    if (controller.daftarSiswaList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => controller.fetchAntrianSiswa(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: Get.height * 0.25),
            const Icon(
              Icons.group_off_rounded,
              size: 70,
              color: AppTheme.outlineColor,
            ),
            const SizedBox(height: 16),
            const Text(
              "Belum Ada Anak Didik",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Tidak ada peserta didik berstatus 'approved' pada akun Kakak saat ini.",
              style: TextStyle(
                fontFamily: 'Urbanist',
                color: AppTheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.fetchAntrianSiswa(),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: controller.daftarSiswaList.length,
        itemBuilder: (context, index) {
          final siswa = controller.daftarSiswaList[index];
          final String fotoSiswa = siswa['image'] ?? "";

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: AppTheme.secondaryContainer,
                backgroundImage: fotoSiswa.isNotEmpty
                    ? NetworkImage(fotoSiswa)
                    : null,
                child: fotoSiswa.isEmpty
                    ? const Icon(Icons.person, color: AppTheme.primary)
                    : null,
              ),
              title: Text(
                siswa['fullname'] ?? "Peserta Didik",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              subtitle: Text(
                "Tingkat SKU: Penggalang ${siswa['tingkatan']}",
                style: const TextStyle(fontFamily: 'Urbanist', fontSize: 13),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.secondary,
              ),
              onTap: () {
                // Tahap selanjutnya: ketika diklik akan menampilkan detail soal progress
                controller.fetchDetailSoaSiswa(siswa);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSoalSection() {
    return Column(
      children: [
        Container(
          color: AppTheme.primary,
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 16,
            top: 4,
          ),
          child: Column(
            children: [
              TextField(
                onChanged: (value) => controller.searchQuery.value = value,
                style: const TextStyle(
                  color: AppTheme.primary,
                  fontSize: 14,
                  fontFamily: 'Urbanist',
                ),
                decoration: InputDecoration(
                  hintText: "Cari nomor poin atau deskripsi tugas...",
                  hintStyle: TextStyle(
                    color: AppTheme.outlineColor.withOpacity(0.6),
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppTheme.primary,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Obx(
                  () => Row(
                    children:
                        [
                          "Sedang Diajukan",
                          "Belum Diajukan",
                          "Semua Soal",
                        ].map((tabName) {
                          final bool isSelected =
                              controller.selectedTabFilter.value == tabName;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(
                                tabName,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.primary,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: AppTheme.primary,
                              backgroundColor: Colors.white,
                              showCheckmark: false,
                              onSelected: (val) {
                                if (val)
                                  controller.selectedTabFilter.value = tabName;
                              },
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingDetail.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.secondary),
              );
            }

            if (controller.filteredSoalList.isEmpty) {
              return const Center(
                child: Text(
                  "Tidak ada butir poin SKU dalam kategori filter ini.",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: AppTheme.outlineColor,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: controller.filteredSoalList.length,
              itemBuilder: (context, index) {
                var soal = controller.filteredSoalList[index];
                return _buildPoinPenilaianCard(soal);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPoinPenilaianCard(Map<String, dynamic> soal) {
    Color statusColor = AppTheme.outlineColor;
    String statusTeks = "Belum Uji";

    // Pemetaan status dari user_sku_progress secara akurat
    if (soal['status'] == 'Selesai') {
      statusColor = Colors.green;
      statusTeks = "Lulus (ACC)";
    } else if (soal['status'] == 'Menunggu Validasi') {
      statusColor = Colors.orange;
      statusTeks = "Menunggu Validasi";
    } else if (soal['status'] == 'Revisi') {
      statusColor = AppTheme.errorColor;
      statusTeks = "Butuh Revisi";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariantColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppTheme.surfaceContainerLow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Poin Soal ${soal['nomor_poin']}",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusTeks,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              soal['deskripsi'],
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),

          if (soal['bukti_url'] != null &&
              soal['status'] == "Menunggu Validasi") ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InkWell(
                onTap: () async {
                  final Uri url = Uri.parse(soal['bukti_url']);
                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    Get.snackbar("Error", "Gagal membuka link bukti digital.");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.open_in_new_rounded,
                        color: Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Lihat Lampiran Bukti: ${soal['bukti_url']}",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (soal['status'] == "Menunggu Validasi")
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => _showFormPenilaianDialog(
                      soal['progress_id'],
                      soal['nomor_poin'].toString(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Beri Keputusan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showFormPenilaianDialog(String progressId, String nomorPoin) {
    TextEditingController catatanController = TextEditingController();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Koreksi Ujian Poin $nomorPoin",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: catatanController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Masukkan instruksi perbaikan jika ditolak...",
                  hintStyle: const TextStyle(fontSize: 13),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.simpanPenilaian(
                        progressId,
                        "Revisi",
                        catatanController.text.trim(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                        padding: const EdgeInsets.symmetric(vertical: 12), // Tambah padding biar empuk
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Tolak",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => controller.simpanPenilaian(
                        progressId,
                        "Selesai",
                        catatanController.text.trim(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Lulus",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
