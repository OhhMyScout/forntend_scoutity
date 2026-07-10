import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/form_pengajuan_page_controller.dart';
import '../../../../modules/theme/theme.dart';

class FormPengajuanView extends GetView<FormPengajuanController> {
  const FormPengajuanView({super.key});

  @override
  Widget build(BuildContext context) {
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
                      color: AppTheme.secondaryContainer.withValues(alpha: 0.15), 
                      borderRadius: BorderRadius.circular(16), 
                      border: Border.all(color: AppTheme.secondaryContainer)
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.assignment_turned_in_rounded, color: AppTheme.onSecondaryContainer),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Lengkapi formulir di bawah ini dengan menyertakan bukti autentik fisik untuk divalidasi oleh Tim Pembina Gugus Depan.", 
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
                                return DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontSize: 10)));
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
                                return DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontSize: 10)));
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

                // --- FIELD PROVINSI (DISABLED / READ ONLY) ---
                _AnimatedInput(delay: 250, child: _buildLabel("Provinsi")),
                _AnimatedInput(
                  delay: 300,
                  child: TextFormField(
                    controller: controller.provinsiController,
                    enabled: false, // Mematikan interaksi modifikasi input
                    style: const TextStyle(color: AppTheme.onSurfaceVariant, fontWeight: FontWeight.bold),
                    decoration: _inputStyle("Provinsi asal...", Icons.location_on_rounded).copyWith(
                      fillColor: AppTheme.surfaceContainerHighest, // Memberikan visual abu-abu tanda terkunci
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- FIELD PILIH PEMBINA ---
                _AnimatedInput(delay: 350, child: _buildLabel("Pilih Nama Pembina (Penguji)")),
                _AnimatedInput(
                  delay: 400,
                  child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedPembina.value,
                    decoration: _inputStyle("Pilih Pembina...", Icons.assignment_ind_rounded),
                    items: controller.pembinaList.map((String val) {
                      return DropdownMenuItem(value: val, child: Text(val, style: const TextStyle(fontSize: 14)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) controller.selectedPembina.value = val;
                    },
                  )),
                ),
                const SizedBox(height: 24),

                // --- INDIKATOR PERINGATAN FOTO DIRI IKON (!) ---
                _AnimatedInput(
                  delay: 450,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.errorColor.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.error_outline_rounded, color: AppTheme.errorColor, size: 22),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "PENTING: Foto harus tegak, menggunakan seragam Pramuka lengkap, wajah terlihat jelas tanpa penutup, dan pencahayaan terang.",
                            style: TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.errorColor, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // --- STRUKTUR VISUAL CONTOH FOTO DIRI ---
                _AnimatedInput(
                  delay: 480,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Contoh Standar Foto Diri Laporan:", style: TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                      const SizedBox(height: 8),
                      Container(
                        height: 150,
                        width: 110,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.outlineVariantColor),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ilustrasi siluet postur tubuh pasfoto resmi kepramukaan
                              const Icon(Icons.account_box_rounded, size: 100, color: AppTheme.outlineColor),
                              Positioned(
                                bottom: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(4)),
                                  child: const Text("PASFOTO 3X4", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // --- FIELD LINK BUKTI GOOGLE DRIVE ---
                _AnimatedInput(delay: 500, child: _buildLabel("Link Bukti Foto Diri (Google Drive)")),
                _AnimatedInput(
                  delay: 530,
                  child: TextFormField(
                    controller: controller.buktiUrlController,
                    validator: (val) => val == null || val.isEmpty ? "Tautan Google Drive mutlak diperlukan sebagai arsip bukti" : null,
                    decoration: _inputStyle("https://drive.google.com/...", Icons.add_link_rounded),
                  ),
                ),
                const SizedBox(height: 40),

                // --- TOMBOL SUBMIT ---
                _AnimatedInput(
                  delay: 560,
                  child: SizedBox(
                    width: double.infinity, height: 55,
                    child: ElevatedButton(
                      onPressed: () => controller.submitPengajuan(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                      ),
                      child: const Text(
                        "Kirim Laporan Ujian", 
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