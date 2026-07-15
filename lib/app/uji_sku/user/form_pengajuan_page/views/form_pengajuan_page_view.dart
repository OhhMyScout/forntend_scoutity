import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/form_pengajuan_page_controller.dart';
import '../../../../modules/theme/theme.dart';

class FormPengajuanView extends GetView<FormPengajuanController> {
  const FormPengajuanView({super.key});

  // Fungsi utilitas merubah Link Sharing Drive Biasa menjadi format Stream Preview
  String _convertDriveUrlToPreview(String url) {
    if (!url.contains("drive.google.com")) return "";
    try {
      if (url.contains("/view?usp=sharing") || url.contains("/view")) {
        final regExp = RegExp(r'/d/([^/]+)');
        final match = regExp.firstMatch(url);
        if (match != null && match.group(1) != null) {
          String fileId = match.group(1)!;
          return "https://drive.google.com/file/d/$fileId/preview";
        }
      }
    } catch (_) {}
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Jika Gudep kosong, blok layar dengan layar kosong transparan/loading selagi dialihkan
      if (!controller.isGudepValid.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.primary)));
      }

      return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text(
            'Form Pengajuan SKU', 
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: Colors.white)
          ),
          backgroundColor: AppTheme.primary, 
          elevation: 0, 
          centerTitle: true, 
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AnimatedInput(
                    delay: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.secondaryContainer.withOpacity(0.15), 
                        borderRadius: BorderRadius.circular(16), 
                        border: Border.all(color: AppTheme.secondaryContainer)
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.assignment_turned_in_rounded, color: AppTheme.onSecondaryContainer),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Lengkapi formulir di bawah ini. Pengajuan akan diteruskan ke Pembina yang memiliki nomor Gugus Depan sama dengan Anda.", 
                              style: TextStyle(fontFamily: 'Urbanist', fontSize: 13, color: AppTheme.onSecondaryContainer, height: 1.4)
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // --- FIELD NAMA LENGKAP ---
                  _AnimatedInput(delay: 50, child: _buildLabel("Nama Lengkap")),
                  _AnimatedInput(
                    delay: 100,
                    child: TextFormField(
                      controller: controller.namaController,
                      validator: (val) => val == null || val.isEmpty ? "Nama wajib diisi" : null,
                      decoration: _inputStyle("Masukkan nama lengkap...", Icons.person_rounded),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- FIELD GOLONGAN & TINGKAT ---
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _AnimatedInput(delay: 150, child: _buildLabel("Golongan")),
                            _AnimatedInput(
                              delay: 200,
                              child: Obx(() => DropdownButtonFormField<String>(
                                value: controller.selectedGolongan.value,
                                decoration: _inputStyle("", Icons.group_rounded),
                                items: controller.golonganList.map((String val) {
                                  return DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontSize: 12)));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) controller.selectedGolongan.value = val;
                                },
                              )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _AnimatedInput(delay: 150, child: _buildLabel("Tingkat")),
                            _AnimatedInput(
                              delay: 200,
                              child: Obx(() => DropdownButtonFormField<String>(
                                value: controller.selectedTingkat.value,
                                decoration: _inputStyle("", Icons.military_tech_rounded),
                                items: controller.tingkatList.map((String val) {
                                  return DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontSize: 12)));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) controller.selectedTingkat.value = val;
                                },
                              )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- FIELD PROVINSI ---
                  _AnimatedInput(delay: 250, child: _buildLabel("Provinsi")),
                  _AnimatedInput(
                    delay: 300,
                    child: TextFormField(
                      controller: controller.provinsiController,
                      enabled: false, 
                      style: const TextStyle(color: AppTheme.onSurfaceVariant, fontWeight: FontWeight.bold),
                      decoration: _inputStyle("Provinsi asal...", Icons.location_on_rounded).copyWith(
                        fillColor: AppTheme.surfaceContainerHighest, 
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- FIELD PILIH PEMBINA (DINAMIS BERDASARKAN GUDEP) ---
                  _AnimatedInput(delay: 350, child: _buildLabel("Pembina Penguji (Satu Gudep)")),
                  _AnimatedInput(
                    delay: 400,
                    child: Obx(() {
                      if (controller.isLoadingPembina.value) {
                        return const Center(child: LinearProgressIndicator(color: AppTheme.secondary));
                      }
                      
                      if (controller.pembinaDinamisList.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                          child: const Text("Tidak ditemukan Pembina terdaftar di Gudep Anda.", style: TextStyle(color: Colors.red, fontSize: 13)),
                        );
                      }

                      return DropdownButtonFormField<String>(
                        value: controller.selectedPembinaId.value.isEmpty ? null : controller.selectedPembinaId.value,
                        decoration: _inputStyle("Pilih Pembina Penguji...", Icons.assignment_ind_rounded),
                        items: controller.pembinaDinamisList.map((dynamic pembina) {
                          return DropdownMenuItem<String>(
                            value: pembina['id'].toString(),
                            child: Text(pembina['fullname'] ?? 'Tanpa Nama', style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) controller.selectedPembinaId.value = val;
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // --- FIELD LINK BUKTI GOOGLE DRIVE ---
                  _AnimatedInput(delay: 450, child: _buildLabel("Link Bukti Foto Fisik (Google Drive)")),
                  _AnimatedInput(
                    delay: 480,
                    child: TextFormField(
                      controller: controller.buktiUrlController,
                      onChanged: (value) => controller.buktiUrlController.text = value, // Pemicu render reaktif UI
                      validator: (val) => val == null || val.isEmpty ? "Tautan Google Drive mutlak diperlukan" : null,
                      decoration: _inputStyle("Masukkan Link Sharing Google Drive...", Icons.add_link_rounded),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- INSTANT LIVE PREVIEW BUKTI LINK DRIVE ---
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: controller.buktiUrlController,
                    builder: (context, value, child) {
                      String previewUrl = _convertDriveUrlToPreview(value.text.trim());
                      if (previewUrl.isEmpty) return const SizedBox.shrink();
                      
                      return Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.outlineVariantColor),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Pratinjau Dokumen Drive:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.insert_drive_file_outlined, size: 40, color: AppTheme.secondary),
                                      SizedBox(height: 8),
                                      Text("Tautan Terdeteksi. File siap di-upload & diarsip.", style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // --- TOMBOL SUBMIT ---
                  _AnimatedInput(
                    delay: 520,
                    child: SizedBox(
                      width: double.infinity, height: 55,
                      child: ElevatedButton(
                        onPressed: () => controller.submitPengajuan(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary, 
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                        ),
                        child: const Text(
                          "Kirim Pengajuan SKU", 
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(text, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.primary)),
    );
  }

  InputDecoration _inputStyle(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint, 
      hintStyle: const TextStyle(color: AppTheme.outlineColor, fontSize: 14),
      prefixIcon: Icon(icon, color: AppTheme.outlineColor),
      filled: true, 
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.outlineVariantColor, width: 1.5)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.outlineVariantColor, width: 1.5)),
      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.outlineVariantColor, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.secondary, width: 2)),
    );
  }
}

class _AnimatedInput extends StatelessWidget {
  final Widget child;
  final int delay;
  const _AnimatedInput({required this.child, required this.delay});
  
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1), 
      duration: Duration(milliseconds: 400 + delay), 
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        double start = delay / (400 + delay);
        double progress = value > start ? (value - start) / (1 - start) : 0.0;
        return Opacity(
          opacity: progress, 
          child: Transform.translate(offset: Offset(0, 20 * (1 - progress)), child: child)
        );
      },
      child: child,
    );
  }
}