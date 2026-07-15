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
      body: Obx(() => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _AnimatedFormItem(
                      delay: 0,
                      child: Text(
                        'Lengkapi Data Diri',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                    ),
                    const _AnimatedFormItem(
                      delay: 100,
                      child: Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 32),
                        child: Text(
                          'Mari bergabung menjadi pembina. Pastikan data yang dimasukkan valid.',
                          style: TextStyle(color: Color(0xFF504442)),
                        ),
                      ),
                    ),

                    /// DATA PRIBADI (Readonly/Disabled karena otomatis dari Session)
                    _AnimatedFormItem(
                      delay: 200,
                      child: _buildInputField(
                        controller: controller.namaController,
                        label: 'Nama Lengkap & Gelar',
                        icon: Icons.person,
                        backgroundColor: backgroundColor,
                        enabled: false, // Dikunci karena bawaan akun
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
                        enabled: false, // Dikunci karena bawaan akun
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

                    /// UPLOAD FOTO DENGAN PREVIEW
                    _AnimatedFormItem(
                      delay: 700,
                      child: _buildUploadBox(
                        title: 'Unggah Foto Pramuka Lengkap',
                        subtitle: '*Gunakan background asal sekolah',
                        icon: Icons.camera_alt,
                        backgroundColor: backgroundColor,
                        onTap: controller.pickFoto,
                        controller: controller,
                      ),
                    ),
                    const SizedBox(height: 32),

                    /// SYARAT & KETENTUAN
                    _AnimatedFormItem(
                      delay: 800,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: controller.isTermsAccepted.value,
                            onChanged: controller.toggleTerms,
                            activeColor: secondaryColor,
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
                      delay: 900,
                      child: GestureDetector(
                        onTap: controller.isLoading.value ? null : controller.submitForm,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: _embossedDecoration(backgroundColor),
                          child: Center(
                            child: Text(
                              controller.isLoading.value ? 'Mengirim...' : 'Kirim Pendaftaran',
                              style: const TextStyle(
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
            
            // Indikator Loading Overlay
            if (controller.isLoading.value)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(color: secondaryColor),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color backgroundColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return Container(
      decoration: _embossedDecoration(backgroundColor),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        enabled: enabled,
        style: TextStyle(color: enabled ? Colors.black87 : Colors.black45),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: enabled ? const Color(0xFF7D562D) : Colors.black45),
          prefixIcon: Icon(icon, color: enabled ? const Color(0xFF7D562D) : Colors.black45),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  // Widget Upload Box yang mendukung Preview File Lokal
  Widget _buildUploadBox({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
    required FormPembinaController controller,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _embossedDecoration(backgroundColor),
        child: Column(
          children: [
            if (controller.fotoFile.value != null) ...[
              // PREVIEW DARI IMAGE FILE LOKAL
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  controller.fotoFile.value!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Foto Berhasil Dimuat (Ketuk untuk ganti)',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              )
            ] else ...[
              // TAMPILAN DEFAULT JIKA BELUM ADA FILE YANG DIPILIH
              Icon(icon, size: 40, color: const Color(0xFF7D562D)),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF361F1A))),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF504442))),
            ],
          ],
        ),
      ),
    );
  }
}

class _AnimatedFormItem extends StatelessWidget {
  final Widget child;
  final int delay;

  const _AnimatedFormItem({required this.child, required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}