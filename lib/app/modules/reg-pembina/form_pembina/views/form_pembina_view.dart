import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/form_pembina_controller.dart'; 

class FormPembinaView extends StatelessWidget {
  const FormPembinaView({super.key});

  BoxDecoration _embossedDecoration(Color bgColor) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.brown.withOpacity(0.15),
          blurRadius: 10,
          offset: const Offset(4, 4),
        ),
        const BoxShadow(
          color: Colors.white,
          blurRadius: 10,
          offset: Offset(-4, -4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FormPembinaController());
    const primaryColor = Color(0xFF361F1A);
    const secondaryColor = Color(0xFF7D562D);
    const backgroundColor = Color(0xFFF3EBE1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: primaryColor),
        ),
        title: const Text(
          'Daftar Pembina',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AnimatedFormItem(
                delay: 0,
                child: const Text(
                  'Lengkapi Data Diri',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
                ),
              ),
              _AnimatedFormItem(
                delay: 100,
                child: const Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 32),
                  child: Text(
                    'Mari bergabung menjadi pembina. Pastikan data yang dimasukkan valid.',
                    style: TextStyle(color: Color(0xFF504442)),
                  ),
                ),
              ),

              /// DATA PRIBADI
              _AnimatedFormItem(
                delay: 200,
                child: _buildInputField(
                  controller: controller.namaController,
                  label: 'Nama Lengkap & Gelar',
                  icon: Icons.person,
                  backgroundColor: backgroundColor,
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
              ),
              const SizedBox(height: 20),

              _AnimatedFormItem(
                delay: 300,
                child: _buildInputField(
                  controller: controller.emailController,
                  label: 'Alamat Email',
                  icon: Icons.email,
                  backgroundColor: backgroundColor,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => !GetUtils.isEmail(value ?? '') ? 'Email tidak valid' : null,
                ),
              ),
              const SizedBox(height: 20),

              _AnimatedFormItem(
                delay: 400,
                child: _buildInputField(
                  controller: controller.noHpController,
                  label: 'Nomor Handphone / WA',
                  icon: Icons.phone,
                  backgroundColor: backgroundColor,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
              ),
              const SizedBox(height: 20),

              /// DATA SEKOLAH & GUDEP
              _AnimatedFormItem(
                delay: 500,
                child: _buildInputField(
                  controller: controller.sekolahController,
                  label: 'Asal Sekolah (Pangkalan)',
                  icon: Icons.school,
                  backgroundColor: backgroundColor,
                  validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                ),
              ),
              const SizedBox(height: 20),

              _AnimatedFormItem(
                delay: 600,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        controller: controller.gudepPaController,
                        label: 'Gudep Putra',
                        icon: Icons.boy,
                        backgroundColor: backgroundColor,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInputField(
                        controller: controller.gudepPiController,
                        label: 'Gudep Putri',
                        icon: Icons.girl,
                        backgroundColor: backgroundColor,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              /// UPLOAD FOTO
              _AnimatedFormItem(
                delay: 700,
                child: _buildUploadBox(
                  title: 'Unggah Foto Pramuka Lengkap',
                  subtitle: '*Gunakan background asal sekolah',
                  icon: Icons.camera_alt,
                  backgroundColor: backgroundColor,
                  onTap: controller.pickFoto,
                  fileNameWatcher: controller.fotoPath,
                ),
              ),
              const SizedBox(height: 20),

              /// UPLOAD DOKUMEN
              _AnimatedFormItem(
                delay: 800,
                child: _buildUploadBox(
                  title: 'Dokumen Pendukung',
                  subtitle: '*Format PDF/JPG maksimal 5MB',
                  icon: Icons.upload_file,
                  backgroundColor: backgroundColor,
                  onTap: controller.pickDokumen,
                  fileNameWatcher: controller.dokumenPath,
                ),
              ),
              const SizedBox(height: 32),

              /// SYARAT & KETENTUAN
              _AnimatedFormItem(
                delay: 900,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.isTermsAccepted.value,
                        onChanged: controller.toggleTerms,
                        activeColor: secondaryColor,
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          'Saya menyatakan bahwa data yang diisi adalah benar dan menyetujui seluruh syarat & ketentuan yang berlaku.',
                          style: TextStyle(color: primaryColor, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              /// TOMBOL SUBMIT
              _AnimatedFormItem(
                delay: 1000,
                child: GestureDetector(
                  onTap: controller.submitForm,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: _embossedDecoration(backgroundColor),
                    child: const Center(
                      child: Text(
                        'Kirim Pendaftaran',
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk input form bergaya timbul
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color backgroundColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: _embossedDecoration(backgroundColor),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF7D562D)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  // Helper widget untuk kotak upload file/foto
  Widget _buildUploadBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
    required RxString fileNameWatcher,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _embossedDecoration(backgroundColor),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF7D562D)),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF361F1A))),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF504442))),
            const SizedBox(height: 8),
            Obx(
              () => fileNameWatcher.value.isNotEmpty
                  ? Text(
                      'Terpilih: ${fileNameWatcher.value}',
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                      textAlign: TextAlign.center,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget Khusus untuk Animasi Staggered Slide & Fade in
class _AnimatedFormItem extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedFormItem({required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      // Durasi animasi + delay agar muncul berurutan (staggered)
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)), // Meluncur dari bawah ke atas
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}